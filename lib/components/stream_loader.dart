import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:yoga_trainer/components/icon_with_text.dart';

class StreamLoader<T> extends StatelessWidget {
  const StreamLoader({
    super.key,
    required this.stream,
    required this.noDataText,
    required this.builder,
  });

  final Stream<List<T>> stream;
  final String noDataText;
  final Widget Function(BuildContext, List<T>) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: IconWithText(
              icon: Symbols.dangerous,
              text: 'Error: ${snapshot.error}',
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: IconWithText(icon: Symbols.search_off, text: noDataText),
          );
        }

        return builder(context, snapshot.data!);
      },
    );
  }
}
