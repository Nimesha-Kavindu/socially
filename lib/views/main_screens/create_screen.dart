import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

/// Create post screen - Instagram style
/// Supports both images and videos
/// Step 1: Select media from gallery or camera
/// Step 2: Preview and edit media
/// Step 3: Add caption and post (Next button leads here)
class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  File? _selectedMedia;
  bool _isVideo = false;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _isLoading
          ? _buildLoadingIndicator()
          : _selectedMedia == null
              ? _buildMediaSelector()
              : _buildMediaPreview(),
    );
  }

  /// AppBar with Cancel and Next buttons
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      leading: _selectedMedia != null
          ? IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                _clearSelection();
              },
            )
          : null,
      title: const Text(
        'New Post',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      actions: [
        if (_selectedMedia != null)
          TextButton(
            onPressed: _goToCaption,
            child: const Text(
              'Next',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  /// Clear selected media and dispose video controller
  void _clearSelection() {
    setState(() {
      _selectedMedia = null;
      _isVideo = false;
    });
    _videoController?.dispose();
    _videoController = null;
  }

  /// Loading indicator
  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white),
    );
  }

  /// Initial screen - Choose photo source
  Widget _buildMediaSelector() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Camera icon
          const Icon(
            Icons.photo_camera_outlined,
            size: 120,
            color: Colors.white54,
          ),
          const SizedBox(height: 32),

          // Title
          const Text(
            'Create New Post',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          const Text(
            'Share photos and videos',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 48),

          // Gallery button
          _buildActionButton(
            icon: Icons.photo_library,
            label: 'Choose from Gallery',
            onPressed: () => _showMediaTypeDialog(ImageSource.gallery),
          ),

          const SizedBox(height: 16),

          // Camera button
          _buildActionButton(
            icon: Icons.camera_alt,
            label: 'Take from Camera',
            onPressed: () => _showMediaTypeDialog(ImageSource.camera),
            isPrimary: false,
          ),
        ],
      ),
    );
  }

  /// Action button (Gallery / Camera)
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = true,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: isPrimary ? Colors.white : Colors.blue),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: isPrimary ? Colors.white : Colors.blue,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.blue : Colors.transparent,
        side: isPrimary ? null : const BorderSide(color: Colors.blue),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Media preview with actions (image or video)
  Widget _buildMediaPreview() {
    return Column(
      children: [
        // Media display (takes most of screen)
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            color: Colors.black,
            child: _isVideo ? _buildVideoPlayer() : _buildImageViewer(),
          ),
        ),

        // Actions panel
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Change media button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _isVideo 
                      ? _pickVideo(ImageSource.gallery)
                      : _pickImage(ImageSource.gallery),
                  icon: Icon(
                    _isVideo ? Icons.video_library : Icons.photo_library,
                    color: Colors.white,
                  ),
                  label: Text(
                    _isVideo ? 'Change Video' : 'Change Photo',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white54),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Remove media button
              TextButton.icon(
                onPressed: _clearSelection,
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: Text(
                  _isVideo ? 'Remove Video' : 'Remove Photo',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Show dialog to choose between photo or video
  Future<void> _showMediaTypeDialog(ImageSource source) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Choose Media Type',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Photo option
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.blue, size: 30),
                title: const Text(
                  'Photo',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                subtitle: Text(
                  source == ImageSource.gallery ? 'Choose from gallery' : 'Take a photo',
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(source);
                },
              ),
              const Divider(color: Colors.white24),
              // Video option
              ListTile(
                leading: const Icon(Icons.videocam, color: Colors.blue, size: 30),
                title: const Text(
                  'Video',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                subtitle: Text(
                  source == ImageSource.gallery ? 'Choose from gallery' : 'Record a video',
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo(source);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1080, // Instagram max width
        maxHeight: 1080,
        imageQuality: 85, // Good balance
      );

      if (image != null) {
        setState(() {
          _selectedMedia = File(image.path);
          _isVideo = false;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Pick video from gallery or camera
  Future<void> _pickVideo(ImageSource source) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final XFile? video = await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(seconds: 60), // 1 minute max like Instagram
      );

      if (video != null) {
        // Initialize video player
        final videoFile = File(video.path);
        _videoController = VideoPlayerController.file(videoFile);
        
        await _videoController!.initialize();
        await _videoController!.setLooping(true);
        
        setState(() {
          _selectedMedia = videoFile;
          _isVideo = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Build image viewer with zoom
  Widget _buildImageViewer() {
    return InteractiveViewer(
      child: Image.file(
        _selectedMedia!,
        fit: BoxFit.contain,
      ),
    );
  }

  /// Build video player with controls
  Widget _buildVideoPlayer() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Video player
        AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        ),
        
        // Play/Pause button overlay
        GestureDetector(
          onTap: () {
            setState(() {
              if (_videoController!.value.isPlaying) {
                _videoController!.pause();
              } else {
                _videoController!.play();
              }
            });
          },
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Icon(
                _videoController!.value.isPlaying
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                color: Colors.white.withOpacity(0.7),
                size: 80,
              ),
            ),
          ),
        ),
        
        // Video duration at bottom
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _formatDuration(_videoController!.value.duration),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Format duration to mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  /// Go to caption screen (Next step)
  void _goToCaption() {
    // TODO: Navigate to caption/details screen
    // For now, show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Caption screen will be implemented next!'),
        backgroundColor: Colors.blue,
      ),
    );

    // Example navigation (when you create AddCaptionScreen):
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AddCaptionScreen(image: _selectedImage!),
    //   ),
    // );
  }
}