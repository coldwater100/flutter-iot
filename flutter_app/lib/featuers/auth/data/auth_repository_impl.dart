import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';
import 'user_model.dart';
import 'auth_remote_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource remoteSource;

  AuthRepositoryImpl(this.remoteSource);

  @override
  Future<bool> login(String email, String password) async {
    // TODO: 실제 API 호출
    return remoteSource.login(email, password);
  }

  @override
  Future<bool> qrLogin(String qrCode) async {
    // TODO: 실제 API 호출
    return remoteSource.qrLogin(qrCode);
  }

  @override
  Future<bool> signup(UserEntity user) {
    final model = UserModel(
      email: user.email,
      password: user.password,
      qrCode: user.qrCode,
      plantType: user.plantType,
    );
    return remoteSource.signup(model);
  }
}
