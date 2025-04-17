import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:park_wise/Screens/home/home_page.dart';

class LotFormPage extends StatefulWidget {
  const LotFormPage({Key? key}) : super(key: key);

  @override
  _LotFormPageState createState() => _LotFormPageState();
}

class _LotFormPageState extends State<LotFormPage> {
  String status = '';


  Future<void> handleSubmit(String status) async  {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user is currently logged in.");
      return;
    }

    final uid = user.uid;  
    

    DatabaseReference ref = FirebaseDatabase.instance.ref('university_info/$uid/lotInfo');
    //DatabaseReference ref2 = FirebaseDatabase.instance.ref('user_info/');

    final timestamp = DateTime.now().toIso8601String();
   


    await ref.child(uid).update({
      'parkingStatus': status,
      'lastUpdated': timestamp
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lot Form Page"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadioListTile(
            title: Text('Available'),
            value: 'Available', 
            subtitle: Text('You’ll have no trouble finding a spot') ,
            groupValue: status, 
            onChanged: (value) {
              setState(() {
                status = value.toString();
              });
            }
          ),

          RadioListTile(
            title: Text('Limited'),
            value: 'limited',
            subtitle: Text('Some spots still open') ,
            groupValue: status, 
            onChanged: (value) {
              setState(() {
                status = value.toString();
              });
            }
          ),

          RadioListTile(
            title: Text('Full'),
            value: 'full', 
            subtitle: Text('Lot is currently full') ,
            groupValue: status, 
            onChanged: (value) {
              setState(() {
                status = value.toString();
              });
            }
          ),

            ElevatedButton(
              onPressed: () async {
                await handleSubmit(status );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              
              
              child: const Text("Post"),

            ),           
        ],
      )
    );
  }
}