import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../setup_components/lot_form_page.dart';

class LotSelectorPage extends StatefulWidget {
  const LotSelectorPage({Key? key}) : super(key: key);

  @override
  _LotSelectorPageState createState() => _LotSelectorPageState();
}

class _LotSelectorPageState extends State<LotSelectorPage> {
  List<Map<dynamic, dynamic>> lots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getLotFromDatabase ();
  }

  Future<void> getLotFromDatabase () async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      print('No user logged in');
      return;
    }

    final uniRef = FirebaseDatabase.instance.ref('university_info');
    final uniSnapshot = await uniRef.get();
    final currentUserEntry = uniSnapshot.child(uid);
    final currentUserSchoolName = currentUserEntry.child('name').value as String?;

    final currentUserRef = currentUserEntry.child('lotInfo');

    if (currentUserRef.exists) {
      List<Map<dynamic, dynamic>> loadedLots = [];

      for (final child in currentUserRef.children) {
        final data = child.value;
        if (data is Map<dynamic, dynamic>) {
          loadedLots.add(data);
        }
      }

      if (!mounted) return;
      setState(() {
        lots = loadedLots;
        isLoading = false;
      });
    } else {
      for (final userEntry in uniSnapshot.children) {
        if (userEntry.child('name').value == currentUserSchoolName) {
          final lotInfoSnap = userEntry.child('lotInfo');
          if (lotInfoSnap.exists) {
            await FirebaseDatabase.instance.ref('university_info/$uid/lotInfo').set(lotInfoSnap.value);
            print('Copied lot info from another user with same school');
            // Re-fetch once
            final newSnapshot = await FirebaseDatabase.instance.ref('university_info/$uid/lotInfo').get();
            if (newSnapshot.exists) {
              List<Map<dynamic, dynamic>> loadedLots = [];
              for (final child in newSnapshot.children) {
                final data = child.value;
                if (data is Map<dynamic, dynamic>) {
                  loadedLots.add(data);
                }
              }

              if (!mounted) return;
              setState(() {
                lots = loadedLots;
                isLoading = false;
              });
            }
            return;
          }
        }
      }

      if (!mounted) return;
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select a Lot")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: lots.length,
                itemBuilder: (context, index) {
                  final lot = lots[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LotFormPage(index:index),
                          ),
                        );
                      },
                      child: Text(lot['lotname'] ?? 'Unnamed Lot'),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
