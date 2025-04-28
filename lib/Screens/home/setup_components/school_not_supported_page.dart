import 'package:flutter/material.dart';
import '../../Login/login_screen.dart'; 

class SchoolNotSupportedPage extends StatelessWidget {
  const SchoolNotSupportedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notice"),
        automaticallyImplyLeading: false, // Hides the back arrow
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Your school is not currently a part of this service.\n\n"
                "Please contact the developer at awadziaaron@gmail.com if you would like your school to be added.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
