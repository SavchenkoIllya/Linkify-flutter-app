import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'dart:developer' as devtools show log;

class Storage {
  static const storage = FlutterSecureStorage();
  late var needThis = '';

  void writeValue(key, value) async {
    await storage.write(key: key, value: value);
  }

  dynamic readValue(key) async {
    await storage.read(key: key).then(
      (value) {
        needThis = value!;
      },
    );
  }
}
