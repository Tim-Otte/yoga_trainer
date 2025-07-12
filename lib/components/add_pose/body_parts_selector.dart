import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/extensions/color.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';
import 'package:yoga_trainer/pages/select_body_part.dart';

class BodyPartsSelector extends StatefulWidget {
  final BodyPart? initialValue;
  final Function(BodyPart value) onChanged;

  const BodyPartsSelector({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<BodyPartsSelector> createState() => _BodyPartsSelectorState();
}

class _BodyPartsSelectorState extends State<BodyPartsSelector> {
  BodyPart? _selected;

  @override
  void initState() {
    super.initState();

    _selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final database = Provider.of<AppDatabase>(context);
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, right: 10),
          child: Icon(
            Icons.person_search_outlined,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              // Navigate to SelectBodyPartsPage
              var result = await Navigator.push<BodyPart>(
                context,
                MaterialPageRoute(
                  builder: (context) => Provider(
                    create: (_) => database,
                    child: SelectBodyPart(),
                  ),
                ),
              );
              setState(() => _selected = result);
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
                        "${localizations.poseBodyPart}:",
                        style: theme.textTheme.bodyLarge,
                      ),
                      Text(
                        _selected?.name ?? localizations.poseBodyPartEmpty,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.textTheme.bodyMedium!.color!.useOpacity(
                            0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
