import 'package:flutter/material.dart';
import 'package:yoga_trainer/components/stream_loader.dart';

class StreamListView<T> extends StatelessWidget {
  const StreamListView({
    super.key,
    required this.stream,
    required this.noDataText,
    required this.itemBuilder,
  });

  final Stream<List<T>> stream;
  final String noDataText;
  final Widget? Function(BuildContext, T, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamLoader(
      stream: stream,
      noDataText: noDataText,
      builder: (context, data) => ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) =>
            itemBuilder(context, data[index], index),
      ),
    );
  }
}
