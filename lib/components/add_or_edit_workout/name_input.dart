import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class NameInput extends StatefulWidget {
  const NameInput({
    super.key,
    this.id,
    required this.initialValue,
    required this.onChanged,
  });

  final int? id;
  final String initialValue;
  final Function(String value) onChanged;

  @override
  State<StatefulWidget> createState() => _NameInputState();
}

class _NameInputState extends State<NameInput> {
  String _value = '';
  bool _workoutWithNameAlreadyExists = false;

  @override
  void initState() {
    super.initState();

    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    var database = Provider.of<AppDatabase>(context);

    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: Text(localizations.workoutName),
        icon: Icon(Symbols.label_outline),
      ),
      textCapitalization: TextCapitalization.sentences,
      maxLength: 100,
      validator: (value) {
        if ((value?.isEmpty ?? true) || _workoutWithNameAlreadyExists) {
          return localizations.workoutNameInvalid;
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      initialValue: _value,
      onChanged: (value) async {
        bool nameCheck = false;

        if (value.isNotEmpty) {
          nameCheck = await database.hasWorkoutWithName(value, id: widget.id);
        }

        setState(() {
          _workoutWithNameAlreadyExists = nameCheck;
          _value = value;
        });

        widget.onChanged(value);
      },
    );
  }
}
