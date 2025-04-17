import 'package:flutter/material.dart';
//import 'package:park_wise/Screens/home/setup_components/school_info_form.dart';
import 'package:park_wise/services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import '../../home/home_page.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';



import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
    const SignUpForm({
    Key? key,
  }) : super(key: key);

   @override
  _SignUpFormState createState() => _SignUpFormState();

}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List<String> colleges = [];
  String? selectedCollege;
  int? selectedNumD;
  String? selectedCollege2;
  bool inUni = false;

  Future<void> fetchFilteredColleges(String query) async {
    final url = Uri.parse(
        'https://api.data.gov/ed/collegescorecard/v1/schools?school.name=$query&api_key=cantItaOTeTUfMeR9Xd6JQSVFSDxgRSbHkptvQR8&per_page=20');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      setState(() {
        colleges = results
            .map((item) => item['school']['name'].toString())
            .toSet() // remove duplicates
            .toList();
      });
    }
  }

  @override
  void initState() {
    searchController.addListener(() {
      final query = searchController.text;
      if (query.isNotEmpty) {
        fetchFilteredColleges(query);
      } else {
        setState(() {
          colleges = [];
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            controller: _email,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: _password,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),

          Container(
            height: 60,
            width: 300,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'University Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20),

            DropdownMenu<String>  (
              hintText: 'Select School',
              width: 300,
              dropdownMenuEntries: colleges
                  .map((e) => DropdownMenuEntry(value: e, label: e))
                  .toList(),
              onSelected: (value)  {
                setState(() async {
                   selectedCollege = value;
                   //selectedCollege2 = selectedCollege;
                   inUni =  await doesSchoolExist(selectedCollege!);
                   print(inUni);
                 });
              },
               menuStyle: MenuStyle(
                maximumSize: WidgetStateProperty.all(Size(300, 250)),
              ),
            ),
          
          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () async {
              if (selectedCollege == null) {
                // Show a message that the user needs to select a school
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select a school.")),
                );
                return;
              }
              
            
              
              AuthService().signup(
                email: _email.text, password: _password.text, 
                context: context,
                selectedCollege: selectedCollege!,
                exist: inUni
                );

              
              
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<bool> doesSchoolExist(String schoolName) async {
    final ref = FirebaseDatabase.instance.ref('university_info');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      for (final child in snapshot.children) {
        final data = child.value as Map<dynamic, dynamic>;
        if (data['name'] == schoolName) {
          return true;
        }
      }
    }

    return false; // Not found
  }
  
}