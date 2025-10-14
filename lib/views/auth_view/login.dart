import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/widgets/reusable/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(120, 0, 0, 20),
                child: Image.asset("assets/logo.png"),
              ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: "E-mail",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegex = RegExp(
                          r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.trim().length <= 6) {
                          return 'Password must be more than 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ReusableButton(
                    text: "Log In",
                    width: 350,
                    onPressed: () {
                      //TODO: Implement login functionality
                    },
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      GoRouter.of(context).go("/register");
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  ReusableButton(text: "Sign in with Google", width: 350, onPressed: (){})
                ],
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}
