import 'package:flutter/material.dart';
import 'package:yoga_trainer/entities/all.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class DifficultyInput extends StatefulWidget {
  const DifficultyInput({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final Difficulty initialValue;
  final Function(Difficulty value) onChanged;

  @override
  State<StatefulWidget> createState() => _DifficultyInputState();
}

class _DifficultyInputState extends State<DifficultyInput> {
  Difficulty _value = Difficulty.medium;

  @override
  void initState() {
    super.initState();

    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          localizations.poseDifficulty,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SegmentedButton<Difficulty>(
              segments: Difficulty.values
                  .map(
                    (d) => ButtonSegment(
                      value: d,
                      icon: Icon(d.getIcon()),
                      label: Text(d.getTranslation(context)),
                    ),
                  )
                  .toList(),
              selected: {_value},
              onSelectionChanged: (selected) {
                setState(() => _value = selected.first);
                widget.onChanged(selected.first);
              },
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
