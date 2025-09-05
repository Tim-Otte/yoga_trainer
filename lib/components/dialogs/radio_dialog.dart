import 'package:flutter/material.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

typedef StringResolver<T> = String Function(T value);

class RadioDialog<T> extends StatefulWidget {
  const RadioDialog({
    super.key,
    required this.title,
    required this.values,
    required this.initialValue,
    required this.getTitle,
    this.getSubtitle,
  });

  final String title;
  final List<T> values;
  final T initialValue;
  final String Function(T) getTitle;
  final String Function(T)? getSubtitle;

  @override
  State<RadioDialog> createState() => _RadioDialogState<T>();
}

class _RadioDialogState<T> extends State<RadioDialog<T>> {
  late T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: RadioGroup<T>(
          groupValue: selectedValue,
          onChanged: (v) => setState(() => selectedValue = v),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.values
                .map(
                  (item) => RadioListTile<T>(
                    value: item,
                    title: Text(widget.getTitle(item)),
                    subtitle: widget.getSubtitle != null
                        ? Text(widget.getSubtitle!(item))
                        : null,
                  ),
                )
                .toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(localizations.cancel),
        ),
        TextButton(
          onPressed: selectedValue != null
              ? () => Navigator.pop(context, selectedValue)
              : null,
          child: Text(localizations.apply),
        ),
      ],
    );
  }
}
