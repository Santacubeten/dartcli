import 'dart:io';

import 'package:generatorob/extension.dart';
import 'package:generatorob/helper.dart';
import 'package:generatorob/messages.dart';
import 'package:generatorob/model_from_json_gen.dart';
import 'package:generatorob/repository_maker.dart';
import 'package:generatorob/service.dart';
import 'package:http/http.dart';

enum ApiType {
  pathParam, // e.g., /users/{id}
  queryParam, // e.g., ?search=abc
  bodyParam, // e.g., data sent in POST/PUT request body
}

class EndPointMaker {
  static int count = 0;
  static String file = "lib/services/endpoint.dart";
  static String jsonPath = "lib/common/rawjson";
  static String modelPath = "lib/common/models";

  // static String baseUrl = "";

  static create() async {
    createFile();
    var (baseUrl, endpoint) = getBaseUrlAndEndpoints();
    count = endpoint.length;

    /// Create empty enpoint class
    if (File(file).readAsStringSync().isEmpty) {
      final endpointClass = StringBuffer();
      print("File is empty");
      endpointClass.writeln('class EndPoint {');
      endpointClass.writeln('}');
      await File(file).writeAsString(endpointClass.toString());
    }
    print("☑️ Base URL :  $baseUrl");
    for (var i = 0; i < count; i++) {
      print("☑️ Endpoint :  ${endpoint[i]}");
    }

    if (!File(file).readAsStringSync().contains("baseUrl")) {
      var ans = promptForInput(
        "Enter baseUrl (eg : https://jsonplaceholder.typicode.com/) : ",
      );
      baseUrl = ans;
      var newString = File(file).readAsStringSync().replaceAll(
        "}",
        '  static const baseUrl = "$ans";\n}',
      );

      File(file).writeAsStringSync(newString);
    }

    /// Creating endpoints
    while (true) {
      var ans = promptForInput("Enter endpoint (just press enter finish) : ");

      if (ans.isEmpty) {
        break;
      }

      ApiType type = getApiType(ans);

      // Check for duplicate
      var (hasDuplicate, duplicateLine) = checkDuplicate(ans, type);

      if (hasDuplicate) {
        warningMsg(ans.toEndpointVariableName(), duplicateLine, type);

        while (true) {
          final newName = promptForInput(
            "Type new variable name or just press Enter to skip this endpoint: ",
          );

          // Skip if user presses Enter
          if (newName.trim().isEmpty) break;

          final (newHasDuplicate, newDuplicateLine) = checkDuplicate(
            newName,
            type,
          );

          if (!newHasDuplicate) {
            // Use the new name here
            // For example: addEndpoint(newName);
            printf("✅ Accepted: $newName");
            var newString = File(file).readAsStringSync().replaceAll(
              "}",
              '///### ${type.name}\n/// Example: \n///```$ans```\n  static const ${newName.toEndpointVariableName()} = "${ans.cleanEndpointPath()}";\n}',
            );
            File(file).writeAsStringSync(newString);
            count += 1; // ne this to update only if added

            var url = "$baseUrl/$ans";
            print("☑️ URL :  $url");
            success(ans);
            break;
          }

          // If still duplicate, show warning again
          warningMsg(newName.toEndpointVariableName(), newDuplicateLine, type);
        }
      } else {
        var newString = File(file).readAsStringSync().replaceAll(
          "}",
          '///### ${type.name}\n/// Example: \n///```$ans```\n static const ${ans.toEndpointVariableName()} = "${ans.cleanEndpointPath()}";\n}',
        );
        File(file).writeAsStringSync(newString);
        count += 1; // ne this to update only if added

        var json = await ServiceMaker.fetchJsonFormApi(ans);
        success(ans);
        // print(json);
        var dc = DartClassMaker.generateDartClass(
          ans.toEndpointVariableName(),
          json,
        );
        if (dc.isNotEmpty) {
          var repo = RepositoryMaker.generateRepository(
            ans,
          );
          print(dc);
          print(repo);
          printf("Need to update repo file");
        }
      }
    }
  }

  /// Creates the necessary files and directories if they do not already exist.
  ///
  /// This includes:
  /// - The main output file
  /// - The directory for JSON input files
  /// - The directory for generated model files
  static createFile() {
    if (!File(file).existsSync()) {
      print("Creating... file");
      File(file).createSync(recursive: true);
    }
    if (!Directory(jsonPath).existsSync()) {
      Directory(jsonPath).createSync(recursive: true);
    }
    if (!Directory(modelPath).existsSync()) {
      Directory(modelPath).createSync(recursive: true);
    }
  }

  static (String, List<String>) getBaseUrlAndEndpoints() {
    var lines = File(file).readAsLinesSync();

    List<String> endpoints = [];
    String baseUrl = "";
    lines.map((e) {
      if (e.contains("static const baseUrl")) {
        baseUrl = e.split('"')[1];
      }
      if (e.contains("static const")) {
        endpoints.add(e.split('"')[1]);
      }
    }).toList();
    if (endpoints.length > 1) endpoints.removeAt(0);
    return (baseUrl, endpoints);
  }

  static getApiType(String url) {
    var id = int.tryParse(url.split("/").last);
    if (id != null) {
      return ApiType.pathParam;
    } else if (url.contains('?')) {
      return ApiType.queryParam;
    } else {
      return ApiType.bodyParam;
    }
  }

  static (bool, String) checkDuplicate(String endpoint, ApiType type) {
    final lines = File(file).readAsLinesSync();
    String baseUrl = '';
    final definedEndpoints = <String>[];

    final variable = endpoint.toEndpointVariableName();

    // Extract baseUrl and static const endpoint paths
    for (final line in lines) {
      if (line.contains('static const baseUrl')) {
        final match = RegExp(r'"(.*?)"').firstMatch(line);
        if (match != null) baseUrl = match.group(1)!;
      } else if (line.contains('static const')) {
        final match = RegExp(r'"(.*?)"').firstMatch(line);
        if (match != null) definedEndpoints.add(match.group(1)!);
      }
    }

    // Search for duplicates
    for (final ep in definedEndpoints) {
      if (ep.split('/').last == variable) {
        final existingLine = 'static const $variable = $baseUrl$ep';
        return (true, existingLine);
      }
    }

    return (false, '');
  }
}
