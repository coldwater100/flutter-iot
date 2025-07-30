// ✅ domain: 모델과 유스케이스
// File: features/auth/domain/login_user.dart
abstract class AuthRepository {
  Future<String?> login(String email, String password);
}

class LoginUser {
  final AuthRepository repository;
  LoginUser(this.repository);

  Future<String?> execute(String email, String password) {
    return repository.login(email, password);
  }
}
