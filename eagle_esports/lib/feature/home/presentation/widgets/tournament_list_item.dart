import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';

class TournamentListItem extends StatelessWidget {
  const TournamentListItem({
    required this.tournament,
    this.isJoined = false,
    this.onTap,
    super.key,
  });

  final Tournament tournament;
  final bool isJoined;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TournamentCard(
      title: tournament.title,
      bannerUrl: tournament.bannerImageUrl ?? '',
      mode: _cardMode(tournament.gameMode),
      entryFee: tournament.entryFee.round(),
      prizePool: tournament.prizePool.round(),
      slotsTotal: tournament.maxSlots,
      slotsFilled: tournament.filledSlots,
      status: tournament.status.name,
      onTap: onTap ??
          () => context.pushNames(
                RouteNames.tournamentDetails,
                pathParameters: {'id': tournament.id},
                extra: {'isJoined': isJoined},
              ),
    );
  }

  TournamentMode _cardMode(GameMode mode) {
    return switch (mode) {
      GameMode.solo => TournamentMode.solo,
      GameMode.duo => TournamentMode.duo,
      GameMode.squad => TournamentMode.squad,
    };
  }
}
