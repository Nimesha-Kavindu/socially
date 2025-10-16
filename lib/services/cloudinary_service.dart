
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final cloudinary = CloudinaryPublic(
    'dcdjqjcvm', // Your Cloudinary cloud name
    'socially_unsigned', // Your unsigned upload preset (create this in Cloudinary dashboard)
    cache: false,
  );

  /// Uploads an image file to Cloudinary and returns the URL
  /// [imageFile] - The image file to upload
  /// [folder] - The folder in Cloudinary (e.g., 'profile-images', 'post-images', 'reels')
  Future<String> uploadImage(File imageFile, String folder) async {
    try {
      print('📤 Uploading to Cloudinary folder: $folder');
      
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
          folder: folder,
        ),
      );
      
      print('✅ Upload successful: ${response.secureUrl}');
      return response.secureUrl;
      
    } catch (e) {
      print('❌ Error uploading to Cloudinary: $e');
      return '';
    }
  }

  /// Uploads a video file to Cloudinary and returns the URL
  /// [videoFile] - The video file to upload
  /// [folder] - The folder in Cloudinary (e.g., 'reels', 'videos')
  Future<String> uploadVideo(File videoFile, String folder) async {
    try {
      print('📤 Uploading video to Cloudinary folder: $folder');
      
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          videoFile.path,
          resourceType: CloudinaryResourceType.Video,
          folder: folder,
        ),
      );
      
      print('✅ Video upload successful: ${response.secureUrl}');
      return response.secureUrl;
      
    } catch (e) {
      print('❌ Error uploading video to Cloudinary: $e');
      return '';
    }
  }
}
