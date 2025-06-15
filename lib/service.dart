import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceMaker {
  /// Example usage: https://jsonplaceholder.typicode.com/users/1
  ///
  /// To use this method:
  /// - Set `baseUrl` to: `jsonplaceholder.typicode.com`
  /// - Set `endpoint` to: `users/1`
  ///
  /// This method fetches a JSON response from the specified API endpoint.
  static Future<Map<String, dynamic>> fetchJsonFormApi(
    // String baseUrl,
    endpoint,
    // bool isSecure,
  ) async {
    late Uri uri;
    var (host, isSecure) = getHost();
    try {
      if (isSecure) {
        uri = Uri.https(host, endpoint);
      } else {
        uri = Uri.http(host, endpoint);
      }
      var response = await http.get(uri);
      uri = Uri.http(host, endpoint);
      response = await http.get(uri);

      if (response.statusCode == 200) {
        print('Response status: ${response.statusCode}');
        // Decode the JSON string and return the result
        var output = json.decode(response.body);
        if (output is List && output.isNotEmpty) {
          return output.first;
        } else if (output is Map<String, dynamic>) {
          return output;
        } else {
          throw Exception();
        }
      } else {
        print('Failed to load JSON. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(); // Return null or throw an exception on failure
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw Exception(); // Return null or throw an exception on failure
    }
  }

  static (String, bool) getHost() {
    var filePath = "lib/services/endpoint.dart";
    var file = File(filePath);
    var lines = file.readAsLinesSync();
    String baseUrl = "";
    bool isSecure = false;

    lines.map((e) {
      if (e.contains("static const baseUrl")) {
        baseUrl = e.split('"')[1];
        if (e.contains("https")) {
          isSecure = true;
        }
      }
    }).toList();

    if (baseUrl.isEmpty) {
      print("Missing baseUrl");
    }

    return (baseUrl.split("//").last.split("/").first, isSecure);
  }
}
