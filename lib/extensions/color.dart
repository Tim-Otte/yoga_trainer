import 'package:flutter/widgets.dart';

extension ColorExtensions on Color {
  /// Adjusts the opacity of the color.
  ///
  /// The [value] parameter must be between 0.0 (fully transparent) and 1.0 (fully opaque).
  ///
  /// Throws an [AssertionError] if [value] is not within the valid range.
  ///
  /// Returns a new [Color] with the specified opacity.
  Color useOpacity(double value) {
    assert(value >= 0.0 && value <= 1.0, 'Opacity must be between 0.0 and 1.0');
    return withValues(alpha: value);
  }
}
