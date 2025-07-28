import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String getName(BuildContext context) {
    final currentLocale = Localizations.localeOf(context).languageCode;

    var date = DateTime.now();
    date = date.add(Duration(days: date.weekday - 1 + index));

    return DateFormat.EEEE(currentLocale).format(date);
  }

  String getAbbreviation(BuildContext context) {
    final currentLocale = Localizations.localeOf(context).languageCode;

    var date = DateTime.now();
    date = date.add(Duration(days: date.weekday - 1 + index));

    return '${DateFormat.E(currentLocale).format(date)}.';
  }
}
