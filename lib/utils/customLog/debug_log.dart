import 'dart:developer' as dev;

import 'package:logger/logger.dart';

class DebugLog {
  static myLog(String text) {
    dev.log(text);
  }

  static final logger = Logger(printer: PrettyPrinter(colors: true));

  static void d(message) {
    return logger.d(message);
  }

  static void e(message) {
    return logger.e(message);
  }

  static void i(message) {
    return logger.i(message);
  }

  static void w(message) {
    return logger.w(message);
  }
}
