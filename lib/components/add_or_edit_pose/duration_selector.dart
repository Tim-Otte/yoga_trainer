import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:yoga_trainer/components/dialogs/all.dart';
import 'package:yoga_trainer/components/duration_text.dart';
import 'package:yoga_trainer/extensions/color.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class DurationSelector extends StatefulWidget {
  final int initialValue;
  final Function(int value) onChanged;

  const DurationSelector({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<DurationSelector> createState() => _DurationSelectorState();
}

class _DurationSelectorState extends State<DurationSelector> {
  late int _selected;

  @override
  void initState() {
    super.initState();

    _selected = widget.initialValue;
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
            Symbols.more_time,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              var result = await showDialog<int>(
                context: context,
                builder: (_) => DurationDialog(
                  title: localizations.poseDurationTitle,
                  description: localizations.poseDurationContent,
                  initialValue: _selected,
                  min: Duration(seconds: 15),
                  max: Duration(minutes: 5),
                  stepSize: Duration(seconds: 5),
                ),
              );

              if (result != null) {
                setState(() => _selected = result);
                widget.onChanged(result);
              }
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
                        "${localizations.poseDuration}:",
                        style: theme.textTheme.bodyLarge,
                      ),
                      DurationText(
                        Duration(seconds: _selected),
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.textTheme.bodyMedium!.color!.useOpacity(
                            0.7,
                          ),
                        ),
                      ),
                    ],
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
