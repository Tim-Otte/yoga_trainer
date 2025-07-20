import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class NameInput extends StatefulWidget {
  const NameInput({
    super.key,
    this.id,
    required this.bodyPart,
    required this.initialValue,
    required this.onChanged,
  });

  final int? id;
  final BodyPart? bodyPart;
  final String initialValue;
  final Function(String value) onChanged;

  @override
  State<StatefulWidget> createState() => _NameInputState();
}

class _NameInputState extends State<NameInput> {
  String _value = '';
  bool _poseWithNameAlreadyExists = false;

  @override
  void initState() {
    super.initState();

    _value = widget.initialValue;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppDatabase>(context, listen: false)
          .hasPoseWithName(_value, widget.bodyPart, id: widget.id)
          .then((nameCheck) {
            setState(() => _poseWithNameAlreadyExists = nameCheck);
          });
    });
  }

  @override
  void didUpdateWidget(covariant NameInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    Provider.of<AppDatabase>(
      context,
      listen: false,
    ).hasPoseWithName(_value, widget.bodyPart, id: widget.id).then((nameCheck) {
      setState(() => _poseWithNameAlreadyExists = nameCheck);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    var database = Provider.of<AppDatabase>(context);

    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: Text(localizations.poseName),
        icon: Icon(Symbols.label_outline),
        counterText: _poseWithNameAlreadyExists ? '' : null,
      ),
      maxLength: 100,
      validator: (value) {
        if (_poseWithNameAlreadyExists) {
          return localizations.poseNameInvalid;
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
      autovalidateMode: AutovalidateMode.always,
      textInputAction: TextInputAction.next,
      inputFormatters: [LengthLimitingTextInputFormatter(100)],
      initialValue: _value,
      onChanged: (value) async {
        bool nameCheck = false;

        if (value.isNotEmpty) {
          nameCheck = await database.hasPoseWithName(
            value,
            widget.bodyPart,
            id: widget.id,
          );
        }

        setState(() {
          _poseWithNameAlreadyExists = nameCheck;
          _value = value;
        });

        widget.onChanged(value);
      },
    );
  }
}
