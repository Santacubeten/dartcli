import 'dart:io';

import 'package:generatorob/extension.dart';
import 'package:generatorob/project_path_provider.dart';

class ObjectBoxInitializer {
  static var repoHelperPath = ProjectPathProvider.helper;

  // Lazy getter that initializes and returns the file
  static File get repoHelperFile {
    _ensureFileCreated();
    return _repoHelperFile!;
  }

  static File? _repoHelperFile;

  static void _ensureFileCreated() {
    if (_repoHelperFile != null) return;

    final file = File("$repoHelperPath/helper.dart");

    if (!file.existsSync()) {
      file.createSync(recursive: true);

      final buffer = StringBuffer()
        ..writeln("//imports")
        ..writeln("import '../../objectbox.g.dart';")
        ..writeln("//end of imports")
        ..writeln("//late variable")
        ..writeln("late final Store store;")
        ..writeln("//end of late variables")
        ..writeln("")
        ..writeln("Future<void> initObjectBox() async {")
        ..writeln("//initializer")
        ..writeln("//end of initializer")
        ..writeln("}");

      file.writeAsStringSync(buffer.toString());
    }

    _repoHelperFile = file;
  }

  static Future<void> addMany(List<String> listOfObj) async {
    final content = await repoHelperFile.readAsString();
    final updated = StringBuffer();

    final lines = content.split('\n');
    final importSet = <String>{};
    final lateSet = <String>{};
    final initSet = <String>{};

    for (var line in lines) {
      if (line.trim().startsWith("import")) importSet.add(line.trim());
      if (line.trim().startsWith("late final Box")) lateSet.add(line.trim());
      if (line.trim().contains("= store.box<")) initSet.add(line.trim());
    }

    // Rebuild content with injected lines
    for (var line in lines) {
      updated.writeln(line);

      if (line.trim() == "//imports") {
        for (var e in listOfObj) {
          final imp = "import '../models/${e.toFileName()}';";
          if (!importSet.contains(imp)) updated.writeln(imp);
        }
      }

      if (line.trim() == "//late variable") {
        for (var e in listOfObj) {
          final late = "late final Box<${e.toModelName()}> ${e}Box;";
          if (!lateSet.contains(late)) updated.writeln(late);
        }
      }

      if (line.trim() == "//initializer") {
        for (var e in listOfObj) {
          final init = "${e}Box = store.box<${e.toModelName()}>();";
          if (!initSet.contains(init)) updated.writeln(init);
        }
      }
    }

    await repoHelperFile.writeAsString(updated.toString());
  }

  static Future<void> addOne(String obj) async {
    await addMany([obj]);
  }
}
