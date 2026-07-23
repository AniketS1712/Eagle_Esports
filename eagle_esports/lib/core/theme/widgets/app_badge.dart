import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_radius.dart';
import '../app_spacing.dart';
import '../app_text_styles.dart';

/// Status badge for tournament and payment states.
class StatusBadge extends StatefulWidget {
  const StatusBadge({required this.status, super.key});

  final String status;

  @override
  State<StatusBadge> createState() => _StatusBadgeState();
}

class _StatusBadgeState extends State<StatusBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  bool get _isLive => widget.status.toLowerCase() == 'live';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulse = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (_isLive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant StatusBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isLive && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!_isLive && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = AppColors.statusColor(widget.status);
    final label = widget.status.toUpperCase();

    if (!_isLive) {
      return _BadgeShell(
        backgroundColor: statusColor.withValues(alpha: 0.15),
        textColor: statusColor,
        text: label,
      );
    }

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        return _BadgeShell(
          backgroundColor: AppColors.electricCyan,
          textColor: Colors.black,
          text: 'LIVE',
          boxShadow: [
            BoxShadow(
              color: AppColors.electricCyan.withValues(
                alpha: _pulse.value * 0.55,
              ),
              blurRadius: 10 * _pulse.value,
            ),
          ],
        );
      },
    );
  }
}

/// Cyan pro-tier badge, optionally accented for higher categories.
class ProBadge extends StatelessWidget {
  const ProBadge({this.accented = false, super.key});

  final bool accented;

  @override
  Widget build(BuildContext context) {
    return _BadgeShell(
      backgroundColor: AppColors.electricCyan,
      textColor: Colors.black,
      text: 'PRO',
      border: accented ? Border.all(color: AppColors.tertiary) : null,
      boxShadow: AppColors.glowShadow(
        AppColors.electricCyan,
        blur: 8,
        opacity: 0.35,
      ),
    );
  }
}

class _BadgeShell extends StatelessWidget {
  const _BadgeShell({
    required this.backgroundColor,
    required this.textColor,
    required this.text,
    this.border,
    this.boxShadow,
  });

  final Color backgroundColor;
  final Color textColor;
  final String text;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.radiusFull,
        border: border,
        boxShadow: boxShadow,
      ),
      child: Text(
        text,
        style: AppTextStyles.badgeLabel.copyWith(color: textColor),
      ),
    );
  }
}
