import 'package:flutter/material.dart';
import 'package:eagle_esports/core/theme/app_colors.dart';
import 'package:eagle_esports/core/theme/app_dimensions.dart';

/// Full-screen themed background for Eagle Esport screens.
class AppBackground extends StatelessWidget {
  const AppBackground({
    required this.child,
    this.showGridTexture = true,
    this.showAtmosphericGlow = true,
    super.key,
  });

  final Widget child;
  final bool showGridTexture;
  final bool showAtmosphericGlow;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.background),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (showGridTexture) const CustomPaint(painter: _GridPainter()),
          if (showAtmosphericGlow) ...const [
            Positioned(
              top: 60,
              left: -120,
              width: 320,
              height: 320,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.atmosphericOverlay,
                ),
              ),
            ),
            Positioned(
              right: -170,
              bottom: -150,
              width: 360,
              height: 360,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.atmosphericOverlay,
                ),
              ),
            ),
          ],
          child,
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.05)
      ..strokeWidth = 1;
    const step = AppDimensions.gridTexturePatternSize;

    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
