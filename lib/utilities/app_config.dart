import 'package:intl/intl.dart';

class AppConfig {
  static String timeFormatter(DateTime value) {
    return DateFormat('dd.MM.yyyy').format(value);
  }
}
