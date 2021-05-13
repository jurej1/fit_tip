import 'package:intl/intl.dart';

class AppConfig {
  static String dateFormat(DateTime value) {
    return DateFormat('dd.MM.yyyy').format(value);
  }
}
