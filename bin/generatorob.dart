import 'dart:io';

import 'package:generatorob/enpoint_maker.dart';
import 'package:generatorob/extension.dart';
import 'package:generatorob/faker.dart';
import 'package:generatorob/helper.dart';
import 'package:generatorob/json_maker.dart';
import 'package:generatorob/AI_model_from_json_gen.dart';
import 'package:generatorob/messages.dart';
import 'package:generatorob/object_box_initializer.maker.dart';
import 'package:generatorob/service.dart';
import 'package:generatorob/repository_maker.dart';

void main(List<String> arguments) async {
  var list = await EndPointMaker.create();
  await ObjectBoxInitializer.addMany(list);

  printf("Running build_runner for objectbox... please wait");
  await Process.run('dart', [
    'pub',
    'run',
    'build_runner',
    'build',
  ], runInShell: true).then((result) {
    if (result.exitCode == 0) {
      list.map((e) => print("✅ Build Success : ${e.toFileName()}")).toList();
    } else {
      print("❗ Error : ${result.stderr}");
    }
  });
  await RepositoryMaker.createMany(list);
}

// reset()async{
//   await Process.run(
//     'rmdir ',
//     [
//       '/s',
//       '/q',
//       'lib'
//     ],
//     runInShell: true,
//   );
// }
