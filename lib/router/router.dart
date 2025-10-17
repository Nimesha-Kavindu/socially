import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socially/views/auth_view/login.dart';
import 'package:socially/views/auth_view/register.dart';
import 'package:socially/views/home_view/home_page.dart';

class RouterClass{
  final router = GoRouter(
    initialLocation: "/",
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                "Page Not Found: ${state.uri}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      );
    },
    routes: [
      // Root route - Auth Gate with StreamBuilder (Option B)
      // Listens to Firebase Auth state changes in real-time
      GoRoute(
        path: '/',
        builder: (context, state) {
          return StreamBuilder<User?>(
            // Listen to auth state changes continuously
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              // Show loading spinner while checking auth
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              // If user data exists, user is logged in
              if (snapshot.hasData) {
                print('✅ User logged in: ${snapshot.data?.email}');
                return const HomePage();
              }
              
              // If no user data, user is logged out
              print('❌ No user logged in, showing login screen');
              return LoginScreen();
            },
          );
        },
      ),
      
      // Login page route
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginScreen(),
      ),
      
      // Register page route
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => RegisterScreen(),
      ),
      
      // Home page route (after successful login)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      
      // Alternative route name for consistency
      // Some of your code uses '/main-screen'
      GoRoute(
        path: '/main-screen',
        name: 'main-screen',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}