import 'dart:io';

import 'package:generatorob/extension.dart';
import 'package:generatorob/project_path_provider.dart';

class RepositoryMaker {
  static var repoPath = ProjectPathProvider.repositoryPath;

  static Future<void> createOne(String name) async {
    final file = File('$repoPath/${name.toLowerCase()}_repository.dart');

    if (await file.exists()) {
      print('Repository "$name" already exists.');
      return;
    }

    await file.create(recursive: true);

    final className = "${name.capitalize()}Repository";
    final modelName = "${name.capitalize()}Model";
    final singular = name.singularize().capitalize();
    final plural = name.pluralize().capitalize();
    final varName = name.singularize();
    final boxName = "${name}Box";

    final buffer = StringBuffer()
      ..writeln("// Repository for $name")
      ..writeln("import '../hepler/helper.dart';")
      ..writeln("import '../models/${name.toLowerCase()}.model.dart';")
      ..writeln("")
      ..writeln("class $className {")
      ..writeln("")
      ..writeln("  // Create")
      ..writeln("  static int create$singular($modelName $varName) {")
      ..writeln("    return $boxName.put($varName);")
      ..writeln("  }")
      ..writeln("")
      ..writeln("  // Read (single)")
      ..writeln("  static $modelName? get$singular(int id) {")
      ..writeln("    return $boxName.get(id);")
      ..writeln("  }")
      ..writeln("")
      ..writeln("  // Read (all)")
      ..writeln("  static List<$modelName> getAll$plural() {")
      ..writeln("    return $boxName.getAll();")
      ..writeln("  }")
      ..writeln("")
      ..writeln("  // Update")
      ..writeln("  static int update$singular($modelName $varName) {")
      ..writeln("    return $boxName.put($varName);")
      ..writeln("  }")
      ..writeln("")
      ..writeln("  // Delete (single)")
      ..writeln("  static bool delete$singular(int id) {")
      ..writeln("    return $boxName.remove(id);")
      ..writeln("  }")
      ..writeln("")
      ..writeln("  // Delete (all)")
      ..writeln("  static int deleteAll$plural() {")
      ..writeln("    return $boxName.removeAll();")
      ..writeln("  }")
      ..writeln("}");

    await file.writeAsString(buffer.toString());
    print('✅ Repository "$className" created at: ${file.path}');
  }

  static Future<void> createMany(List<String> names) async {
    for (var name in names) {
      await createOne(name);
    }
  }
}
