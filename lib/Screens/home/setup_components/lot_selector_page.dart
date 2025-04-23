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
  String? userUniversity;

  @override
  void initState() {
    super.initState();
    getLotFromDatabase ();
  }

  Future<void> getLotFromDatabase () async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return;
    }

    final universityRef = FirebaseDatabase.instance.ref('university_info');

    try {
      final uniSnapshot = await universityRef.get();

      for (final uniEntry in uniSnapshot.children) {
        final usersNode = uniEntry.child('users');
        if (usersNode.hasChild(uid)) {
          userUniversity = uniEntry.key;
          break;
        }
      }

      if (userUniversity == null){
        return;
      }

      final lotRef = universityRef.child('$userUniversity/feed_lotInfo/lotInfo');
      final lotRefSnapshot = await lotRef.get();

      if (!lotRefSnapshot.exists) {
        if (!mounted) return;
        setState(() {
          lots = [];
          isLoading = false;
        });
        return;
      }


      List<Map<dynamic, dynamic>> loadedLots = [];
      for (final child in lotRefSnapshot.children) {
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

    catch (e) {
      if (!mounted) return;
      setState(() {
        lots = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Select a Lot")),
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
                            builder: (context) => LotFormPage(index:index, schoolName: userUniversity),
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
