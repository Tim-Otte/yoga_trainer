import 'package:flutter/material.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

typedef StringResolver<T> = String Function(T value);

class CheckboxDialog<T> extends StatefulWidget {
  const CheckboxDialog({
    super.key,
    required this.title,
    required this.values,
    required this.initialValue,
    required this.getTitle,
    this.getSubtitle,
  });

  final String title;
  final List<T> values;
  final List<T> initialValue;
  final String Function(T) getTitle;
  final String Function(T)? getSubtitle;

  @override
  State<CheckboxDialog> createState() => _CheckboxDialogState<T>();
}

class _CheckboxDialogState<T> extends State<CheckboxDialog<T>> {
  late List<T> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.values
              .map(
                (item) => CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _selectedValues.contains(item),
                  title: Text(widget.getTitle(item)),
                  subtitle: widget.getSubtitle != null
                      ? Text(widget.getSubtitle!(item))
                      : null,
                  onChanged: (checked) => setState(() {
                    if (checked ?? false) {
                      _selectedValues.add(item);
                    } else {
                      _selectedValues.remove(item);
                    }
                  }),
                ),
              )
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(localizations.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _selectedValues),
          child: Text(localizations.apply),
        ),
      ],
    );
  }
}
