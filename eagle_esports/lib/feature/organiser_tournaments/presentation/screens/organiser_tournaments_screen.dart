import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/organiser_tournaments/presentation/widgets/organiser_tournament_filter_bar.dart';
import 'package:eagle_esports/feature/organiser_tournaments/presentation/widgets/organiser_tournament_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrganiserTournamentsScreen extends ConsumerStatefulWidget {
  const OrganiserTournamentsScreen({super.key});

  @override
  ConsumerState<OrganiserTournamentsScreen> createState() =>
      _OrganiserTournamentsScreenState();
}

class _OrganiserTournamentsScreenState
    extends ConsumerState<OrganiserTournamentsScreen> {
  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: AppSpacing.screenPadding,
                child: Text(
                  'Tournaments',
                  style: AppTextStyles.headlineLgMobile,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              OrganiserTournamentFilterBar(
                selectedStatus: _selectedStatus,
                onSelected: (s) => setState(() => _selectedStatus = s),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: OrganiserTournamentList(
                  selectedStatus: _selectedStatus,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
