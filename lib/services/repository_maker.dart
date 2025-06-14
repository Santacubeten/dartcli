import 'package:generatorob/extension.dart';

class RepositoryMaker {
  static String generateRepository(String className) {
    final modelName = className.toModelName();
    final boxName = '${modelName}Repository';

    return '''
import 'package:objectbox/objectbox.dart';
import '${className}_model.dart';

class $boxName {
  final Box<$modelName> _box;

  $boxName(this._box);

  int insert($modelName obj) => _box.put(obj);

  void insertMany(List<$modelName> list) => _box.putMany(list);

  $modelName? getById(int id) => _box.get(id);

  List<$modelName> getAll() => _box.getAll();

  bool remove(int id) => _box.remove(id);

  void removeMany(List<int> ids) => _box.removeMany(ids);

  void update($modelName obj) => _box.put(obj);

  void clear() => _box.removeAll();
}
''';
  }
}
