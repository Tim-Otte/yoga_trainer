import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  /// Navigates to a new route built by the provided [builder] function and returns
  /// a [Future] that completes with a value of type [T] when the route is popped.
  ///
  /// The [builder] function receives the current [BuildContext] and should return
  /// the widget to display on the new route.
  ///
  /// Returns a [Future] that resolves to the result passed when popping the route,
  /// or `null` if no result is provided.
  @optionalTypeArgs
  Future<T?> navigateTo<T extends Object?>(
    Widget Function(BuildContext) builder, {
    bool fullscreenDialog = false,
    bool replace = false,
  }) async {
    if (replace) {
      return Navigator.pushReplacement(
        this,
        MaterialPageRoute<T>(
          builder: builder,
          fullscreenDialog: fullscreenDialog,
        ),
      );
    } else {
      return Navigator.push(
        this,
        MaterialPageRoute<T>(
          builder: builder,
          fullscreenDialog: fullscreenDialog,
        ),
      );
    }
  }

  /// Navigates back to the previous route in the navigation stack.
  ///
  /// Optionally, a [result] of type [T] can be provided, which will be returned
  /// to the previous route.
  ///
  /// [T] is the type of the result that can be passed back.
  @optionalTypeArgs
  void navigateBack<T extends Object?>([T? result]) {
    Navigator.pop(this, result);
  }

  /// Displays a [SnackBar] with the given [message] in the current [BuildContext].
  ///
  /// Useful for showing brief notifications or messages to the user.
  ///
  /// Example:
  /// ```dart
  /// context.showSnackBar('Operation successful');
  /// ```
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }
}
