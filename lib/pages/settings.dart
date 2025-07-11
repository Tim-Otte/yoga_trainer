import 'package:flutter/material.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';
import 'package:yoga_trainer/pages/page_infos.dart';

class SettingsPage extends StatelessWidget implements PageInfos {
  const SettingsPage({super.key});

  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context).settings;
  }

  @override
  IconData getIcon() {
    return Icons.settings;
  }

  @override
  Widget? getFAB(BuildContext context) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ],
    );
  }
}
