import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:yoga_trainer/components/dialogs/checkbox_dialog.dart';
import 'package:yoga_trainer/entities/weekday.dart';
import 'package:yoga_trainer/extensions/color.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class WeekdaysSelector extends StatefulWidget {
  final List<Weekday> initialValue;
  final Function(List<Weekday> value) onChanged;

  const WeekdaysSelector({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<WeekdaysSelector> createState() => _WeekdaysSelectorState();
}

class _WeekdaysSelectorState extends State<WeekdaysSelector> {
  List<Weekday> _selected = [];

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
            Symbols.calendar_month,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              var result = await showDialog<List<Weekday>>(
                context: context,
                builder: (context) => CheckboxDialog(
                  title: localizations.workoutWeekdays,
                  values: Weekday.values,
                  initialValue: _selected,
                  getTitle: (item) => item.getName(context),
                ),
              );
              setState(() => _selected = result ?? []);
              if (result != null) {
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
                        "${localizations.workoutWeekdays}:",
                        style: theme.textTheme.bodyLarge,
                      ),
                      Text(
                        _selected.isEmpty
                            ? localizations.workoutWeekdaysEmpty
                            : _selected
                                  .map((item) => item.getAbbreviation(context))
                                  .join(', '),
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.textTheme.bodyMedium!.color!.useOpacity(
                            0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Icon(Symbols.chevron_right),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
