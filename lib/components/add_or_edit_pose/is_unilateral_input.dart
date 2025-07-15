import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:yoga_trainer/extensions/color.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class IsUnilateralInput extends StatefulWidget {
  final bool initialValue;
  final Function(bool value) onChanged;

  const IsUnilateralInput({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<IsUnilateralInput> createState() => _IsUnilateralInputState();
}

class _IsUnilateralInputState extends State<IsUnilateralInput> {
  late bool _value;

  @override
  void initState() {
    super.initState();

    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, right: 10),
          child: Icon(
            Symbols.swap_horiz,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              var newValue = !_value;

              setState(() => _value = newValue);
              widget.onChanged(newValue);
            },
            highlightColor: theme.highlightColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Padding(
              padding: EdgeInsetsGeometry.only(
                top: 10,
                right: 5,
                bottom: 10,
                left: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.poseIsUnilateral,
                        style: theme.textTheme.bodyLarge,
                      ),
                      Text(
                        _value
                            ? localizations.poseIsUnilateralHintTrue
                            : localizations.poseIsUnilateralHintFalse,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.textTheme.bodyMedium!.color!.useOpacity(
                            0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _value,
                    onChanged: (checked) {
                      setState(() => _value = checked);
                      widget.onChanged(checked);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
