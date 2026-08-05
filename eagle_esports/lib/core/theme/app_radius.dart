import 'package:flutter/widgets.dart';

class AppRadius {
  const AppRadius._();

  static const double sm = 2.0;
  static const double defaultRadius = 4.0;
  static const double md = 6.0;
  static const double lg = 8.0;
  static const double xl = 12.0;
  static const double full = 9999.0;
  static const double cutCornerSize = 16.0;

  static BorderRadius get radiusSm => BorderRadius.circular(sm);
  static BorderRadius get radiusDefault => BorderRadius.circular(defaultRadius);
  static BorderRadius get radiusMd => BorderRadius.circular(md);
  static BorderRadius get radiusLg => BorderRadius.circular(lg);
  static BorderRadius get radiusXl => BorderRadius.circular(xl);
  static BorderRadius get radiusFull => BorderRadius.circular(full);
}
