import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:flutter/material.dart';

class DurationText extends StatelessWidget {
  const DurationText(this.duration, {super.key, this.prefixText});

  final Duration duration;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    return Text(
      (prefixText ?? '') +
          duration.pretty(
            abbreviated: true,
            delimiter: ', ',
            locale: DurationLocale.fromLanguageCode(
              Localizations.localeOf(context).languageCode,
            )!,
          ),
    );
  }
}
