import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app_decorations.dart';
import '../../app_dimensions.dart';
import '../../app_radius.dart';
import '../../app_spacing.dart';

/// Glassmorphism content shell with optional HUD corner accent.
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding = AppSpacing.cardPadding,
    this.margin,
    this.borderRadius,
    this.withGlow = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool withGlow;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppRadius.radiusDefault;

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppDimensions.glassBlurSigma,
          sigmaY: AppDimensions.glassBlurSigma,
        ),
        child: Container(
          margin: margin,
          decoration: AppDecorations.glassCard(
            radius: radius,
            withGlow: withGlow,
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
