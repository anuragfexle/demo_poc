import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime dateTime) {
    // formated date DD-MMM-YYYY HH:MM
    return DateFormat('dd-MMM-yyyy HH:mm').format(dateTime);
  }

  static String formatLocal(DateTime dateTime) {
    return DateFormat('dd-MMM-yyyy HH:mm').format(dateTime.toLocal());
  }
}
