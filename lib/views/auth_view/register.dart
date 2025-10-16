import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially/widgets/models/user_model.dart';
import 'package:socially/services/users/user_service.dart';
import 'package:socially/services/users/user_storage.dart';
import 'package:socially/widgets/reusable/custom_button.dart';
import 'package:socially/widgets/reusable/custom_input.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  File? _imageFile;

  // Pick an image from the gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Sign up with email and password
  Future<void> _createUser(BuildContext context) async {
    try {
      //store the user image in storage and get the download url
      if (_imageFile != null) {
        final imageUrl = await UserProfileStorageService().uploadImage(
          profileImage: _imageFile!,
          userEmail: _emailController.text,
        );
        _imageUrlController.text = imageUrl;
      }

      //save user to firestore
      UserService().saveUser(
        UserModel(
          userId: "",
          username: _nameController.text,
          email: _emailController.text,
          jobTitle: _jobTitleController.text,
          profileImageUrl: _imageUrlController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          password: _passwordController.text,
          followers: 0,
        ),
      );

      //show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User created successfully'),
        ),
      );

      GoRouter.of(context).go('/main-screen');
    } catch (e) {
      print('Error signing up with email and password: $e');
      //show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing up with email and password: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Image(
                  image: AssetImage('assets/logo.png'),
                  height: 70,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          _imageFile != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage: FileImage(_imageFile!),
                                  backgroundColor: Colors.purple,
                                )
                              : const CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                      'https://i.stack.imgur.com/l60Hf.png'),
                                  backgroundColor: Colors.purple,
                                ),
                          Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.add_a_photo),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ReusableInput(
                        controller: _nameController,
                        hintText: 'Name',
                        icon: Icons.person,
                        obsecureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ReusableInput(
                        controller: _emailController,
                        hintText: 'Email',
                        icon: Icons.email,
                        obsecureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ReusableInput(
                        controller: _jobTitleController,
                        hintText: 'Job Title',
                        icon: Icons.work,
                        obsecureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your job title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ReusableInput(
                        controller: _passwordController,
                        hintText: 'Password',
                        icon: Icons.lock,
                        obsecureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ReusableInput(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        icon: Icons.lock,
                        obsecureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ReusableButton(
                        text: 'Sign Up',
                        width: MediaQuery.of(context).size.width,
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await _createUser(context);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          // Navigate to login screen
                          GoRouter.of(context).go('/login');
                        },
                        child: const Text(
                          'Already have an account? Log in',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}