/// Font-family tokens for Eagle Esport.
///
/// Available bundled font weights:
/// - Orbitron: w500 medium, w600 semibold, w700 bold
/// - Manrope: w400 regular, w500 medium, w600 semibold, w700 bold
///
/// Orbitron does not include w400. When a design token requests Orbitron w400,
/// use FontWeight.w500 as the closest available local font weight.
class AppTypography {
  const AppTypography._();

  static const String fontOrbitron = 'Orbitron';
  static const String fontManrope = 'Manrope';
}
