//import 'dart:convert';

//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';



import '../setup_components/lots_info.dart';

import 'package:firebase_database/firebase_database.dart';






class SchoolInfoForm extends StatefulWidget {
final String? selectedSchool;

  const SchoolInfoForm({Key? key,  required this.selectedSchool}) : super(key: key);

  @override
  _SchoolInfoFormState createState() => _SchoolInfoFormState();
}

class _SchoolInfoFormState extends State<SchoolInfoForm> {
  List<String> colleges = [];
  String? selectedCollege;
  //int? selectedNumD;
  int? selectedNum;
  TextEditingController searchController = TextEditingController();

  List<int> numLots = [1, 2, 3, 4, 5, 6];


  

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('School Information')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
           
            SizedBox(height: 20),
            DropdownMenu(
              hintText: 'Number of Parking Lots',
              width: 300,
              dropdownMenuEntries: numLots.map((e) => DropdownMenuEntry(value: e, label: e.toString())).toList(),
              onSelected: (value){
                setState(() {
                  selectedNum = value;
                });
                debugPrint('Value: $value');
              }, 
              
              //enableSearch: true,
              requestFocusOnTap: true,
              //enableFilter: true,

              menuStyle: MenuStyle(
                maximumSize: WidgetStateProperty.all<Size>(
                  Size(300, 250), // Adjust height for ~5 items (each ~48px)
                ),
              ),
            ),
            
            SizedBox(height: 20), 

            ElevatedButton(
              onPressed: () async{
                await setNumLots();
              

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return  LotsInfo(numLots: selectedNum, schoolName: widget.selectedSchool );
                      
                    },
                  ),
                );
              },
              child: Text(
                "Next".toUpperCase(),
              ),
            ),
          ],
        ),
      ),
    );
  }

 Future<void> setNumLots() async {

  DatabaseReference ref = FirebaseDatabase.instance.ref("university_info");

    try {
        await ref.push().set({
          'numLots': selectedNum,
        });
        print("Num of lots added.");
      
      
      
    }

    catch (e) {
      print("Error storing data: $e");
    }
  }

  

}


