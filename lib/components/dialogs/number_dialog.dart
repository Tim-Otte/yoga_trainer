import 'package:flutter/material.dart';
import 'package:yoga_trainer/extensions/build_context.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class NumberDialog extends StatefulWidget {
  const NumberDialog({
    super.key,
    required this.title,
    required this.description,
    required this.initialValue,
    required this.min,
    required this.max,
    this.unit,
  });

  final String title;
  final String description;
  final int initialValue;
  final int min;
  final int max;
  final String? unit;

  @override
  State<StatefulWidget> createState() => _NumberDialogState();
}

class _NumberDialogState extends State<NumberDialog> {
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
          Text(
            '$_value${widget.unit ?? ''}',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Slider(
            value: _value.toDouble(),
            min: widget.min.toDouble(),
            max: widget.max.toDouble(),
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
