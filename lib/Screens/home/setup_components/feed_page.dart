import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // for time formatting

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    
    
    final DatabaseReference ref = FirebaseDatabase.instance.ref('university_info');
    final snapshot = await ref.get();
    

    if (snapshot.exists) {
      List<Map<String, dynamic>> loadedPosts = [];
      String? userUniversityName;

      final data = Map<String, dynamic>.from(snapshot.value as Map);

      data.forEach((userId, entry) {
        if (userId == uid) {
          userUniversityName = entry['name'] ?? 'Unknown';
        }

        final universityName = entry['name'] ?? 'Unknown';

        if (userUniversityName == universityName){
          final lotInfo = entry['lotInfo'] ?? {};
        

          if (lotInfo is List){
            for(var lot in lotInfo){
              if (lot is Map){
                loadedPosts.add({
                  'lotName': lot['lotname'] ?? 'Unnamed Lot',
                  'status': lot['parkingStatus'] ?? 'unknown',
                  'time': lot['lastUpdated'] ?? 'N/A',
                  
                });
                
              }
            }
          }
        }
        
      loadedPosts.sort((a, b) {
        final aTime = DateTime.tryParse(a['time'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = DateTime.tryParse(b['time'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime); // descending: latest first
      });

 
      });

      setState(() {
        posts = loadedPosts;
        isLoading = false;
      });
    }
    
    else {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatTime(String isoTime) {
    try {
      final dateTime = DateTime.parse(isoTime);
      return DateFormat.yMMMd().add_jm().format(dateTime);
    } catch (e) {
      return isoTime;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return Colors.green;
      case 'Limited':
        return Colors.orange;
      case 'Full':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void>_refresh()async{
    await fetchPosts(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parking Feed')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
           :posts.isEmpty
              ? const Center(child: Text("No updates yet"))
              : RefreshIndicator(
                  onRefresh: _refresh,
                child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.local_parking, color: getStatusColor(post['status'])),
                          title: Text(post['lotName']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Status: ${post['status']}"),
                              Text("Last updated: ${formatTime(post['time'])}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ),
    );
  }
}
