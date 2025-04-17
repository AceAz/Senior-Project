import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // for time formatting

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('university_info');
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final snapshot = await _ref.get();

    if (snapshot.exists) {
      List<Map<String, dynamic>> loadedPosts = [];

      final data = Map<String, dynamic>.from(snapshot.value as Map);

      data.forEach((userId, entry) {
        final universityName = entry['name'] ?? 'Unknown';
        final lotInfo = entry['lotInfo'] ?? {};

        loadedPosts.add({
          'university': universityName,
          'status': lotInfo['parkingStatus'] ?? 'unknown',
          'time': lotInfo['lastUpdated'] ?? 'N/A',
        });
      });

      setState(() {
        posts = loadedPosts;
        isLoading = false;
      });
    } else {
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
      case 'available':
        return Colors.green;
      case 'limited':
        return Colors.orange;
      case 'full':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parking Feed')),
      body: //isLoading
         // ? const Center(child: CircularProgressIndicator())
           posts.isEmpty
              ? const Center(child: Text("No updates yet"))
              : ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: Icon(Icons.local_parking, color: getStatusColor(post['status'])),
                        title: Text(post['university']),
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
    );
  }
}
