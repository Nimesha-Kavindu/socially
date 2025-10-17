import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Demo Home Page - shown after successful login
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current logged-in user
    final User? user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.purple,
        actions: [
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Sign out the user
              await FirebaseAuth.instance.signOut();
              print('✅ User signed out');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome text
            const Text(
              'Home Page',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Show user email if logged in
            if (user != null) ...[
              const Text(
                'Welcome!',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                user.email ?? 'No email',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'User ID: ${user.uid}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}