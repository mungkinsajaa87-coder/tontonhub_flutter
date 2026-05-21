import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppFormatters {
  static String date(dynamic value) {
    DateTime? dateTime;
    if (value is Timestamp) dateTime = value.toDate();
    if (value is DateTime) dateTime = value;
    if (value is String) dateTime = DateTime.tryParse(value);
    if (dateTime == null) return '-';
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  static String shortDate(dynamic value) {
    DateTime? dateTime;
    if (value is Timestamp) dateTime = value.toDate();
    if (value is DateTime) dateTime = value;
    if (value is String) dateTime = DateTime.tryParse(value);
    if (dateTime == null) return '-';
    return DateFormat('dd MMM yyyy').format(dateTime);
  }
}
