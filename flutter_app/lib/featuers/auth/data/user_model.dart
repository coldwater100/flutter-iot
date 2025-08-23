import '../domain/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.email,
    required super.password,
    super.qrCode,
    super.plantType,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "qrCode": qrCode,
        "plantType": plantType,
      };
}
