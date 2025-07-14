import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class DescriptionInput extends StatefulWidget {
  const DescriptionInput({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final Function(String value) onChanged;

  @override
  State<StatefulWidget> createState() => _DescriptionInputState();
}

class _DescriptionInputState extends State<DescriptionInput> {
  String _value = '';

  @override
  void initState() {
    super.initState();

    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: Text(localizations.poseDescription),
        icon: Icon(Symbols.info),
        alignLabelWithHint: true,
      ),
      maxLines: 3,
      maxLength: 250,
      textInputAction: TextInputAction.next,
      initialValue: _value,
      onChanged: (value) {
        setState(() => _value = value);
        widget.onChanged(value);
      },
    );
  }
}
