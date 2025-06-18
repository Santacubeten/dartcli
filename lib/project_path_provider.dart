class ProjectPathProvider {
  //lib/services
  static String servicePath = "lib/services";

  ///lib/common/rawjson
  static String rawJsonPath = "lib/common/rawjson";

  ///lib/common/models
  static String modelPath = "lib/common/models";

  ///lib/common/repository
  static String repositoryPath = "lib/common/repository";

  ///lib/common/helper
  static String helper = "lib/common/hepler";
}

const Map<String, dynamic> log = {
  "module": [
    {
      "id": 21313132,
      "flag": true,
      "name": {
        "singular": "user",
        "plural": "users",
        "page": "UserPage",
        "model": "UserModel",
        "endpint_variable": "user",
        "file_name": "user.model.dart",
      },
      "path": {
        "module_path": "lib/module",
        "model_path": "lib/module/model",
        "endpoint_path": "lib/service",
        "repository_path": 'lib/repository',
        "service_path": "lib/service",
        "bloc_path": "lib/module/logic/cubit",
        "raw_json": "lib/common/raw_json",
      },
      "files": {
        "model": "user.model.dart",
        "repository": "user.repo.dart",
        "service": "user.service.dart",
        "json": "user.json",
        "cubit": "user_cubit.dart",
        "state": "user_state.dart",
      },
      "model": [
        {
          "id": 1,
          "name": "user",
          "fields": [
            {"type": "int", "name": "id"},
            {"type": "String", "name": "username"},
            {"type": "DateTime", "name": "created_at"},
          ],
          "relations": [
            {
              "name": "AddressModel",
              "relation_type": "ToOne",
              "foreign_key": "id",
            },
          ],
        },
      ],
      "api": {
        "host": "jsonplaceholder.typicode.com",
        "base_url": "https://jsonplaceholder.typicode.com/",
        "endpoint": "users",
        "type": "path",
        "full_url": "https://jsonplaceholder.typicode.com/users",
        "nested": [
          {
            "name": "userDetail",
            "type": "path",
            "full": "https://jsonplaceholder.typicode.com/users/1",
            "short": "1",
          },
        ],
      },

      "create_at": "",
      "updated_at": "",
    },
  ],
};
