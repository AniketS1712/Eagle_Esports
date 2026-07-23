import 'package:eagle_esports/shared/widgets/user_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/profile.dart';
import 'package:eagle_esports/feature/profile/presentation/widgets/user_profile_header.dart';
import 'package:eagle_esports/feature/profile/presentation/widgets/user_profile_menu.dart';
import 'package:eagle_esports/feature/profile/presentation/widgets/user_profile_stats_row.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                UserAppBar(),
                Padding(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    children: [
                      SizedBox(height: AppSpacing.lg),
                      UserProfileHeader(),
                      SizedBox(height: AppSpacing.md),
                      UserProfileStatsRow(role: UserRole.user),
                      SizedBox(height: AppSpacing.lg),
                      UserProfileMenu(role: UserRole.user),
                      SizedBox(height: AppSpacing.xxxl),
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
