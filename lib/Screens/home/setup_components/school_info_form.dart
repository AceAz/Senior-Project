import 'package:flutter/material.dart';
import '../setup_components/lots_info.dart';

class SchoolInfoForm extends StatefulWidget {
final String? selectedSchool;

  const SchoolInfoForm({Key? key,  required this.selectedSchool}) : super(key: key);

  @override
  _SchoolInfoFormState createState() => _SchoolInfoFormState();
}

class _SchoolInfoFormState extends State<SchoolInfoForm> {
  List<String> colleges = [];
  String? selectedCollege;
  int? selectedNum;
  TextEditingController searchController = TextEditingController();

  List<int> numLots = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
   11, 12, 13, 14, 15, 16, 17, 18, 19, 20];


  

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
              }, 
              
              requestFocusOnTap: true,
              menuStyle: MenuStyle(
                maximumSize: WidgetStateProperty.all<Size>(
                  Size(300, 250),
                ),
              ),
            ),
            
            SizedBox(height: 20), 

            ElevatedButton(
              onPressed: () async{
                if (selectedNum == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select the number of parking lots.'),
                      backgroundColor: Color.fromRGBO(200, 0, 0, 0.5)
                    ),
                  );
                  return;
                }
              

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
}


