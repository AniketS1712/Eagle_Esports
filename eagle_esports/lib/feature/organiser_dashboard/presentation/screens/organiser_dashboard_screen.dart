import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/widgets/create_tournament_button.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/widgets/dashboard_header.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/widgets/dashboard_stats_row.dart';
import 'package:flutter/material.dart';

class OrganiserDashboardScreen extends StatelessWidget {
  const OrganiserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardHeader(),
                SizedBox(height: AppSpacing.lg),
                DashboardStatsRow(),
                SizedBox(height: AppSpacing.lg),
                CreateTournamentButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
