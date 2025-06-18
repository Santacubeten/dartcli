class ModuleModel {
  final int id;
  final bool flag;
  final NameModel name;
  final PathModel path;
  final FilesModel files;
  final List<ModelModel> model;
  final ApiModel api;
  final String createAt;
  final String updatedAt;

  ModuleModel({
    int? id,
    required this.flag,
    required this.name,
    required this.path,
    required this.files,
    required this.model,
    required this.api,
    String? createAt,
    String? updatedAt,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch,
       createAt = createAt ?? DateTime.now().toIso8601String(),
       updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  ModuleModel copyWith({
    int? id,
    bool? flag,
    NameModel? name,
    PathModel? path,
    FilesModel? files,
    List<ModelModel>? model,
    ApiModel? api,
    String? createAt,
    String? updatedAt,
  }) {
    return ModuleModel(
      id: id ?? this.id,
      flag: flag ?? this.flag,
      name: name ?? this.name,
      path: path ?? this.path,
      files: files ?? this.files,
      model: model ?? this.model,
      api: api ?? this.api,
      createAt: createAt ?? this.createAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NameModel {
  final int id;
  final String singular;
  final String plural;
  final String page;
  final String model;
  final String endpintVariable;
  final String fileName;

  NameModel({
    int? id,
    required this.singular,
    required this.plural,
    required this.page,
    required this.model,
    required this.endpintVariable,
    required this.fileName,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  NameModel copyWith({
    int? id,
    String? singular,
    String? plural,
    String? page,
    String? model,
    String? endpintVariable,
    String? fileName,
  }) {
    return NameModel(
      id: id ?? this.id,
      singular: singular ?? this.singular,
      plural: plural ?? this.plural,
      page: page ?? this.page,
      model: model ?? this.model,
      endpintVariable: endpintVariable ?? this.endpintVariable,
      fileName: fileName ?? this.fileName,
    );
  }
}

class PathModel {
  final int id;
  final String modulePath;
  final String modelPath;
  final String endpointPath;
  final String repositoryPath;
  final String servicePath;
  final String blocPath;
  final String rawJson;

  PathModel({
    int? id,
    required this.modulePath,
    required this.modelPath,
    required this.endpointPath,
    required this.repositoryPath,
    required this.servicePath,
    required this.blocPath,
    required this.rawJson,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  PathModel copyWith({
    int? id,
    String? modulePath,
    String? modelPath,
    String? endpointPath,
    String? repositoryPath,
    String? servicePath,
    String? blocPath,
    String? rawJson,
  }) {
    return PathModel(
      id: id ?? this.id,
      modulePath: modulePath ?? this.modulePath,
      modelPath: modelPath ?? this.modelPath,
      endpointPath: endpointPath ?? this.endpointPath,
      repositoryPath: repositoryPath ?? this.repositoryPath,
      servicePath: servicePath ?? this.servicePath,
      blocPath: blocPath ?? this.blocPath,
      rawJson: rawJson ?? this.rawJson,
    );
  }
}

class FilesModel {
  final int id;
  final String model;
  final String repository;
  final String service;
  final String json;
  final String cubit;
  final String state;

  FilesModel({
    int? id,
    required this.model,
    required this.repository,
    required this.service,
    required this.json,
    required this.cubit,
    required this.state,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  FilesModel copyWith({
    int? id,
    String? model,
    String? repository,
    String? service,
    String? json,
    String? cubit,
    String? state,
  }) {
    return FilesModel(
      id: id ?? this.id,
      model: model ?? this.model,
      repository: repository ?? this.repository,
      service: service ?? this.service,
      json: json ?? this.json,
      cubit: cubit ?? this.cubit,
      state: state ?? this.state,
    );
  }
}

class ModelModel {
  final int id;
  final String name;
  final List<FieldModel> fields;
  final List<RelationModel> relations;

  ModelModel({
    int? id,
    required this.name,
    required this.fields,
    required this.relations,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  ModelModel copyWith({
    int? id,
    String? name,
    List<FieldModel>? fields,
    List<RelationModel>? relations,
  }) {
    return ModelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      fields: fields ?? this.fields,
      relations: relations ?? this.relations,
    );
  }
}

class FieldModel {
  final int id;
  final String type;
  final String name;

  FieldModel({int? id, required this.type, required this.name})
    : id = id ?? DateTime.now().millisecondsSinceEpoch;

  FieldModel copyWith({int? id, String? type, String? name}) {
    return FieldModel(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
    );
  }
}

class RelationModel {
  final int id;
  final String name;
  final String relationType;
  final String foreignKey;

  RelationModel({
    int? id,
    required this.name,
    required this.relationType,
    required this.foreignKey,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  RelationModel copyWith({
    int? id,
    String? name,
    String? relationType,
    String? foreignKey,
  }) {
    return RelationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      relationType: relationType ?? this.relationType,
      foreignKey: foreignKey ?? this.foreignKey,
    );
  }
}

class ApiModel {
  final int id;
  final String host;
  final String baseUrl;
  final String endpoint;
  final String type;
  final String fullUrl;
  final List<NestedModel> nested;

  ApiModel({
    int? id,
    required this.host,
    required this.baseUrl,
    required this.endpoint,
    required this.type,
    required this.fullUrl,
    required this.nested,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  ApiModel copyWith({
    int? id,
    String? host,
    String? baseUrl,
    String? endpoint,
    String? type,
    String? fullUrl,
    List<NestedModel>? nested,
  }) {
    return ApiModel(
      id: id ?? this.id,
      host: host ?? this.host,
      baseUrl: baseUrl ?? this.baseUrl,
      endpoint: endpoint ?? this.endpoint,
      type: type ?? this.type,
      fullUrl: fullUrl ?? this.fullUrl,
      nested: nested ?? this.nested,
    );
  }
}

class NestedModel {
  final int id;
  final String name;
  final String type;
  final String full;
  final String shortVal;

  NestedModel({
    int? id,
    required this.name,
    required this.type,
    required this.full,
    required this.shortVal,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  NestedModel copyWith({
    int? id,
    String? name,
    String? type,
    String? full,
    String? shortVal,
  }) {
    return NestedModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      full: full ?? this.full,
      shortVal: shortVal ?? this.shortVal,
    );
  }
}
