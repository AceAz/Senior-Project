import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Login/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Future<String?> getSchoolNameForCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final uid = user.uid;
    final databaseRef = FirebaseDatabase.instance.ref('university_info');
    final snapshot = await databaseRef.get();

    if (snapshot.exists) {
      final schools = snapshot.children;
      for (final school in schools) {
        final usersRef = school.child('users');
        if (usersRef.hasChild(uid)) {
          return school.key;
        }
      }
    }
    return null;
  }


  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final schoolName = await getSchoolNameForCurrentUser();

    if (schoolName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to find your school. Try again later."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final userRef = FirebaseDatabase.instance
          .ref('university_info/$schoolName/users/$uid');
      await userRef.remove();

      await FirebaseAuth.instance.currentUser?.delete();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account deleted successfully."),
          backgroundColor: Colors.red,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Failed to delete account.";
      if (e.code == 'requires-recent-login') {
        message = "Please log in again to delete your account.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text('Delete Account'),
              onPressed: () => _deleteAccount(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
