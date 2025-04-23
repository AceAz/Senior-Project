import 'package:flutter/material.dart';
import '../../Login/login_screen.dart'; 

class SchoolNotSupportedPage extends StatefulWidget {
  const SchoolNotSupportedPage({super.key});

  @override
  State<SchoolNotSupportedPage> createState() => _SchoolNotSupportedPageState();
}

class _SchoolNotSupportedPageState extends State<SchoolNotSupportedPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notice"),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "Your school is not currently a part of this service.\n\n"
            "Please contact the developer at awadziaaron@gmail.com if you would like your school to be added.\n\n"
            "You will be redirected to login shortly...",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
