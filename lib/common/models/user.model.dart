import 'package:objectbox/objectbox.dart';

@Entity()
class UserModel {
  @Property(type: PropertyType.date)
  final DateTime createdAt;
  String name;
  String avatar;
  @Id()
  int? id;

  UserModel({
    required this.createdAt,
    required this.name,
    required this.avatar,
    this.id,
  });

  Map<String, dynamic> toJson() => {
    'createdAt': createdAt,
    'name': name,
    'avatar': avatar,
    'id': id,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final obj = UserModel(
      createdAt: DateTime.parse(json['createdAt']),
      name: json['name'],
      avatar: json['avatar'],
      id: json['id'],
    );
    return obj;
  }

  UserModel copyWith({
    DateTime? createdAt,
    String? name,
    String? avatar,
    int? id,
  }) {
    return UserModel(
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      id: id ?? this.id,
    );
  }
}
