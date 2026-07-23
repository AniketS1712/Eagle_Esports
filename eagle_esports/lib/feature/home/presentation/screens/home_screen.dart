import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/shared/widgets/User_app_bar.dart';
import 'package:eagle_esports/feature/home/presentation/widgets/tournament_filter_bar.dart';
import 'package:eagle_esports/feature/home/presentation/widgets/tournament_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedStatusFilter = 'Upcoming';
  String _selectedModeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              const UserAppBar(),
              TournamentFilterBar(
                selectedStatusFilter: _selectedStatusFilter,
                selectedModeFilter: _selectedModeFilter,
                onStatusSelected: (filter) => setState(() {
                  _selectedStatusFilter = filter;
                }),
                onModeSelected: (filter) => setState(() {
                  _selectedModeFilter = filter;
                }),
              ),
              Expanded(
                child: TournamentList(
                  selectedStatusFilter: _selectedStatusFilter,
                  selectedModeFilter: _selectedModeFilter,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
