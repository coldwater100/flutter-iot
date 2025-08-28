import 'user_model.dart';

class AuthRemoteSource {
  Future<bool> login(String email, String password) async {
    // TODO: 서버 API 연동
    await Future.delayed(const Duration(seconds: 1));
    return (email == "plantT@test.com" && password == "plantT"); // 더미 로그인
  }

  Future<bool> qrLogin(String qrCode) async {
    // TODO: 서버 API 연동
    await Future.delayed(const Duration(seconds: 1));
    return (qrCode == "PLANT-8282"); // 더미 로그인
  }

  Future<bool> signup(UserModel user) async {
    // TODO: 서버 API 연동
    await Future.delayed(const Duration(seconds: 1));
    return true; // 임시 성공
  }
}
