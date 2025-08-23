import 'user_entity.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> qrLogin(String qrCode);
  Future<bool> signup(UserEntity user);
}
