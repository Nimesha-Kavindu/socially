import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially/utils/functions/mood.dart';

class Post {
  final String postId;
  final String postCaption;
  final Mood mood;
  final String userId;
  final String userName;
  final String userProfileImageUrl;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final String postImageUrl;

  Post({
    required this.postId,
    required this.postCaption,
    required this.mood,
    required this.userId,
    required this.userName,
    required this.userProfileImageUrl,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    required this.postImageUrl,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['postId'],
      postCaption: json['postCaption'],
      mood: MoodExtention.fromString(json['mood']?? 'Happy'),
      userId: json['userId'],
      userName: json['userName'],
      userProfileImageUrl: json['userProfileImageUrl'],
      likesCount: json['likesCount'],
      commentsCount: json['commentsCount'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      postImageUrl: json['postImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'postCaption': postCaption,
      'mood': mood.name,
      'userId': userId,
      'userName': userName,
      'userProfileImageUrl': userProfileImageUrl,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'postImageUrl': postImageUrl,
    };
  }
}
