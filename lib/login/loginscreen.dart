import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart'; // Lottie animation package
import '../screen/user/user_screen.dart'; // Assuming you have a separate UserScreen widget
import '../screen/admin/admin_screen.dart'; // Assuming you have a separate AdminScreen widget

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Google Sign-in method
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
          // Navigate to AdminScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminScreen(user: user)),
          );
        } else {
          // Navigate to UserScreen for other users
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserScreen(user: user)),
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
      // Full-page background image
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/images/background.jpg"), // Path to your background image
                fit: BoxFit.cover, // Cover the whole screen
              ),
            ),
          ),
          // Content overlay on top of the background
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
               Lottie.asset(
                 'lib/assets/animation/welcom.json', // Lottie animation path
                 height: 200,
                 width: 200,
                 fit: BoxFit.cover,
               ), 

              const SizedBox(height: 20),

              // Welcome Text
              const Text(
                "Welcome to Lake Garden Banquet ",
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Subtitle Text
              const Text(
                "Reserve your dates effortlessly",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Google Sign-In Button
              ElevatedButton.icon(
                onPressed: signInWithGoogle,
                icon: Image.asset(
                  'lib/assets/images/google.png', // Google icon asset path
                  height: 24,
                  width: 24,
                ),
                label: const Text(
                  "Sign in with Google",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.black54,
                ),
              ),

              const SizedBox(height: 20),

              // Or continue text
              
            ],
          ),
        ],
      ),
    );
  }
}
