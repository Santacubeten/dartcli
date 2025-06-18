import 'package:intl/intl.dart';

/// Extension methods on [String] for formatting and conversions.
extension StringExtension on String {
  /// Capitalizes the first letter of the string.
  ///
  /// Example:
  /// `"hello".capitalize()` → `"Hello"`
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  /// Converts to camelCase.
  ///
  /// Example:
  /// `"UserName".toCamelCase()` → `"userName"`
  String toCamelCase() {
    return length > 1 ? this[0].toLowerCase() + substring(1) : toLowerCase();
  }

  /// Converts snake_case to PascalCase + `Model` suffix.
  ///
  /// Example:
  /// `"user_profile".toModelName()` → `"userProfileModel"`
  /// `"user".toModelName()` → `"UserModel"`
  String toModelName() {
    var string = "${this[0].toUpperCase()}${substring(1)}";
    if (string.contains("_")) {
      List<String> parts = string.split('_');
      return "${parts.first}${parts.last[0].toUpperCase()}${parts.last.substring(1)}Model";
    } else {
      return "${string}Model";
    }
  }

  /// Converts snake_case to PascalCase + `Repository` suffix.
  ///
  /// Example:
  /// `"user_profile".toRepoName()` → `"userProfileReposiitory"`
  /// `"user".toRepoName()` → `"UserRepository"`
  String toRepoName() {
    var string = "${this[0].toUpperCase()}${substring(1)}";
    if (string.contains("_")) {
      List<String> parts = string.split('_');
      return "${parts.first}${parts.last[0].toUpperCase()}${parts.last.substring(1)}Repository";
    } else {
      return "${string}Repository";
    }
  }

  /// Converts snake_case to camelCase with `Model` suffix.
  ///
  /// Example:
  /// `"user_profile".toVariableName()` → `"userProfileModel"`
  /// `"user".toVariableName()` → `"userModel"`
  String toVariableName() {
    if (contains("_")) {
      List<String> parts = split('_');
      return "${parts.first.toLowerCase()}${parts.skip(1).map((e) => e[0].toUpperCase() + e.substring(1)).join()}Model";
    } else {
      return "${this[0].toLowerCase()}${substring(1)}Model";
    }
  }

  String toJsonFileName() {
    if (contains("_")) {
      List<String> parts = split('_');
      return "${parts.first.toLowerCase()}${parts.skip(1).map((e) => e[0].toUpperCase() + e.substring(1)).join()}Model";
    } else {
      return "${this[0].toLowerCase()}${substring(1)}";
    }
  }

  /// Converts the string to a `.model.dart` file name.
  ///
  /// Example:
  /// `"userProfile".toFileName()` → `"userprofile.model.dart"`
  String toFileName() {
    return "${toLowerCase()}.model.dart";
  }

  /// Extracts a clean variable name from an API endpoint.
  ///
  /// Removes query params and trailing numeric IDs.
  ///
  /// Examples:
  /// `"/user/123".toEndpointVariableName()` → `"user"`
  /// `"/search?query=x".toEndpointVariableName()` → `"search"`
  String toEndpointVariableName() {
    final path = split('?').first;
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty) return '';
    final last = segments.last;
    final isId = int.tryParse(last) != null;
    final result = isId && segments.length > 1
        ? segments[segments.length - 2]
        : last;
    return result.toLowerCase();
  }

  /// Removes query params and numeric IDs from endpoint path.
  ///
  /// Examples:
  /// `"/user/123".cleanEndpointPath()` → `"/user"`
  /// `"/product/details?type=basic".cleanEndpointPath()` → `"/product/details"`
  String cleanEndpointPath() {
    final path = split('?').first;
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty) return '';
    if (int.tryParse(segments.last) != null) {
      segments.removeLast();
    }
    return '/${segments.join('/')}';
  }

  String singularize() {
    if (endsWith('ies')) {
      return '${substring(0, length - 3)}y';
    } else if (endsWith('ses') || endsWith('xes')) {
      return substring(0, length - 2);
    } else if (endsWith('s') && !endsWith('ss')) {
      return substring(0, length - 1);
    }
    return this;
  }

  String pluralize() {
    if (endsWith('y') && length > 1 && !isVowel(this[length - 2])) {
      return '${substring(0, length - 1)}ies';
    } else if (endsWith('s') ||
        endsWith('x') ||
        endsWith('z') ||
        endsWith('ch') ||
        endsWith('sh')) {
      return '${this}es';
    } else {
      return '${this}s';
    }
  }

  bool isVowel(String c) => 'aeiou'.contains(c.toLowerCase());
}

/// Converts an ISO date string into a readable format with emoji icons.
///
/// Example:
/// `getFormatedDate("2023-11-23T10:30:00")` → `"📅 Thursday, November 23, 2023 | ⌚ 10:30 AM"`
String getFormatedDate(String inputDate) {
  DateTime dateTime = DateTime.parse(inputDate);
  String time = DateFormat('jm').format(dateTime);
  String date = DateFormat('yMMMMEEEEd').format(dateTime);
  return "📅 $date | ⌚ $time";
}
