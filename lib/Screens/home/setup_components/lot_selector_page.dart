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

    final ref = FirebaseDatabase.instance.ref('university_info/$uid/lotInfo');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      List<Map<dynamic, dynamic>> loadedLots = [];
      for (final child in snapshot.children) {
        final data = child.value as Map<dynamic, dynamic>;
        loadedLots.add(data);
      }

      setState(() {
        lots = loadedLots;
        isLoading = false;
      });
    } 
    else {
      setState(() {
        isLoading = false;
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
                            builder: (context) => LotFormPage(),
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
