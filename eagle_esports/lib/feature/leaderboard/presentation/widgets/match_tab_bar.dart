import 'package:flutter/material.dart';

/// Provides the tab data for the match/overall tab bar.
/// The parent screen uses [tabs] to build a [TabBar].
class MatchTabBar extends StatelessWidget {
  const MatchTabBar({
    required this.matchCount,
    required this.onAddMatch,
    this.isAddingMatch = false,
    super.key,
  });

  final int matchCount;
  final VoidCallback onAddMatch;
  final bool isAddingMatch;

  /// Tab labels: "Match 1", "Match 2", ... , "Overall".
  List<Tab> get tabs => [
    for (int i = 1; i <= matchCount; i++) Tab(text: 'Match $i'),
    const Tab(text: 'Overall'),
  ];

  @override
  Widget build(BuildContext context) {
    // Thin wrapper — rendered by the parent's DefaultTabController.
    return const SizedBox.shrink();
  }
}
