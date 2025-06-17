import 'dart:io';

import 'package:generatorob/project_path_provider.dart';

class ObjectBoxInitializer {
  var rp = ProjectPathProvider.repositoryPath;

  ObjectBoxInitializer() {
    var file = File("$rp/obIntializer.dart");
    if (!file.existsSync()) {
      file.createSync(recursive: true);

    }
  }

  create(){

  }
}
