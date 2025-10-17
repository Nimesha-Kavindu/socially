import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially/services/auth/auth_servie.dart';
import 'package:socially/widgets/models/user_model.dart';
import 'package:socially/services/users/user_service.dart';
import 'package:socially/services/cloudinary_service.dart';
import 'package:socially/widgets/reusable/custom_button.dart';
import 'package:socially/widgets/reusable/custom_input.dart';
import 'package:socially/services/crypto/password_service.dart';

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
      // ✅ STEP 1: Create Firebase Auth user FIRST
      final userCredential = await AuthService().createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // ✅ STEP 2: Send verification email (NEW!)
      await userCredential.user!.sendEmailVerification();

      //store the user image in Cloudinary storage and get the download url
      if (_imageFile != null) {
      final imageUrl = await CloudinaryService().uploadImage(
        _imageFile!,
        'profile-images',
      );
      _imageUrlController.text = imageUrl;
    }

      // Hash the password before saving
      final hashedPassword = PasswordService.hashPassword(
        _passwordController.text,
      );

      //save user to firestore
      await UserService().saveUser(
        UserModel(
          userId: userCredential.user!.uid, // ✅ Use Firebase UID
          username: _nameController.text,
          email: _emailController.text,
          jobTitle: _jobTitleController.text,
          profileImageUrl: _imageUrlController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          password: hashedPassword,
          followers: 0,
        ),
      );
      
      print('✅ User saved to Firestore with UID: ${userCredential.user!.uid}');

      if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.email, color: Colors.blue),
              SizedBox(width: 8),
              Text('Check Your Email'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We sent a verification email to:',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                _emailController.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, 
                          color: Colors.orange.shade700, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Check Spam Folder!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'The email might be in your spam/junk folder.',
                      style: TextStyle(fontSize: 12, color: Colors.orange.shade900),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                '📧 Check your inbox\n'
                '📁 Check spam/junk folder\n'
                '⏰ May take 1-2 minutes\n'
                '🔗 Click the verification link',
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // StreamBuilder will show EmailVerificationScreen
              },
              child: const Text('OK, Got It!'),
            ),
          ],
        ),
      );
    }

      // StreamBuilder will detect auth change and route to EmailVerificationScreen
      print('✅ Registration successful, StreamBuilder will handle navigation');
    } catch (e) {
      print('Error signing up with email and password: $e');
      //show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing up with email and password: $e')),
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
                const Image(image: AssetImage('assets/logo.png'), height: 70),
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
                                    'https://i.stack.imgur.com/l60Hf.png',
                                  ),
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
