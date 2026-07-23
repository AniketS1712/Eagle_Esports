import 'package:flutter/widgets.dart';

/// Radius tokens from design.md. Rem values are converted using 1rem = 16 px.
class AppRadius {
  const AppRadius._();

  static const double sm = 2.0;
  static const double defaultRadius = 4.0;
  static const double md = 6.0;
  static const double lg = 8.0;
  static const double xl = 12.0;
  static const double full = 9999.0;

  /// 45-degree clipped corner size for featured/decorative containers.
  ///
  /// Use with ClipPath or a custom CutCornerBorder shape where the HUD treatment
  /// calls for cut corners instead of ordinary rounded corners.
  static const double cutCornerSize = 16.0;

  static BorderRadius get radiusSm => BorderRadius.circular(sm);
  static BorderRadius get radiusDefault => BorderRadius.circular(defaultRadius);
  static BorderRadius get radiusMd => BorderRadius.circular(md);
  static BorderRadius get radiusLg => BorderRadius.circular(lg);
  static BorderRadius get radiusXl => BorderRadius.circular(xl);
  static BorderRadius get radiusFull => BorderRadius.circular(full);
}
