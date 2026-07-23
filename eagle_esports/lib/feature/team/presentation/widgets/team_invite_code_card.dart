import 'dart:async';

import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeamInviteCodeCard extends StatefulWidget {
  const TeamInviteCodeCard({required this.inviteCode, super.key});

  final String? inviteCode;

  @override
  State<TeamInviteCodeCard> createState() => _TeamInviteCodeCardState();
}

class _TeamInviteCodeCardState extends State<TeamInviteCodeCard> {
  bool _copied = false;
  Timer? _copiedTimer;

  @override
  void dispose() {
    _copiedTimer?.cancel();
    super.dispose();
  }

  Future<void> _copyCode() async {
    final inviteCode = widget.inviteCode;
    if (inviteCode == null) return;

    await Clipboard.setData(ClipboardData(text: inviteCode));
    if (!mounted) return;

    setState(() => _copied = true);
    _copiedTimer?.cancel();
    _copiedTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final inviteCode = widget.inviteCode;

    return GlassCard(
      withGlow: inviteCode != null,
      padding: AppSpacing.cardPaddingLarge,
      child: inviteCode == null
          ? Center(
              child: Text(
                'Solo Mode — No invite code',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
              ),
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        inviteCode,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.numberXl.copyWith(
                          color: AppColors.electricCyan,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton(
                      onPressed: _copyCode,
                      icon: const Icon(
                        Icons.copy_outlined,
                        color: AppColors.onSurface,
                      ),
                      tooltip: 'Copy invite code',
                    ),
                  ],
                ),
                AnimatedOpacity(
                  opacity: _copied ? 1 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: Text(
                    'Copied!',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.statusSuccess,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
