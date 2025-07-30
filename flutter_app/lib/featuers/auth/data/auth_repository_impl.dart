// ✅ data: 실제 통신 구현
// File: features/auth/data/auth_repository_impl.dart
import '../domain/login_user.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String?> login(String email, String password) async {
    // 테스트용 ID/PW
    const mockEmail = '1111';
    const mockPassword = '1111';

    await Future.delayed(const Duration(milliseconds: 500));

    if (email == mockEmail && password == mockPassword) {
      return 'mock-token-abc123';
    }
    return null;
  }
}
