import 'package:flutter/material.dart';
import 'package:park_wise/services/auth_services.dart';


class SignoutFrom extends StatelessWidget {
  const SignoutFrom({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              AuthService().signout(context: context);
              },
            child: Text(
              "Sign out".toUpperCase(),
            ),
          )
        ]
      )
    );
  }
}