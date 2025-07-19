import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:yoga_trainer/components/dialogs/radio_dialog.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class TtsVoiceDialog extends StatelessWidget {
  const TtsVoiceDialog({
    super.key,
    required this.voices,
    required this.currentValue,
  });

  final List<Map<String, Object?>> voices;
  final Map<Object?, Object?> currentValue;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    voices.sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));

    return RadioDialog(
      values: voices.map((x) => x['name'].toString()).toList(),
      initialValue: currentValue['name'].toString(),
      title: localizations.settingsTtsVoice,
      getTitle: (voice) => getVoiceName(
        context,
        voice,
        voices.firstWhere((x) => x['name'] == voice)['network_required'] == '1',
      ),
      getSubtitle: (voice) => _getVoiceDescription(
        context,
        voices.firstWhere((x) => x['name'] == voice)['locale'].toString(),
      ),
    );
  }

  static String getVoiceName(
    BuildContext context,
    String voiceName,
    bool isOnline,
  ) {
    final localizations = AppLocalizations.of(context);

    var name = voiceName
        .replaceAll(RegExp('^[a-z]{2}-[a-z]{2}-', caseSensitive: false), '')
        .replaceAll(RegExp('x-'), '')
        .replaceAll(RegExp('-((local)|(network))'), '')
        .replaceAll(
          'language',
          LocaleNamesLocalizationsDelegate.nativeLocaleNames[voiceName
              .substring(0, 2)]!,
        );

    String networkText;

    if (isOnline) {
      networkText = localizations.settingsTtsVoiceNetwork;
    } else {
      networkText = localizations.settingsTtsVoiceLocal;
    }

    if (voiceName.contains('language')) {
      return '${localizations.settingsTtsVoiceDefault} ($networkText)';
    } else {
      return '$name ($networkText)';
    }
  }

  String _getVoiceDescription(BuildContext context, String locale) {
    return LocaleNames.of(context)!.nameOf(locale.replaceAll('-', '_'))!;
  }
}
