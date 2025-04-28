import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../Login/login_screen.dart';

class Lot {
  String name;
  double latitude;
  double longitude;

  Lot({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class LotsInfo extends StatefulWidget {
  final int? numLots;
  final String? schoolName;

  const LotsInfo({Key? key, required this.numLots, required this.schoolName}) : super(key: key);

  @override
  _LotsInfoState createState() => _LotsInfoState();
}

class _LotsInfoState extends State<LotsInfo> {
  late List<TextEditingController> lotNameControllers;
  late List<TextEditingController> latitudeControllers;
  late List<TextEditingController> longitudeControllers;

  @override
  void initState() {
    super.initState();
    lotNameControllers = List.generate(widget.numLots!, (index) => TextEditingController());
    latitudeControllers = List.generate(widget.numLots!, (index) => TextEditingController());
    longitudeControllers = List.generate(widget.numLots!, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (final controller in [...lotNameControllers, ...latitudeControllers, ...longitudeControllers]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> handleSubmit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    for (int i = 0; i < widget.numLots!; i++) {
      if (lotNameControllers[i].text.trim().isEmpty ||
          latitudeControllers[i].text.trim().isEmpty ||
          longitudeControllers[i].text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all fields for Lot ${i + 1}.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (double.tryParse(latitudeControllers[i].text) == null ||
          double.tryParse(longitudeControllers[i].text) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid latitude or longitude for Lot ${i + 1}.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    final uid = user.uid;
    final ref = FirebaseDatabase.instance.ref('university_info');
    final schoolRef = ref.child(widget.schoolName!);
    final userRef = schoolRef.child('users/$uid');
    final lotRef = schoolRef.child('feed_lotInfo');

    List<Lot> lots = List.generate(widget.numLots!, (i) {
      return Lot(
        name: lotNameControllers[i].text.trim(),
        latitude: double.parse(latitudeControllers[i].text.trim()),
        longitude: double.parse(longitudeControllers[i].text.trim()),
      );
    });

    List<Map<String, dynamic>> lotData = lots.map((lot) => {
      'lotname': lot.name,
      'latitude': lot.latitude,
      'longitude': lot.longitude,
    }).toList();

    await lotRef.set({'lotInfo': lotData});
    await userRef.update({'exist': true});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Your School has been successfully added to the service"),
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Lot Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.numLots,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        TextField(
                          controller: lotNameControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Lot ${index + 1} Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: latitudeControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Latitude',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: longitudeControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Longitude',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await handleSubmit();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
