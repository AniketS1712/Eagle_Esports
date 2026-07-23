import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/team/presentation/widgets/team_room_empty_slot_card.dart';
import 'package:eagle_esports/feature/team/presentation/widgets/team_room_member_card.dart';
import 'package:flutter/material.dart';

class TeamRoomMember {
  const TeamRoomMember({
    required this.displayName,
    required this.role,
    required this.isLeader,
    required this.isReady,
    required this.paymentStatus,
  });

  final String displayName;
  final String role;
  final bool isLeader;
  final bool isReady;
  final String paymentStatus;
}

class TeamRoomMembersGrid extends StatelessWidget {
  const TeamRoomMembersGrid({
    required this.members,
    required this.maxSlots,
    super.key,
  });

  final List<TeamRoomMember> members;
  final int maxSlots;

  @override
  Widget build(BuildContext context) {
    final emptySlots = (maxSlots - members.length).clamp(0, maxSlots);

    return GridView.count(
      crossAxisCount: 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 2.0,
      children: [
        ...members.map((member) => TeamRoomMemberCard(member: member)),
        ...List.generate(emptySlots, (_) => const TeamRoomEmptySlotCard()),
      ],
    );
  }
}
