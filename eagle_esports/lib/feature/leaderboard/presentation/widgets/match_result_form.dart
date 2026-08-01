import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/leaderboard/presentation/providers/leaderboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Per-match form that lets the organiser enter placement + kills
/// for every paid team and save the results.
class MatchResultForm extends ConsumerStatefulWidget {
  const MatchResultForm({
    required this.matchId,
    required this.teams,
    super.key,
  });

  final String matchId;
  final List<Map<String, dynamic>> teams;

  @override
  ConsumerState<MatchResultForm> createState() => _MatchResultFormState();
}

class _MatchResultFormState extends ConsumerState<MatchResultForm>
    with AutomaticKeepAliveClientMixin {
  late final Map<String, TextEditingController> _placementCtrls;
  late final Map<String, TextEditingController> _killsCtrls;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _placementCtrls = {
      for (final t in widget.teams) t['id'] as String: TextEditingController(),
    };
    _killsCtrls = {
      for (final t in widget.teams) t['id'] as String: TextEditingController(),
    };
  }

  @override
  void dispose() {
    for (final c in _placementCtrls.values) {
      c.dispose();
    }
    for (final c in _killsCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _prefill(List<Map<String, dynamic>> results) {
    for (final r in results) {
      final teamId = r['team_id'] as String;
      if (_placementCtrls.containsKey(teamId)) {
        final pCtrl = _placementCtrls[teamId]!;
        if (pCtrl.text.isEmpty) {
          pCtrl.text = '${r['placement'] ?? ''}';
        }
        final kCtrl = _killsCtrls[teamId]!;
        if (kCtrl.text.isEmpty) {
          kCtrl.text = '${r['kills'] ?? ''}';
        }
      }
    }
  }

  Future<void> _save() async {
    final placements = <int>{};
    final results = <Map<String, dynamic>>[];

    for (final t in widget.teams) {
      final id = t['id'] as String;
      final pText = _placementCtrls[id]!.text.trim();
      final kText = _killsCtrls[id]!.text.trim();

      if (pText.isEmpty || kText.isEmpty) {
        _snack('Fill in all fields before saving');
        return;
      }

      final placement = int.tryParse(pText);
      final kills = int.tryParse(kText);
      if (placement == null || kills == null) {
        _snack('Placement and kills must be numbers');
        return;
      }

      if (!placements.add(placement)) {
        _snack('Duplicate placement $placement — each must be unique');
        return;
      }

      results.add({'teamId': id, 'placement': placement, 'kills': kills});
    }

    try {
      await ref
          .read(leaderboardActionsProvider.notifier)
          .saveMatchResults(matchId: widget.matchId, results: results);
      if (mounted) _snack('Results saved');
    } catch (e) {
      if (mounted) _snack('Error: $e');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final existing = ref.watch(matchResultsProvider(widget.matchId));
    existing.whenData(_prefill);
    final isLoading = ref.watch(leaderboardActionsProvider).isLoading;

    return _MatchResultFormBody(
      teams: widget.teams,
      placementCtrls: _placementCtrls,
      killsCtrls: _killsCtrls,
      isLoading: isLoading,
      onSave: _save,
    );
  }
}

class _MatchResultFormBody extends StatelessWidget {
  const _MatchResultFormBody({
    required this.teams,
    required this.placementCtrls,
    required this.killsCtrls,
    required this.isLoading,
    required this.onSave,
  });

  final List<Map<String, dynamic>> teams;
  final Map<String, TextEditingController> placementCtrls;
  final Map<String, TextEditingController> killsCtrls;
  final bool isLoading;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: AppSpacing.xxxl,
      ),
      children: [
        for (final t in teams)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: GlassCard(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      t['team_name'] as String? ?? '—',
                      style: AppTextStyles.bodyMd,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  SizedBox(
                    width: 72,
                    child: AppTextField(
                      hint: '1–12',
                      keyboardType: TextInputType.number,
                      controller: placementCtrls[t['id']],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  SizedBox(
                    width: 72,
                    child: AppTextField(
                      hint: '0',
                      keyboardType: TextInputType.number,
                      controller: killsCtrls[t['id']],
                    ),
                  ),
                ],
              ),
            ),
          ),
        Padding(
          padding: AppSpacing.screenPadding,
          child: PrimaryGradientButton(
            text: 'Save Match Results',
            onPressed: onSave,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}
