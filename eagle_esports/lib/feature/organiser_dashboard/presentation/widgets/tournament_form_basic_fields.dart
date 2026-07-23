import 'dart:io';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/shared/services/cloudinary_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TournamentFormBasicFields extends StatefulWidget {
  const TournamentFormBasicFields({
    required this.titleController,
    required this.descriptionController,
    required this.onBannerUrlChanged,
    this.initialBannerUrl,
    super.key,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;

  /// Called with the Cloudinary secure_url once upload succeeds,
  /// or null if the user hasn't picked an image / upload failed.
  final ValueChanged<String?> onBannerUrlChanged;
  final String? initialBannerUrl;

  @override
  State<TournamentFormBasicFields> createState() =>
      _TournamentFormBasicFieldsState();
}

class _TournamentFormBasicFieldsState extends State<TournamentFormBasicFields> {
  final _cloudinary = CloudinaryService();
  final _picker = ImagePicker();

  File? _localImage;
  bool _isUploading = false;
  String? _uploadError;

  Future<void> _pickAndUpload() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() {
      _localImage = File(picked.path);
      _isUploading = true;
      _uploadError = null;
    });

    try {
      final url = await _cloudinary.uploadImage(_localImage!);
      if (!mounted) return;
      widget.onBannerUrlChanged(url);
      setState(() => _isUploading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isUploading = false;
        _uploadError = 'Upload failed — tap to retry';
      });
      widget.onBannerUrlChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: widget.titleController,
          hint: 'Tournament title',
          prefixIcon: const Icon(Icons.title),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Title is required';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: widget.descriptionController,
          hint: 'Description',
          maxLines: 4,
          prefixIcon: const Icon(Icons.notes),
        ),
        const SizedBox(height: AppSpacing.md),
        // Replaces the old "Banner image URL" AppTextField — picks
        // from gallery and uploads to Cloudinary directly.
        GestureDetector(
          onTap: _isUploading ? null : _pickAndUpload,
          child: Container(
            height: AppDimensions.tournamentCardImageHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: AppRadius.radiusDefault,
              border: Border.all(color: AppColors.dividerColor),
              image: _localImage != null
                  ? DecorationImage(
                      image: FileImage(_localImage!),
                      fit: BoxFit.cover,
                    )
                  : (widget.initialBannerUrl != null
                        ? DecorationImage(
                            image: NetworkImage(widget.initialBannerUrl!),
                            fit: BoxFit.cover,
                          )
                        : null),
            ),
            child: _isUploading
                ? const Center(child: CircularProgressIndicator())
                : (_localImage == null && widget.initialBannerUrl == null)
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: AppDimensions.iconLg,
                          color: AppColors.outline,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Tap to upload banner image',
                          style: AppTextStyles.bodySm,
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        ),
        if (_uploadError != null) ...[
          const SizedBox(height: AppSpacing.xs),
          GestureDetector(
            onTap: _pickAndUpload,
            child: Text(
              _uploadError!,
              style: AppTextStyles.bodySm.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ],
    );
  }
}
