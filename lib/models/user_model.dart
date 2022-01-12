import 'dart:convert';

class UserModel {
  final String name;
  final String? photoURL;
  final String id;

  UserModel({
    required this.id,
    required this.name,
    this.photoURL,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'photoURL': photoURL,
        'id': id,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      photoURL: map['photoURL'],
      id: map['id'],
    );
  }

  String toJson() => jsonEncode(toMap());

  factory UserModel.fromJson(String json) =>
      UserModel.fromMap(jsonDecode(json));
}
