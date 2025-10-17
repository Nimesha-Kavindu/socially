import 'package:flutter/material.dart';
import 'package:socially/utils/constants/colors.dart';
import 'dart:io';

/// Add caption screen - Step 2 of creating a post
/// User adds caption, location, and other details before posting
class AddCaptionScreen extends StatefulWidget {
  final File mediaFile;
  final bool isVideo;

  const AddCaptionScreen({
    super.key,
    required this.mediaFile,
    required this.isVideo,
  });

  @override
  State<AddCaptionScreen> createState() => _AddCaptionScreenState();
}

class _AddCaptionScreenState extends State<AddCaptionScreen> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _isPosting = false;

  @override
  void dispose() {
    _captionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _isPosting ? _buildLoadingIndicator() : _buildContent(),
    );
  }

  /// AppBar with back button and Share button
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'New Post',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        // Share button with gradient
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              gradient: gradientColors,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: _handleShare,
              child: const Text(
                'Share',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Loading indicator
  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(mainOrangeColor),
          ),
          const SizedBox(height: 20),
          ShaderMask(
            shaderCallback: (bounds) => gradientColors.createShader(bounds),
            child: const Text(
              'Posting...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Main content
  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Media preview and caption section
          _buildMediaCaptionSection(),

          const SizedBox(height: 1),

          // Location section
          _buildLocationSection(),

          const SizedBox(height: 1),

          // Additional options
          _buildAdditionalOptions(),
        ],
      ),
    );
  }

  /// Media preview and caption input
  Widget _buildMediaCaptionSection() {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 80,
              height: 80,
              child: widget.isVideo
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          widget.mediaFile,
                          fit: BoxFit.cover,
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Image.file(
                      widget.mediaFile,
                      fit: BoxFit.cover,
                    ),
            ),
          ),

          const SizedBox(width: 16),

          // Caption input
          Expanded(
            child: TextField(
              controller: _captionController,
              maxLines: 5,
              maxLength: 2200, // Instagram's max caption length
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Write a caption...',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                border: InputBorder.none,
                counterStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Location input section
  Widget _buildLocationSection() {
    return Container(
      color: Colors.grey[900],
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ShaderMask(
          shaderCallback: (bounds) => gradientColors.createShader(bounds),
          child: const Icon(
            Icons.location_on,
            color: Colors.white,
            size: 28,
          ),
        ),
        title: TextField(
          controller: _locationController,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Add location',
            hintStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            border: InputBorder.none,
          ),
        ),
        trailing: _locationController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.close, color: Colors.grey[600]),
                onPressed: () {
                  setState(() {
                    _locationController.clear();
                  });
                },
              )
            : null,
      ),
    );
  }

  /// Additional posting options
  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        _buildOptionTile(
          icon: Icons.person_add,
          title: 'Tag People',
          onTap: () {
            // TODO: Implement tag people functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tag people feature coming soon!'),
                backgroundColor: mainOrangeColor,
              ),
            );
          },
        ),
        _buildDivider(),
        _buildOptionTile(
          icon: Icons.music_note,
          title: 'Add Music',
          onTap: () {
            // TODO: Implement add music functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Add music feature coming soon!'),
                backgroundColor: mainOrangeColor,
              ),
            );
          },
        ),
        _buildDivider(),
        _buildOptionTile(
          icon: Icons.facebook,
          title: 'Share to Facebook',
          trailing: Switch(
            value: false,
            onChanged: (value) {
              // TODO: Implement Facebook sharing
            },
            activeColor: mainOrangeColor,
          ),
        ),
        _buildDivider(),
        _buildOptionTile(
          icon: Icons.share,
          title: 'Share to Twitter',
          trailing: Switch(
            value: false,
            onChanged: (value) {
              // TODO: Implement Twitter sharing
            },
            activeColor: mainOrangeColor,
          ),
        ),
      ],
    );
  }

  /// Option tile widget
  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      color: Colors.grey[900],
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ShaderMask(
          shaderCallback: (bounds) => gradientColors.createShader(bounds),
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        trailing: trailing ??
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[600],
              size: 18,
            ),
        onTap: onTap,
      ),
    );
  }

  /// Divider between options
  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.black,
    );
  }

  /// Handle share button press
  Future<void> _handleShare() async {
    // Validate input
    if (_captionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a caption for your post'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isPosting = true;
    });

    try {
      // TODO: Implement the actual post upload logic
      // 1. Upload media to Cloudinary
      // 2. Save post data to Firestore
      // 3. Navigate back to home screen

      // Simulating upload delay
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Post shared successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        // Navigate back to home (pop twice to go back to main screen)
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _isPosting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error posting: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
