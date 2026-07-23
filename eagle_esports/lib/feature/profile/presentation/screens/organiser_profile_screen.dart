import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/profile.dart';
import 'package:eagle_esports/feature/profile/presentation/widgets/user_profile_header.dart';
import 'package:eagle_esports/feature/profile/presentation/widgets/user_profile_menu.dart';

class OrganiserProfileScreen extends ConsumerWidget {
  const OrganiserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Profile', style: AppTextStyles.headlineLgMobile),
                SizedBox(height: AppSpacing.lg),
                UserProfileHeader(),
                SizedBox(height: AppSpacing.lg),
                UserProfileMenu(role: UserRole.organiser),
                SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
