import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:park_wise/Screens/home/setup_components/school_info_form.dart';

import '../Screens/home/home_page.dart';
import '../Screens/Login/login_screen.dart';
import '../Screens/home/setup_components/school_not_supported_page.dart';

class AuthService {
  List<String> colleges = [];
  int? selectedNumD;
  String userRole = '';
    

  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context,
    required String selectedCollege,
    required bool exist
  }) async {

    try {

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      await getUniversityData(selectedCollege, exist);
      
      Navigator.pushReplacement(
        
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>  LoginScreen()
        )
      );

    }
     on FirebaseAuthException catch(e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
       Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account created. You can log in now."),
        duration: Duration(seconds: 2), 
      ),
    );
  }



  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context
  
    
  }) async {
    
    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      await Future.delayed(const Duration(seconds: 1));

      final userId = FirebaseAuth.instance.currentUser!.uid;
      final universityRef = FirebaseDatabase.instance.ref("university_info");
      final uniSnapshot = await universityRef.get();
      String? userUniversity;

      for (final uniEntry in uniSnapshot.children) {
        final usersNode = uniEntry.child('users');
        if (usersNode.hasChild(userId)) {
          userUniversity = uniEntry.key;
          break;
        }
      }
      final userRef = FirebaseDatabase.instance.ref("university_info/$userUniversity/users/$userId");

      final snapshot = await userRef.get();
        final data = snapshot.value as Map<dynamic, dynamic>;
        String role = data['role'];
        bool inUni = data['exist'];
      if (inUni) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const HomePage()
          )
        );
      }

      else if (role == 'student'){
         
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const SchoolNotSupportedPage()
            )
          );
        
      }
      else if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>  SchoolInfoForm(selectedSchool: userUniversity )
          )
        );
      }
      
    } 
    on FirebaseAuthException catch(e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      }
       Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
   
  }

  Future<void> signout({
    required BuildContext context
  }) async {
    
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>LoginScreen()
        )
      );
  }

  

 
  Future<void> getUniversityData(String selectedCollege, bool inUnu) async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final uid = user.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref('university_info');
    DatabaseReference selectedCollegeRef = ref.child(selectedCollege);
    DatabaseReference usersRef = selectedCollegeRef.child('users');

   
    final snapshot = await selectedCollegeRef.get();
    bool exists = snapshot.exists;

    if (!exists){
      await selectedCollegeRef.set({});
      
    }
    await usersRef.child(uid).set({
        'role': 'student',
        'exist': inUnu,
    }); 
  } 
}