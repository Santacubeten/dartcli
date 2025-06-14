import 'package:intl/intl.dart';

// Extension on String to capitalize the first letter of the string.
extension StringExtension on String {
  /// Returns a new string with the first character in uppercase
  /// and the rest of the string unchanged.
  ///
  /// Example:
  /// ```dart
  /// print("hello".capitalize()); // Output: Hello
  /// ```
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String toCamelCase() {
    return length > 1 ? this[0].toLowerCase() + substring(1) : toLowerCase();
  }

  String toModelName() {
    var string = "${this[0].toUpperCase()}${substring(1)}";
    var pass = "";

    if (string.contains("_")) {
      List<String> parts = string.split('_');
      pass =
          "${parts.first}${parts.last[0].toUpperCase()}${parts.last.substring(1)}Model";
    } else {
      pass = "${string}Model";
    }
    return pass;
  }

  String toVariableName() {
    String result;

    if (contains("_")) {
      List<String> parts = split('_');
      // Capitalize each part except the first
      result =
          parts.first.toLowerCase() +
          parts.skip(1).map((e) => e[0].toUpperCase() + e.substring(1)).join();
    } else {
      result = this[0].toLowerCase() + substring(1);
    }

    return "${result}Model";
  }

  String toFileName() {
    return "${toLowerCase()}.model.dart";
  }

  // String toEndpointVariableName() {
  //   String variable;
  //   var raw = this;
  //   var id = int.tryParse(raw.split("/").last);
  //   if (id != null) {
  //     var a = raw.split("/");
  //     var i = a.indexOf(a.last);
  //     a.removeAt(i);
  //     variable = a.join("/").split("/").last;
  //   } else if (raw.contains('?')) {
  //     variable = raw.split("?").first.split("/").last;
  //   } else {
  //     variable = raw.split("/").last;
  //   }

  //   return variable;
  // }

  /// Extension method to extract a clean variable name from an API endpoint path.
  /// Handles cases where the endpoint ends with an ID or query parameters.
  String toEndpointVariableName() {
    // Remove any query parameters, e.g., "/api/item?type=x" → "/api/item"
    final path = split('?').first;

    // Split the path into parts, and remove any empty segments from extra slashes
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();

    // If the path is empty or invalid, return an empty string
    if (segments.isEmpty) return '';

    // Get the last segment of the path
    final last = segments.last;

    // Check if the last segment is a numeric ID
    final isId = int.tryParse(last) != null;

    // If the last part is an ID and there is a segment before it, return the second last
    // Else return the last segment itself
    return isId && segments.length > 1 ? segments[segments.length - 2] : last;
  }

  /// Returns the base endpoint path by removing any trailing ID or query params.
  /// Examples:
  ///   "/api/user/123" => "/api/user"
  ///   "/product/details?type=basic" => "/product/details"
  String cleanEndpointPath() {
    // Remove query string
    final path = split('?').first;

    // Split into non-empty segments
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();

    if (segments.isEmpty) return '';

    // If last segment is a number (ID), remove it
    if (int.tryParse(segments.last) != null) {
      segments.removeLast();
    }

    // Return reconstructed path
    return '/${segments.join('/')}';
  }
}

String getFormatedDate(String inputDate) {
  DateTime dateTime = DateTime.parse(inputDate);

  String time = DateFormat('jm').format(dateTime);
  String date = DateFormat('yMMMMEEEEd').format(dateTime);

  return "📅 $date | ⌚ $time"; // Output: 23 November 2023
}
