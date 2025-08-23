class UserEntity {
  final String email;
  final String password;
  final String? qrCode;
  final String? plantType;

  UserEntity({
    required this.email,
    required this.password,
    this.qrCode,
    this.plantType,
  });
}
