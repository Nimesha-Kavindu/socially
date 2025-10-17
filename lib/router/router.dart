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
      // Root route - checks auth and redirects accordingly
      GoRoute(
        path: '/',
        redirect: (context, state) {
          // Get current user from Firebase Auth
          final user = FirebaseAuth.instance.currentUser;
          
          // If user is logged in, go to home
          if (user != null) {
            print('✅ User logged in, redirecting to /home');
            return '/home';
          }
          
          // If user is logged out, go to login
          print('❌ No user logged in, redirecting to /login');
          return '/login';
        },
        builder: (context, state) {
          // This builder is required but never shows
          // because we always redirect
          return const SizedBox.shrink();
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