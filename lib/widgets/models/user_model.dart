import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String username;
  final String email;
  final String jobTitle;
  final String profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String password;
  final int followers;

  UserModel({required this.userId, required this.username, required this.email, required this.jobTitle, required this.profileImageUrl, required this.createdAt, required this.updatedAt, required this.password, required this.followers});

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      jobTitle: data['jobTitle'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      password: data['password'],
      followers: data['followers'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'jobTitle': jobTitle,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'password': password,
      'followers': followers,
    };
  }

}