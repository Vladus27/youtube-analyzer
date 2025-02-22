import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class Database {
  /*KEYS*/

  static const String personAuthTokenKey = "personAuthToken";

  /*KEYS*/

  static late Box<dynamic> box;

  static Future init() async {
    const secureStorage = FlutterSecureStorage();
    // if key not exists return null
    final encryptionKey = await secureStorage.read(key: 'key');
    if (encryptionKey == null) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: 'key',
        value: base64UrlEncode(key),
      );
    }
    final key = await secureStorage.read(key: 'key');
    final encryptionKeyDecode = base64Url.decode(key!);
    log('Encryption key: $encryptionKeyDecode');

    String? dirPath;
    // if (kIsWeb == false){
    //   final Directory appDocumentsDir = await getApplicationCacheDirectory();
    //   dirPath = appDocumentsDir.path;
    // }


//open box for database
    box = await Hive.openBox('database',
        path: dirPath,
        encryptionCipher: HiveAesCipher(encryptionKeyDecode));
  }

  static void set(dynamic key, dynamic value) {
    box.put(key, value); //write elements into database
    
  }

  static T? get<T>(dynamic key) { // read elements from database
    try {
      return box.get(key) as T;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static clearBox() {
    box.clear();
  }
}