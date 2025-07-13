import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class AddBodyPartDialog extends StatefulWidget {
  const AddBodyPartDialog({super.key});

  @override
  State<StatefulWidget> createState() => _AddBodyPartDialogState();
}

class _AddBodyPartDialogState extends State<AddBodyPartDialog> {
  String _value = '';
  bool _bodyPartAlreadyExists = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var database = Provider.of<AppDatabase>(context);

    return AlertDialog(
      icon: Icon(Symbols.person_search),
      title: Text(localizations.addBodyPart),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          decoration: InputDecoration(label: Text(localizations.bodyPartName)),
          initialValue: _value,
          onChanged: (value) async {
            bool nameCheck =
                value.isNotEmpty && await database.hasBodyPart(value);

            setState(() {
              _bodyPartAlreadyExists = nameCheck;
              _value = value;
            });
          },
          validator: (value) {
            if ((value?.isEmpty ?? true) || _bodyPartAlreadyExists) {
              return localizations.bodyPartNameInvalid;
            }

            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(localizations.cancel),
        ),
        TextButton(
          onPressed: _value.isNotEmpty && !_bodyPartAlreadyExists
              ? () {
                  Navigator.pop(context, _value);
                }
              : null,
          child: Text(localizations.save),
        ),
      ],
    );
  }
}
