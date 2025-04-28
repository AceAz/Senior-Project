import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; 
import 'package:google_maps_flutter/google_maps_flutter.dart';


class FeedPage extends StatefulWidget {
  
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;
  String? schoolName;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final uref = FirebaseDatabase.instance.ref('university_info');
    final snapshot = await uref.get();

    if (snapshot.exists) {
      for (final school in snapshot.children) {
        final uniName = school.key;
        final users = school.child('users');
        if (users.hasChild(uid!)) {
          setState(() {
            schoolName = uniName;
          });
           
        }
      }
    }



    if (schoolName == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final DatabaseReference ref = FirebaseDatabase.instance
        .ref('university_info/$schoolName/feed_lotInfo/lotInfo');

    try {
      final snapshot = await ref.get();

      if (!snapshot.exists) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      List<Map<String, dynamic>> loadedPosts = [];

      for (final child in snapshot.children) {
        final data = child.value;
        if (data is Map) {
          loadedPosts.add({
            'lotName': data['lotname'] ?? 'Unnamed Lot',
            'status': data['parkingStatus'] ?? 'Unknown',
            'time': data['lastUpdated'] ?? 'N/A',
            'latitude': data['latitude'] ?? 'N/A',
            'longitude': data['longitude'] ?? 'N/A',
          });
        }
      }

      loadedPosts.sort((a, b) {
        final aTime = DateTime.tryParse(a['time'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = DateTime.tryParse(b['time'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime); // latest first
      });

      setState(() {
        posts = loadedPosts;
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }


  String formatTime(String isoTime) {
    try {
      final dateTime = DateTime.parse(isoTime).toLocal();
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(schoolName != null ? '$schoolName' : 'Parking Feed'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : posts.isEmpty
              ? const Center(child: Text("No updates yet"))
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final latitude = post['latitude'];
                      final longitude = post['longitude'];

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
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
                              const SizedBox(height: 8),
                              if (latitude != null &&
                                  longitude != null &&
                                  latitude is num &&
                                  longitude is num)
                                Container(
                                  height: 200,
                                  child: GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(latitude.toDouble(), longitude.toDouble()),
                                      zoom: 16.0,
                                    ),
                                    markers: {
                                      Marker(
                                        markerId: MarkerId(post['lotName']),
                                        position: LatLng(latitude.toDouble(), longitude.toDouble()),
                                        infoWindow: InfoWindow(
                                          title: post['lotName'],
                                          snippet: post['status'],
                                        ),
                                      ),
                                    },
                                    myLocationEnabled: false,
                                    zoomControlsEnabled: false,
                                    liteModeEnabled: true,
                                  ),
                                ),
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
