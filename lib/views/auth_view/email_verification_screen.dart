import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Email Icon
              const Icon(
                Icons.mark_email_unread_outlined,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 32),

              // 2. Title
              const Text(
                'Verify Your Email',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // 3. Instructions
              const Text(
                'We sent a verification email to:',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // 4. User's Email
              Text(
                user.email ?? 'No email',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 32),

              // 5. Resend Button (we'll add next)
              // Add this to your Column children
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    // Send verification email
                    await user.sendEmailVerification();

                    // Show success message
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            '✅ Verification email sent! Check your inbox.',
                          ),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  } catch (e) {
                    // Show error message
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('❌ Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.send),
                label: const Text('Resend Verification Email'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              // 6. Check Verification Button (we'll add next)
              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    // Step 1: Reload user data from Firebase
                    await user.reload();

                    // Step 2: Get updated user
                    final updatedUser = FirebaseAuth.instance.currentUser;

                    // Step 3: Check if verified
                    if (updatedUser != null && updatedUser.emailVerified) {
                      // Success! StreamBuilder will auto-redirect to HomePage
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✅ Email verified successfully!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }

                      // Force StreamBuilder to rebuild by triggering auth state
                      // This happens automatically, but we can force it:
                      await Future.delayed(const Duration(milliseconds: 500));
                    } else {
                      // Not verified yet
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '❌ Email not verified yet. Please check your inbox and click the link.',
                            ),
                            backgroundColor: Colors.orange,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('❌ Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.refresh),
                label: const Text('I Verified My Email'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              // 7. Logout Button (we'll add next)
              const SizedBox(height: 32),

              // Divider for visual separation
              const Divider(),

              const SizedBox(height: 16),

              // Logout button
              TextButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  // StreamBuilder will automatically redirect to LoginScreen
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Use Different Account',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
