import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';
import 'package:eagle_esports/feature/profile/presentation/providers/profile_providers.dart';
import 'package:eagle_esports/feature/profile/presentation/widgets/avatar_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  String? _avatarUrl;
  final bool _isAvatarUploading = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).value;
    _nameController = TextEditingController(text: profile?.fullName ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _avatarUrl = profile?.avatarUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final userId = ref.read(authNotifierProvider).value?.user.id;
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please sign in again')));
      return;
    }

    try {
      await ref
          .read(profileEditProvider.notifier)
          .updateProfile(
            userId: userId,
            fullName: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            avatarUrl: _avatarUrl ?? '',
          );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: AppSpacing.screenPadding,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () => context.pop(),
                    ),
                    Text('Edit Profile', style: AppTextStyles.headlineLgMobile),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.screenPadding,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AvatarPicker(
                          currentAvatarUrl: _avatarUrl,
                          isUploading: _isAvatarUploading,
                          onUploaded: (url) => setState(() => _avatarUrl = url),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AppTextField(
                          controller: _nameController,
                          hint: 'Full name',
                          prefixIcon: const Icon(Icons.person_outline),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Name is required'
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: _phoneController,
                          hint: 'Phone number',
                          keyboardType: TextInputType.phone,
                          prefixIcon: const Icon(Icons.phone_outlined),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Phone is required'
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Phone must be unique across all accounts',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Consumer(
                          builder: (context, ref, _) {
                            final isLoading = ref
                                .watch(profileEditProvider)
                                .isLoading;
                            return PrimaryGradientButton(
                              text: 'SAVE CHANGES',
                              isLoading: isLoading,
                              onPressed: isLoading ? null : _save,
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
