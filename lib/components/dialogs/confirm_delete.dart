import 'package:flutter/material.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmDeleteDialog(),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var theme = Theme.of(context);

    return AlertDialog(
      title: Text(localizations.deleteDialogTitle),
      content: Text(localizations.deleteDialogContent),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context, false),
          child: Text(localizations.no),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
          onPressed: () => Navigator.pop(context, true),
          child: Text(localizations.yes),
        ),
      ],
    );
  }
}
