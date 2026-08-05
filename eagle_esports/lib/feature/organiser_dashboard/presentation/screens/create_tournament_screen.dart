import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/routes/route_path.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/widgets/create_tournament_submit_button.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/widgets/tournament_form_basic_fields.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/widgets/tournament_form_mode_selector.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/widgets/tournament_form_numeric_fields.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/widgets/tournament_form_prize_fields.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/widgets/tournament_form_schedule_fields.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/screens/preview_tournament_screen.dart';
import 'package:eagle_esports/feature/tournament/presentation/providers/tournament_providers.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:eagle_esports/shared/widgets/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateTournamentScreen extends ConsumerStatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  ConsumerState<CreateTournamentScreen> createState() =>
      _CreateTournamentScreenState();
}

class _CreateTournamentScreenState
    extends ConsumerState<CreateTournamentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxSlotsController = TextEditingController();
  final _entryFeeController = TextEditingController();

  GameMode _gameMode = GameMode.solo;
  DateTime? _registrationEndTime;
  DateTime? _startTime;

  String? _bannerUrl;
  Map<String, dynamic> _prizeDistribution = {};
  double _prizePool = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _maxSlotsController.dispose();
    _entryFeeController.dispose();
    super.dispose();
  }

  Tournament? _buildTournament(TournamentStatus status) {
    if (!_formKey.currentState!.validate()) return null;

    if (_bannerUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a banner image')),
      );
      return null;
    }

    if (_prizeDistribution.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one prize rank')),
      );
      return null;
    }

    final organiserId = ref.read(authNotifierProvider).value?.user.id;
    if (organiserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in again to create a tournament')),
      );
      return null;
    }

    final now = DateTime.now();
    return Tournament(
      id: '',
      organiserId: organiserId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      bannerImageUrl: _bannerUrl,
      gameMode: _gameMode,
      maxSlots: int.parse(_maxSlotsController.text.trim()),
      filledSlots: 0,
      entryFee: double.parse(_entryFeeController.text.trim()),
      prizePool: _prizePool,
      prizeDistribution: _prizeDistribution,
      placementPointsMap: const {},
      killPointValue: 1,
      status: status,
      registrationEndTime: _registrationEndTime,
      startTime: _startTime,
      leaderboardTemplate: 1,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<void> _submit(TournamentStatus status) async {
    final tournament = _buildTournament(status);
    if (tournament == null) return;

    await ref.read(tournamentActionsProvider.notifier).create(tournament);
    if (!mounted) return;

    final state = ref.read(tournamentActionsProvider);
    if (!state.hasError) context.go(RoutePath.organiserDashboard);
  }

  Future<void> _previewTournament() async {
    final tournament = _buildTournament(TournamentStatus.draft);
    if (tournament == null) return;

    final result = await context.pushNamed<PreviewTournamentResult>(
      RouteNames.previewTournament,
      pathParameters: {'id': 'new'},
      extra: tournament,
    );

    if (!mounted || result != PreviewTournamentResult.publish) return;
    await _submit(TournamentStatus.upcoming);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppTopBar(
                    title: 'Create Tournament',
                    backRouteName: RouteNames.organiserDashboard,
                  ),
                  Padding(
                    padding: AppSpacing.screenPadding,
                    child: Column(
                      children: [
                        TournamentFormBasicFields(
                          titleController: _titleController,
                          descriptionController: _descriptionController,
                          onBannerUrlChanged: (url) {
                            setState(() => _bannerUrl = url);
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TournamentFormModeSelector(
                          selectedMode: _gameMode,
                          onChanged: (mode) => setState(() => _gameMode = mode),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TournamentFormNumericFields(
                          maxSlotsController: _maxSlotsController,
                          entryFeeController: _entryFeeController,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TournamentFormPrizeFields(
                          onChanged: (distribution, total) {
                            setState(() {
                              _prizeDistribution = distribution;
                              _prizePool = total;
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TournamentFormScheduleFields(
                          registrationEndTime: _registrationEndTime,
                          startTime: _startTime,
                          onRegistrationChanged: (value) =>
                              setState(() => _registrationEndTime = value),
                          onStartChanged: (value) =>
                              setState(() => _startTime = value),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        CreateTournamentSubmitButton(
                          onSubmit: _previewTournament,
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
