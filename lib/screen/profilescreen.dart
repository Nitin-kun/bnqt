import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for User

class ProfileScreen extends StatelessWidget {
  final User user; // Accept the user data

  const ProfileScreen({super.key, required this.user});

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
          ],
        ),
      ),
    );
  }
}
