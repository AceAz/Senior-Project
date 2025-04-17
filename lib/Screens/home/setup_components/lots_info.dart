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
    // Initialize controllers for lot names, latitude, and longitude
    lotNameControllers = List.generate(widget.numLots!, (index) => TextEditingController());
    latitudeControllers = List.generate(widget.numLots!, (index) => TextEditingController());
    longitudeControllers = List.generate(widget.numLots!, (index) => TextEditingController());
  }

  @override
  void dispose() {
    // Dispose controllers
    for (final controller in [...lotNameControllers, ...latitudeControllers, ...longitudeControllers]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> handleSubmit() async  {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user is currently logged in.");
      return;
    }

    final uid = user.uid;  
    

    DatabaseReference ref = FirebaseDatabase.instance.ref('university_info');
    DatabaseReference ref2 = FirebaseDatabase.instance.ref('user_info/');
   

    
    List<Lot> lots = [];
    for (int i = 0; i < widget.numLots!; i++) {
      String name = lotNameControllers[i].text;
      double latitude = double.tryParse(latitudeControllers[i].text) ?? 0.0;
      double longitude = double.tryParse(longitudeControllers[i].text) ?? 0.0;

      lots.add(Lot(name: name, latitude: latitude, longitude: longitude));
    }


    

    List<Map<String, dynamic>> lotData = lots.map((lot) => {
      'lotname': lot.name,
      'latitude': lot.latitude,
      'longitude': lot.longitude,
    }).toList();

    await ref.child(uid).set({
      'name' : widget.schoolName,
      'lotInfo' : lotData,
    });

    await ref2.child(uid).update({
      'exist': true,
    });



    // Print the collected lot details
    lots.forEach((lot) {
      
      print("Lot Name: ${lot.name}, Latitude: ${lot.latitude}, Longitude: ${lot.longitude}");
    });

    // You can now push this data to Firebase or pass it along for further processing.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Your School has been successfully added to the service"),
        duration: Duration(seconds: 4), // Show for 2 seconds
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
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
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

