import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class DurationInput extends StatefulWidget {
  const DurationInput({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final int initialValue;
  final Function(int value) onChanged;

  @override
  State<StatefulWidget> createState() => _DurationInputState();
}

class _DurationInputState extends State<DurationInput> {
  int _value = 10;

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
        label: Text(localizations.poseDuration),
        icon: Icon(Icons.timer_outlined),
        suffixText: localizations.poseDurationSuffix,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp('^(60)|([1-5][0-9])|([1-9])\$'),
        ),
      ],
      validator: (value) {
        if (value == null) return null;

        var parsed = int.tryParse(value);
        if (parsed == null || parsed < 10 || parsed > 60) {
          return localizations.poseDurationInvalid;
        }

        return null;
      },
      textInputAction: TextInputAction.next,
      initialValue: _value.toString(),
      onChanged: (value) => setState(() {
        var parsed = int.tryParse(value);
        if (parsed != null) {
          setState(() => _value = parsed);
          widget.onChanged(parsed);
        }
      }),
    );
  }
}
