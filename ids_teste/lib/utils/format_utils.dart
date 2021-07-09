

import 'package:intl/intl.dart';

class FormatUtils {
  static const String DATE_FORMAT_BR = "dd/MM/yyyy";


  static final FormatUtils _instance = FormatUtils._();

  static FormatUtils get instance => _instance;

  DateFormat _dateFormat;

  FormatUtils._() {
    _dateFormat = DateFormat("dd/MM/yyyy");
  }

  String formatDate(String pattern, DateTime dateTime) {
    if (_dateFormat.pattern != pattern) {
      _dateFormat = DateFormat(pattern);
    }
    return _dateFormat.format(dateTime);
  }


  static DateTime dateOnly(DateTime dateTime) {
    return DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        0,
        0,
        0,
        0,
        0);
  }

  static String numberOnly(String value) {
    return value != null ? value.replaceAll(RegExp(r'[^\d]'), "") : "";
  }

  calculaIdade(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int idade = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      idade--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        idade--;
      }
    }
    return idade;
  }
}