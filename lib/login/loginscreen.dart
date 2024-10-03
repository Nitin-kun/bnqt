import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screen/user_homescreen.dart'; // Assuming you have a separate UserHomeScreen widget
import '../screen/admin_homescreen.dart'; // Assuming you have a separate AdminHomeScreen widget

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Future<void> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      // Obtain the authentication details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential using the token from Google
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google User Credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Access the user details from UserCredential
      final User? user = userCredential.user;

      if (user != null) {
        final String? email = user.email;

        // Check if the email is "nitin.gml1@gmail.com"
        if (email == "nitin.gml1@gmail.com") {
          // Navigate to AdminHomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
          );
        } else {
          // Navigate to UserHomeScreen for other users
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserHomeScreen()),
          );
        }
      }
    } catch (e) {
      print('Sign in failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: signInWithGoogle, // Trigger Google sign-in on button press
          child: const Text('Let\'s Start'),
        ),
      ),
    );
  }
}
