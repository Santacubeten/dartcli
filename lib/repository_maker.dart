import 'dart:io';

import 'package:generatorob/extension.dart';
import 'package:generatorob/project_path_provider.dart';

class RepositoryMaker {
  String repoPath = ProjectPathProvider.repositoryPath;

 

  static createRepositoryFile(String className) {
    final modelName = className.toModelName();
    final boxName = '${modelName}Repository';
    final filePath = '${ProjectPathProvider.repositoryPath}/$boxName.dart';

    if (!File(filePath).existsSync()) {
      final repositoryClass = StringBuffer();
      repositoryClass.writeln('class $boxName {');
      repositoryClass.writeln('  // Repository methods go here');
      repositoryClass.writeln('}');
      File(filePath).writeAsStringSync(repositoryClass.toString());
      print("Repository file created: $filePath");
    } else {
      print("Repository file already exists: $filePath");
    }
  }
}
