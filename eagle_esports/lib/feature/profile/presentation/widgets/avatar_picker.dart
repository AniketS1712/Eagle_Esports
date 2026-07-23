import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/shared/services/cloudinary_service.dart';

class AvatarPicker extends StatefulWidget {
  final String? currentAvatarUrl;
  final ValueChanged<String> onUploaded;
  final bool isUploading;

  const AvatarPicker({
    super.key,
    this.currentAvatarUrl,
    required this.onUploaded,
    required this.isUploading,
  });

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  File? _localFile;
  bool _uploadingLocal = false;

  Future<void> _pickAndUpload() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (picked == null) return;

      final file = File(picked.path);
      setState(() {
        _localFile = file;
        _uploadingLocal = true;
      });

      final url = await CloudinaryService().uploadImage(file);
      if (mounted) {
        widget.onUploaded(url);
      }
    } catch (_) {
      // Caller handles error display if needed
    } finally {
      if (mounted) {
        setState(() {
          _uploadingLocal = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final showUploading = widget.isUploading || _uploadingLocal;
    final hasUrl =
        widget.currentAvatarUrl != null && widget.currentAvatarUrl!.isNotEmpty;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundImage: _localFile != null
                ? FileImage(_localFile!) as ImageProvider
                : (hasUrl ? NetworkImage(widget.currentAvatarUrl!) : null),
            backgroundColor: AppColors.surfaceContainerHigh,
            child: (_localFile == null && !hasUrl)
                ? const Icon(
                    Icons.person,
                    size: AppDimensions.iconLg,
                    color: AppColors.outline,
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: showUploading ? null : _pickAndUpload,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.electricBlue,
                  border: Border.all(color: AppColors.background, width: 2),
                ),
                child: showUploading
                    ? const Padding(
                        padding: EdgeInsets.all(6),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
