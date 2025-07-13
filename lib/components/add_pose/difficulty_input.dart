import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
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
    var localizations = AppLocalizations.of(context);

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
              segments: [
                ButtonSegment(
                  value: Difficulty.easy,
                  icon: Icon(Symbols.sentiment_very_satisfied),
                  label: Text(localizations.difficultyEasy),
                ),
                ButtonSegment(
                  value: Difficulty.medium,
                  icon: Icon(Symbols.sentiment_content),
                  label: Text(localizations.difficultyMedium),
                ),
                ButtonSegment(
                  value: Difficulty.hard,
                  icon: Icon(Symbols.sentiment_frustrated),
                  label: Text(localizations.difficultyHard),
                ),
              ],
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
