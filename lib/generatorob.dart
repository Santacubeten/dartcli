// import 'dart:convert';
// import 'dart:io';

// import 'package:generatorob/extension.dart';
// import 'package:generatorob/helper.dart';
// import 'package:generatorob/messages.dart';
// import 'package:generatorob/model_from_json_gen.dart';
// import 'package:generatorob/model_maker_non_ob.dart';
// import 'package:generatorob/service.dart';

// Future<void> createEndPoint() async {
//   int count = 0;
//   var file = "lib/services/endpoint.dart";
//   var jsonPath = "lib/common/rawjson";
//   var modelPath = "lib/common/models";

//   if (!File(file).existsSync()) {
//     print("Creating... file");
//     File(file).createSync(recursive: true);
//   }

//   if (!Directory(jsonPath).existsSync()) {
//     Directory(jsonPath).createSync(recursive: true);
//   }
//   if (!Directory(modelPath).existsSync()) {
//     Directory(modelPath).createSync(recursive: true);
//   }

//   /// Create empty enpoint class
//   if (File(file).readAsStringSync().isEmpty) {
//     final endpointClass = StringBuffer();
//     print("File is empty");
//     endpointClass.writeln('class EndPoint {');
//     endpointClass.writeln('}');
//     await File(file).writeAsString(endpointClass.toString());
//   }

//   /// Create empty enpoint class END
//   ///user
//   /// Creating baseUrl
//   if (!File(file).readAsStringSync().contains("baseUrl")) {
//     var ans = promptForInput(
//       "Enter baseUrl (eg : https://jsonplaceholder.typicode.com/) : ",
//     );
//     var newString = File(
//       file,
//     ).readAsStringSync().replaceAll("}", '  static const baseUrl = "$ans";\n}');
//     File(file).writeAsStringSync(newString);
//   }

//   String path = "";
//   String variableName = "";
//   // bool isExist = false;

//   /// Creating endpoints
//   while (true) {
//     var ans = promptForInput(
//       "${count + 1}. Enter endpoint (just press enter finish) : ",
//     );

//     if (ans.isEmpty) {
//       break;
//     } else {
//       count += 1;

//       /// * PATH PARAMETER LOGIC
//       var id = int.tryParse(ans.split("/").last);
//       if (id != null) {
//         var raw = ans.split("/");
//         var lastIndex = raw.indexOf(raw.last);
//         raw.removeAt(lastIndex);
//         path = raw.join("/");
//         var variable = raw.join("/").split("/").last;
//         var (isExist, line) = checkDuplicateVariable(File(file), variable);

//         if (isExist) {
//           warningMsg(variable, line, "Path Parameter");
//           var newName = promptForInput(
//             "Type new variable name or Just Enter to skip this : ",
//           );
//           if (newName.isNotEmpty) {
//             variableName = newName;
//           } else {
//             variableName = "";
//           }
//         } else {
//           variableName = variable;
//         }
//         if (variableName.isNotEmpty) {
//           success(path);
//           var newString = File(file).readAsStringSync().replaceAll(
//             "}",
//             '///### Path Paramater\n/// Example: \n///```$ans```\n  static const $variableName = "$path";\n}',
//           );
//           File(file).writeAsStringSync(newString);
//         }
//       }
//       /// * QUERY PARAMETER LOGIC
//       else if (ans.contains("?")) {
//         path = ans.split("?").first;
//         var variable = ans.split("?").first.split("/").last;
//         var (isExist, line) = checkDuplicateVariable(File(file), variable);
//         if (isExist) {
//           warningMsg(variable, line, "Query Parameter");
//           var newName = promptForInput(
//             "Type new variable name or Just Enter to skip this : ",
//           );
//           if (newName.isNotEmpty) {
//             variableName = newName;
//           } else {
//             variableName = "";
//           }
//         } else {
//           variableName = variable;
//         }
//         if (variableName.isNotEmpty) {
//           success(path);
//           var newString = File(file).readAsStringSync().replaceAll(
//             "}",
//             '///### Query Parameter\n/// Example: \n///```$ans```\n static const $variableName = "$path";\n}',
//           );
//           File(file).writeAsStringSync(newString);
//         }
//       }
//       /// * NORMAL LOGIC
//       else {
//         var variable = ans.split("/").last;
//         path = ans;
//         var (isExist, line) = checkDuplicateVariable(File(file), variable);
//         if (isExist) {
//           warningMsg(variable, line, "Normal");
//           var newName = promptForInput(
//             "Type new variable name or Just Enter to skip this : ",
//           );
//           if (newName.isNotEmpty) {
//             variableName = newName;
//           } else {
//             variableName = "";
//           }
//         } else {
//           variableName = variable;
//         }
//         if (variableName.isNotEmpty) {
//           var (host, isSecure) = getHost();

//           // break;
//           success(path);
//           var json = await saveJson(host, ans, isSecure);
//           var modelGen = ModelFromJsonGenerator();
//           modelGen.generate(variableName, json);
//           // File(
//           //   "$jsonPath/$variableName.json",
//           // ).writeAsStringSync(jsonEncode(json));
//           // var newString = File(file).readAsStringSync().replaceAll(
//           //   "}",
//           //   '  static const ${firstLowerCap(variableName)} = "$path";\n}',
//           // );
//           // File(file).writeAsStringSync(newString);
//         }
//       }
//     }
//   }
//   if (count != 0) {
//     var choise = promptForInput("Do you wish to generate model? [Y/N] : ");

