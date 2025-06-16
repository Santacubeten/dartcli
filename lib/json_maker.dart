import 'dart:convert';
import 'dart:io';

import 'package:generatorob/project_path_provider.dart';

class JsonMaker {
  /// Save the json to the lib/common/rawjson
  static void saveJson(Map<String, dynamic> json, String fileName) {
    var pp = ProjectPathProvider.rawJsonPath; // e.g., lib/common/rawjson
    var dir = Directory(pp);

    if (!dir.existsSync()) {
      print("❌ Directory does not exist: $pp");
      return;
    }

    var file = File("$pp/$fileName.json");

    if (file.existsSync()) {
      print("❌ File already exists: $fileName.json");
      return;
    }

    try {
      var endcode = jsonEncode(json);
      file.writeAsStringSync(endcode); // or jsonEncode(json) for proper JSON
      print("✅ File saved: $pp/$fileName.json");
    } catch (e) {
      print("❗ Error writing file: $e");
    }
  }
}
