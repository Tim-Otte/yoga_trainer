import 'package:flutter/material.dart';

enum PageType { normal, tabs }

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

  /// Returns the [PageType] for the current page.
  ///
  /// This method determines and provides the type of page being displayed.
  /// The returned [PageType] can be used to customize behavior or appearance
  /// based on the specific page context.
  PageType getPageType() {
    throw UnimplementedError('getPageType must be implemented');
  }

  /// Returns a list of [Tab] widgets for use in a [TabBar].
  ///
  /// The tabs are generated based on the provided [BuildContext], which can be
  /// used to access theme, localization, or other context-dependent resources.
  List<Tab> getTabs(BuildContext context) {
    return [];
  }
}