//     if (choise.isNotEmpty && choise == "Y" || choise == "y") {
//       List<File> file = []; // files like .jsons
//       List<String> name = [];
//       var dir = Directory(jsonPath).listSync();
//       // print(jsonPath);
//       //elimented Directory and filter json file and save to jsonFile
//       dir.map((e) {
//         if (e is File) {
//           if (e.path.split(Platform.pathSeparator).last.split(".").last ==
//               "json") {
//             file.add(e);
//             name.add(
//               e.path.split(Platform.pathSeparator).last.split(".").first,
//             );
//           }
//         }
//       }).toList();
//       file.map((e) {
//         var read = e.readAsStringSync();
//         Map<String, dynamic> map = jsonDecode(read);
//         String className = e.path
//             .split(Platform.pathSeparator)
//             .last
//             .split(".")
//             .first;
//         var model = generateDartClass(className, map);

//         // generateLog(className.toModelName(), getNestedModel(map));

//         // print(getNestedModel(map));
//         File modelFile = File(
//           '$modelPath/${firstLowerCap(className)}.model.dart',
//         );
//         // modelFile.writeAsStringSync("import 'package:objectbox/objectbox.dart';");
//         modelFile.writeAsStringSync(model);
//       }).toList();
//     }
//     var (baseUrl, enpoints) = extractEndpoint();
//     print("");
//     print("");
//     print("");
//     print("******************************");
//     print("**********COMPLETED***********");
//     print("******************************");
//     print("");
//     print("Base URL : $baseUrl");
//     print("Endpoints");
//     enpoints.map((e) {
//       return print("✔️ $e");
//     }).toList();
//     if (choise.isNotEmpty && choise == "Y" || choise == "y") {
//       var dir = Directory(modelPath).listSync();
//       print(" ");
//       print("Created ${dir.length} Models");

//       dir
//           .map((e) => print("✔️ ${e.path.split(Platform.pathSeparator).last}"))
//           .toList();
//     }
//   }
// }

// /// ### Find the readme.md file and update the readme
// /// - NOTE : Must be the project directory
// ///
// /// ``` <project_name>/README.md ```
// generateLog(String name, List<String> nested) {
//   var currentDir = Directory.current;
//   var l = currentDir.listSync();
//   StringBuffer classBuffer = StringBuffer();
//   String readMePath = "";
//   l.map((e) {
//     if (e is File && e.path.contains("README.md")) {
//       readMePath = e.path;
//     } else {
//       File("README.md").createSync();
//     }
//   }).toList();

//   var date = DateTime.now().toString();
//   classBuffer.writeln();
//   classBuffer.writeln("### $name");
//   classBuffer.writeln(getFormatedDate(date));
//   classBuffer.writeln("    ");
//   if (nested.isNotEmpty) classBuffer.writeln("Inside    ");
//   nested.map((e) {
//     classBuffer.writeln(" - $e");
//   }).toList();

//   var before = File(readMePath).readAsStringSync();
//   File(readMePath).writeAsStringSync("$before \n ${classBuffer.toString()}");
// }

// (bool, String) checkDuplicateVariable(File file, String variable) {
//   var lines = file.readAsLinesSync();
//   bool hasDublicate = false;
//   String existLine = "";
//   List<String> endpoints = [];
//   String baseUrl = "";

//   lines.map((e) {
//     if (e.contains("static const baseUrl")) {
//       baseUrl = e.split('"')[1];
//     }
//     if (e.contains("static const")) {
//       endpoints.add(e.split('"')[1]);
//     }
//   }).toList();
//   endpoints.map((e) {
//     if (e.split("/").last == variable) {}
//   }).toList();

//   for (var i = 0; i < endpoints.length; i++) {
//     if (endpoints[i].split("/").last == variable) {
//       hasDublicate = true;
//       existLine = "static const $variable = $baseUrl${endpoints[i]}";
//       break;
//     }
//   }
//   return (hasDublicate, existLine);
// }

// (String, List<String>) extractEndpoint() {
//   var filePath = "lib/services/endpoint.dart";
//   var file = File(filePath);
//   var lines = file.readAsLinesSync();
//   String baseUrl = "";

//   List<String> endpoints = [];
//   lines.map((e) {
//     //

//     if (e.contains("static const baseUrl")) {
//       baseUrl = e.split('"')[1];
//     }

//     //
//     if (e.contains("static const")) {
//       endpoints.add(e.split('"')[1]);
//     }
//   }).toList();

//   if (baseUrl.isEmpty) {
//     print("Missing baseUrl");
//   }
//   if (endpoints.isEmpty) {
//     print("No any endpoints");
//   }
//   endpoints.removeAt(0);
//   return (baseUrl, endpoints);
// }
// /// Extract and return domain or host from the baseUrl, elimenting the https, // and /
// (String, bool) getHost() {
//   var filePath = "lib/services/endpoint.dart";
//   var file = File(filePath);
//   var lines = file.readAsLinesSync();
//   String baseUrl = "";
//   bool isSecure = false;

//   lines.map((e) {
//     if (e.contains("static const baseUrl")) {
//       baseUrl = e.split('"')[1];
//       if (e.contains("https")) {
//         isSecure = true;
//       }
//     }
//   }).toList();

//   if (baseUrl.isEmpty) {
//     print("Missing baseUrl");
//   }

//   return (baseUrl.split("//").last.split("/").first, isSecure);
// }
// /// NEED TO UPDATE THIS USING HTTP
// /// 
// /// 

