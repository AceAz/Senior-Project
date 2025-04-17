import 'package:flutter/material.dart';

class SchoolNotSupportedPage extends StatelessWidget {
  const SchoolNotSupportedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notice")),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "Your school is not currently a part of this service.\n\n"
            "Please contact Aaron if you would like your school to be added.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
