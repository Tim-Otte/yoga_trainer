import 'package:flutter/material.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class ConfirmAddWithoutPosesDialog extends StatelessWidget {
  const ConfirmAddWithoutPosesDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmAddWithoutPosesDialog(),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    var theme = Theme.of(context);

    return AlertDialog(
      title: Text(localizations.addWithoutPosesDialogTitle),
      content: Text(localizations.addWithoutPosesDialogContent),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context, false),
          child: Text(localizations.no),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onPrimary, backgroundColor: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context, true),
          child: Text(localizations.yes),
        ),
      ],
    );
  }
}
