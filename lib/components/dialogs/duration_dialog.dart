import 'package:flutter/material.dart';
import 'package:yoga_trainer/components/duration_text.dart';
import 'package:yoga_trainer/extensions/build_context.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class DurationDialog extends StatefulWidget {
  const DurationDialog({
    super.key,
    required this.title,
    required this.description,
    required this.initialValue,
    required this.min,
    required this.max,
    this.stepSize,
  });

  final String title;
  final String description;
  final int initialValue;
  final Duration min;
  final Duration max;
  final Duration? stepSize;

  @override
  State<StatefulWidget> createState() => _DurationDialogState();
}

class _DurationDialogState extends State<DurationDialog> {
  late int _value;

  @override
  void initState() {
    super.initState();

    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(widget.title, textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 5),
          Text(widget.description, textAlign: TextAlign.center),
          SizedBox(height: 20),
          DurationText(
            Duration(seconds: _value),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Slider(
            value: _value.toDouble(),
            min: widget.min.inSeconds.toDouble(),
            max: widget.max.inSeconds.toDouble(),
            divisions: widget.stepSize == null
                ? null
                : ((widget.max.inSeconds - widget.min.inSeconds) /
                          (widget.stepSize!.inSeconds))
                      .round(),
            onChanged: (value) => setState(() {
              _value = value.toInt();
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.navigateBack(),
          child: Text(localizations.cancel),
        ),
        TextButton(
          onPressed: () => context.navigateBack(_value),
          child: Text(localizations.save),
        ),
      ],
    );
  }
}
