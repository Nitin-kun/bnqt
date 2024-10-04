import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../login/loginscreen.dart'; // Adjust the import path as needed

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  Future<void> _signOut(BuildContext context) async {
    try {
      // Check if the user is signed in with Google
      GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        // If signed in with Google, disconnect from Google
        await googleSignIn.disconnect();
      }
      
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Navigate to the LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      // Show error if sign-out fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing out: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.photoURL != null)
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.photoURL!), // Display user's profile picture
              ),
            const SizedBox(height: 16),
            Text(
              'Name: ${user.displayName ?? "No Name"}', // Display user's name
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${user.email}', // Display user's email
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _signOut(context), // Call the sign-out function
              child: const Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
