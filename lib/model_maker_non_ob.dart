import 'package:generatorob/extension.dart';

String generateDartClass(String className, Map<String, dynamic> jsonMap) {
  // Generate Dart code for class definition
  StringBuffer classBuffer = StringBuffer();
  String classNameUpdated = className.toModelName();
  classBuffer.writeln('class $classNameUpdated {');

  // Generate Dart code for class properties
  jsonMap.forEach((key, value) {
    classBuffer.writeln(
      '  final ${modifyString(_getDartType(key, value))} ${firstLowerCap(modifyString(key))};',
    );
  });

  // Generate constructor
  classBuffer.writeln();
  classBuffer.writeln('  $classNameUpdated({');

  jsonMap.forEach((key, value) {
    classBuffer.writeln(
      '    required this.${firstLowerCap(modifyString(key))},',
    );
  });

  classBuffer.writeln('  });');

  // Generate toJson() function
  classBuffer.writeln();
  classBuffer.writeln('  Map<String, dynamic> toJson() {');
  classBuffer.writeln('    return {');
  jsonMap.forEach((key, value) {
    if (value is List &&
        value.isNotEmpty &&
        value.first is Map<String, dynamic>) {
      // If the value is a list of maps, map each item to its JSON representation
      classBuffer.writeln(
        "    '${firstLowerCap(key)}': ${modifyString(key)}.map((item) => item.toJson()).toList(),",
      );
    } else if (value is Map<String, dynamic>) {
      classBuffer.writeln("      '${modifyString(key)}': $key.toJson(),");
    } else if (value is List) {
      classBuffer.writeln("      '${modifyString(key)}': $key.toList(),");
    } else {
      classBuffer.writeln(
        "    '${firstLowerCap(key)}': ${firstLowerCap(modifyString(key))},",
      );
    }
  });
  classBuffer.writeln('    };');
  classBuffer.writeln('  }');

  classBuffer.writeln();
  classBuffer.writeln(
    '  factory $classNameUpdated.fromJson(Map<String, dynamic> json) {',
  );
  classBuffer.writeln('    return $classNameUpdated(');
  jsonMap.forEach((key, value) {
    if (value is List &&
        value.isNotEmpty &&
        value.first is Map<String, dynamic>) {
      // If the value is a list of maps, map each item from JSON to its class representation
      classBuffer.writeln(
        "      ${modifyString(key)}:  List<${key.toModelName()}>.from(json['${firstLowerCap(key)}'].map((x) => ${key.toModelName()}.fromJson(x))),",
      );
    } else if (value is List && value.isNotEmpty && value.first is String) {
      classBuffer.writeln(
        "      $key:  List<String>.from(json['${firstLowerCap(key)}']),",
      );
    } else if (value is Map<String, dynamic>) {
      classBuffer.writeln(
        "      $key: ${key.toModelName()}.fromJson(json['${firstLowerCap(key)}']),",
      );
    } else {
      classBuffer.writeln(
        "      ${firstLowerCap(modifyString(key))}: json['${firstLowerCap(key)}'],",
      );
    }
  });
  classBuffer.writeln('    );');
  classBuffer.writeln('  }');

  //copyWith
  classBuffer.writeln('  $classNameUpdated copyWith({');
  jsonMap.forEach((key, value) {
    classBuffer.writeln(
      '     ${modifyString(_getDartType(key, value))}? ${firstLowerCap(modifyString(key))},',
    );
  });
  classBuffer.writeln('  })');
  classBuffer.writeln('  {');
  classBuffer.writeln('  return $classNameUpdated(');
  jsonMap.forEach((key, value) {
    classBuffer.writeln(
      '   ${firstLowerCap(modifyString(key))} : ${firstLowerCap(modifyString(key))} ?? this.${firstLowerCap(modifyString(key))},',
    );
  });
  classBuffer.writeln('  );');

  // Close class definition
  classBuffer.writeln('}');
  classBuffer.writeln('}');

  // Generate Dart model classes for nested objects
  jsonMap.forEach((key, value) {
    if (value is Map<String, dynamic>) {
      classBuffer.writeln(generateDartClass(key.capitalize(), value));
    } else if (value is List && value.first is Map<String, dynamic>) {
      classBuffer.writeln(generateDartClass(key.capitalize(), value.first));
    }
  });

  return classBuffer.toString();
}

String _getDartType(String key, dynamic value) {
  if (value is int) {
    return 'int';
  } else if (value is double) {
    return 'double';
  } else if (value is bool) {
    return 'bool';
  } else if (value is String) {
    if (DateTime.tryParse(value) != null) {
      return 'DateTime';
    } else {
      return 'String';
    }
  } else if (value is List) {
    if (value.isNotEmpty && value.first.runtimeType == int) {
      return 'List<int>';
    } else if (value.isNotEmpty && value.first.runtimeType == String) {
      return 'List<String>';
    } else if (value.isNotEmpty && value.first.runtimeType == double) {
      return 'List<double>';
    } else {
      return 'List<${key.toModelName()}>';
    }
  } else if (value is Map) {
    String nestedClassName = key.toModelName(); // Capitalize the first letter
    return nestedClassName;
  } else {
    return 'dynamic';
  }
}

String modifyString(String input) {
  List<String> parts = input.split('_');
  String modifiedString = parts[0]; // Initialize with the first part
  for (int i = 1; i < parts.length; i++) {
    modifiedString += parts[i][0].toUpperCase() + parts[i].substring(1);
  }
  return modifiedString;
}

String firstLowerCap(String input) {
  return input[0].toLowerCase() + input.substring(1);
}
