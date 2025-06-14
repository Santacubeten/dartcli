// import 'package:generatorob/extension.dart';

// String generateDartClass(String className, Map<String, dynamic> jsonMap) {
//   // Generate Dart code for class definition
//   StringBuffer buffer = StringBuffer();
//   String classNameUpdated = className.toModelName();
//   buffer.writeln("@Entity()");
//   buffer.writeln('class $classNameUpdated {');

//   // Generate Dart code for class properties
//   jsonMap.forEach((key, value) {
//     if (value is List && value.first is Map || value is Map) {
//       buffer.writeln(
//         '  ${modifyString(_getDartType(key, value, backlink: classNameUpdated))}();',
//       );
//     } else if (key == "id") {
//       buffer.writeln('    @Id()\n    int id = 0;');
//     } else {
//       buffer.writeln(
//         '    ${modifyString(_getDartType(key, value, backlink: classNameUpdated))} ${modifyString(key)};',
//       );
//     }
//   });
//   buffer.writeln();

//   buffer.writeln("  @Property(type: PropertyType.date)");
//   buffer.writeln("  DateTime updatedAt;");
//   buffer.writeln();
//   buffer.writeln("  @Property(type: PropertyType.date)");
//   buffer.writeln("  DateTime createdAt;");

//   // Generate constructor
//   buffer.writeln();
//   buffer.writeln('  $classNameUpdated({');

//   jsonMap.forEach((key, value) {
//     if (value is List && value.first is Map) {
//     } else if (value is Map) {
//     } else {
//       buffer.writeln('    required this.${modifyString(key)},');
//     }
//   });
//   buffer.writeln('    DateTime? updatedAt,');
//   buffer.writeln('    DateTime? createdAt,');

//   buffer.writeln('  }) : updatedAt = updatedAt ?? DateTime.now(),');
//   buffer.writeln('       createdAt = createdAt ?? DateTime.now();');

//   // Generate toJson() function
//   buffer.writeln();
//   buffer.writeln('  Map<String, dynamic> toJson() {');
//   buffer.writeln('    return {');
//   jsonMap.forEach((key, value) {
//     if (value is List && value.first is Map) {
//       // ! Update if need
//     } else if (value is Map) {
//       // ! Update if need
//     } else if (value is List) {
//       buffer.writeln("      '${modifyString(key)}': $key.toList(),");
//     } else {
//       buffer.writeln("      '$key': ${modifyString(key)},");
//     }
//   });
//   buffer.writeln('    };');
//   buffer.writeln('  }');

//   buffer.writeln();
//   buffer.writeln(
//     '  factory $classNameUpdated.fromJson(Map<String, dynamic> json) {',
//   );
//   buffer.writeln('    final model = $classNameUpdated(');

//   jsonMap.forEach((key, value) {
//     final fieldName = modifyString(key);

//     if (value is List && value.isNotEmpty && value.first is Map) {
//       // Optional: handle List<Map> here if needed
//       // buffer.writeln("      $fieldName: (json['$key'] as List).map((x) => ${key.toModelName()}.fromJson(x)).toList(),");
//     } else if (value is List && value.isNotEmpty && value.first is String) {
//       buffer.writeln(
//         "      $fieldName: List<String>.from(json['$key'] ?? []),",
//       );
//     } else if (value is Map) {
//       buffer.writeln("      // $fieldName is ToOne<${key.toModelName()}>");
//     } else {
//       buffer.writeln("      $fieldName: json['$key'],");
//     }
//   });

//   buffer.writeln('    );');

//   // Assign nested ToOne objects after constructor
//   jsonMap.forEach((key, value) {
//     final fieldName = modifyString(key);
//     if (value is Map) {
//       buffer.writeln(
//         "    model.$fieldName.target = ${key.toModelName()}.fromJson(json['$key'] ?? {});",
//       );
//     }
//   });

//   buffer.writeln('    return model;');
//   buffer.writeln('  }');

//   //copyWith
//   buffer.writeln('  $classNameUpdated copyWith({');
//   jsonMap.forEach((key, value) {
//     if (value is List && value.first is Map || value is Map) {
//       // buffer.writeln("${modifyString(_getDartType(key, value))}()");
//     } else {
//       buffer.writeln(
//         '     ${modifyString(_getDartType(key, value, backlink: classNameUpdated))}? ${modifyString(key)},',
//       );
//     }
//   });
//   buffer.writeln('  })');
//   buffer.writeln('  {');
//   buffer.writeln('  return $classNameUpdated(');
//   jsonMap.forEach((key, value) {
//     if (value is List && value.first is Map || value is Map) {
//       // buffer.writeln("${modifyString(_getDartType(key, value))}()");
//     } else {
//       buffer.writeln(
//         '   ${modifyString(key)} : ${modifyString(key)} ?? this.${modifyString(key)},',
//       );
//     }
//   });
//   buffer.writeln('  );');

//   // Close class definition
//   buffer.writeln('}');
//   buffer.writeln('}');

//   // Generate Dart model classes for nested objects
//   jsonMap.forEach((key, value) {
//     if (value is Map<String, dynamic>) {
//       buffer.writeln(generateDartClass(key.capitalize(), value));
//     } else if (value is List && value.first is Map<String, dynamic>) {
//       buffer.writeln(generateDartClass(key.capitalize(), value.first));
//     }
//   });

//   return buffer.toString();
// }

// List<String> getNestedModel(Map<String, dynamic> json) {
//   List<String> nestedModel = [];
//   json.forEach((key, value) {
//     if (value is Map<String, dynamic>) {
//       nestedModel.add(key.toModelName());
//     }
//     if (value is List && value.first is Map<String, dynamic>) {
//       nestedModel.add(key.toModelName());
//       getNestedModel(value.first);
//     }
//   });
//   return nestedModel;
// }

// String _getDartType(String key, dynamic value, {required String backlink}) {
//   if (value is int) {
//     return 'int';
//   } else if (value is double) {
//     return 'double';
//   } else if (value is bool) {
//     return 'bool';
//   } else if (value is String) {
//     try {
//       DateTime.parse(value);
//       return "DateTime";
//     } catch (_) {
//       return "String";
//     }
//   } else if (value is List) {
//     if (value.isNotEmpty && value.first is int) {
//       return 'List<int>';
//     } else if (value.isNotEmpty && value.first is String) {
//       return 'List<String>';
//     } else if (value.isNotEmpty && value.first is double) {
//       return 'List<double>';
//     } else if (value.isNotEmpty && value.first is Map) {
//       return "///List of ${key.toModelName()}\n@Backlink('$backlink')\nfinal $key = ToMany<${key.toModelName()}>";
//     } else {
//       return "List<dynamic>";
//     }
//   } else if (value is Map) {
//     return "///Map\n final $key = ToOne<${key.toModelName()}>";
//   } else {
//     return 'dynamic';
//   }
// }

// String modifyString(String input) {
//   List<String> parts = input.split('_');
//   String modifiedString = parts[0]; // Initialize with the first part
//   for (int i = 1; i < parts.length; i++) {
//     modifiedString += parts[i][0].toUpperCase() + parts[i].substring(1);
//   }
//   return modifiedString;
// }