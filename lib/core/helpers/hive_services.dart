import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox('app');
  }

  static Box get box => Hive.box('app');
}


class HiveKeys {
  static const theme = 'theme';
  static const locale = 'locale';
  static const role = 'role';
}