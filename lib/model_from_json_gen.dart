import 'package:generatorob/extension.dart';

class DartClassMaker {
  static String generateDartClass(
    String className,
    Map<String, dynamic> jsonMap,
  ) {
    StringBuffer classBuffer = StringBuffer();
    String classNameUpdated = className.toModelName();

    classBuffer.writeln('@Entity()');
    classBuffer.writeln('class $classNameUpdated {');

    // ID field
    final hasId = jsonMap.keys.any((k) => k == 'id');
    if (!hasId) {
      classBuffer.writeln('  @Id\n  int id = 0;');
    }

    // Fields
    jsonMap.forEach((key, value) {
      final fieldName = firstLowerCap(modifyString(key));
      if (key == 'id') {
        classBuffer.writeln('  @Id\n  int id = 0;');
      } else if (value is Map<String, dynamic>) {
        final nestedType = key.toModelName();
        classBuffer.writeln('  final $fieldName = ToOne<$nestedType>();');
      } else if (value is List &&
          value.isNotEmpty &&
          value.first is Map<String, dynamic>) {
        final nestedType = key.toModelName();
        classBuffer.writeln(
          "  @Backlink('${className.toCamelCase()}')",
        ); // backlink to parent
        classBuffer.writeln('  final $fieldName = ToMany<$nestedType>();');
      } else {
        classBuffer.writeln(
          '  ${modifyString(_getDartType(key, value))} $fieldName;',
        );
      }
    });

    // Constructor
    classBuffer.writeln();
    classBuffer.writeln('  $classNameUpdated({');
    jsonMap.forEach((key, value) {
      final fieldName = firstLowerCap(modifyString(key));
      if (!(value is Map ||
          (value is List && value.isNotEmpty && value.first is Map))) {
        classBuffer.writeln('    required this.$fieldName,');
      }
    });
    classBuffer.writeln('  });');

    // toJson
    classBuffer.writeln();
    classBuffer.writeln('  Map<String, dynamic> toJson() => {');
    jsonMap.forEach((key, value) {
      final fieldName = firstLowerCap(modifyString(key));
      if (value is Map<String, dynamic>) {
        classBuffer.writeln("    '$fieldName': $fieldName.target?.toJson(),");
      } else if (value is List &&
          value.isNotEmpty &&
          value.first is Map<String, dynamic>) {
        classBuffer.writeln(
          "    '$fieldName': $fieldName.map((e) => e.toJson()).toList(),",
        );
      } else {
        classBuffer.writeln("    '$fieldName': $fieldName,");
      }
    });
    classBuffer.writeln('  };');

    // fromJson
    classBuffer.writeln();
    classBuffer.writeln(
      '  factory $classNameUpdated.fromJson(Map<String, dynamic> json) {',
    );
    classBuffer.writeln('    final obj = $classNameUpdated(');
    jsonMap.forEach((key, value) {
      final fieldName = firstLowerCap(modifyString(key));
      if (!(value is Map ||
          (value is List && value.isNotEmpty && value.first is Map))) {
        if (value is List && value.isNotEmpty && value.first is String) {
          classBuffer.writeln(
            "      $fieldName: List<String>.from(json['$fieldName']),",
          );
        } else if (value is String && _looksLikeDate(value)) {
          classBuffer.writeln(
            "      $fieldName: DateTime.parse(json['$fieldName']),",
          );
        } else {
          classBuffer.writeln("      $fieldName: json['$fieldName'],");
        }
      }
    });
    if (!hasId) classBuffer.writeln("      id: 0,");
    classBuffer.writeln('    );');

    // Handle ToOne / ToMany
    jsonMap.forEach((key, value) {
      final fieldName = firstLowerCap(modifyString(key));
      final classType = key.toModelName();
      if (value is Map<String, dynamic>) {
        classBuffer.writeln(
          "    if (json['$fieldName'] != null) obj.$fieldName.target = $classType.fromJson(json['$fieldName']);",
        );
      } else if (value is List &&
          value.isNotEmpty &&
          value.first is Map<String, dynamic>) {
        classBuffer.writeln(
          "    if (json['$fieldName'] != null) obj.$fieldName.addAll(List<$classType>.from(json['$fieldName'].map((x) => $classType.fromJson(x))));",
        );
      }
    });
    classBuffer.writeln('    return obj;');
    classBuffer.writeln('  }');

    // copyWith
    classBuffer.writeln();
    classBuffer.writeln('  $classNameUpdated copyWith({');
    jsonMap.forEach((key, value) {
      final fieldName = firstLowerCap(modifyString(key));
      if (!(value is Map ||
          (value is List && value.isNotEmpty && value.first is Map))) {
        classBuffer.writeln(
          '    ${modifyString(_getDartType(key, value))}? $fieldName,',
        );
      }
    });
    classBuffer.writeln('  }) {');
    classBuffer.writeln('    return $classNameUpdated(');
    jsonMap.forEach((key, value) {
      final fieldName = firstLowerCap(modifyString(key));
      if (!(value is Map ||
          (value is List && value.isNotEmpty && value.first is Map))) {
        classBuffer.writeln('      $fieldName: $fieldName ?? this.$fieldName,');
      }
    });
    classBuffer.writeln('    );');
    classBuffer.writeln('  }');

    classBuffer.writeln('}');

    // Recursively generate nested classes
    jsonMap.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        classBuffer.writeln(generateDartClass(key.capitalize(), value));
      } else if (value is List &&
          value.isNotEmpty &&
          value.first is Map<String, dynamic>) {
        classBuffer.writeln(generateDartClass(key.capitalize(), value.first));
      }
    });

    return classBuffer.toString();
  }
}

// Helpers

String _getDartType(String key, dynamic value) {
  if (value is int) return 'int';
  if (value is double) return 'double';
  if (value is bool) return 'bool';
  if (value is String) {
    return DateTime.tryParse(value) != null ? 'DateTime' : 'String';
  }
  if (value is List) {
    if (value.isEmpty) return 'List<dynamic>';
    if (value.first is int) return 'List<int>';
    if (value.first is String) return 'List<String>';
    if (value.first is double) return 'List<double>';
    return 'List<${key.toModelName()}>';
  }
  if (value is Map) return key.toModelName();
  return 'dynamic';
}

String modifyString(String input) {
  final parts = input.split('_');
  return parts.first + parts.skip(1).map((e) => e.capitalize()).join();
}

String firstLowerCap(String input) =>
    input.isEmpty ? input : input[0].toLowerCase() + input.substring(1);

bool _looksLikeDate(String value) {
  try {
    return DateTime.tryParse(value) != null;
  } catch (_) {
    return false;
  }
}
