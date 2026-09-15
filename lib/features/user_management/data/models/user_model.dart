import 'package:aplicacion/features/user_management/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String nickname,
  }) : super(id: id, nickname: nickname);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nickname: json['nickname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      nickname: user.nickname,
    );
  }
}
