import 'package:flutter/widgets.dart';

interface class PageInfos {
  /// Returns the title for the current page.
  ///
  /// This method should be implemented by subclasses to provide
  /// a localized or context-specific title.
  ///
  /// Throws an [UnimplementedError] if not overridden.
  String getTitle(BuildContext context) {
    throw UnimplementedError('getTitle must be implemented');
  }

  /// Returns the icon associated with this object.
  ///
  /// This method should be implemented by subclasses to provide a specific [IconData].
  /// Throws an [UnimplementedError] if not overridden.
  IconData getIcon() {
    throw UnimplementedError('getIcon must be implemented');
  }

  /// Returns a Floating Action Button (FAB) widget for the page.
  ///
  /// Currently, this method returns `null`, indicating that no FAB is provided.
  /// Override or modify this method to supply a custom FAB widget if needed.
  Widget? getFAB(BuildContext context) {
    return null;
  }
}
