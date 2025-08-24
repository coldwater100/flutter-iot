import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'featuers/network/data/network_repository.dart';
import 'featuers/network/data/rest_client.dart';
import 'featuers/network/data/ws_client.dart';
import 'featuers/network/domain/network_service.dart';
import '../app_config.dart'; // 환경설정 분리

List<SingleChildWidget> globalProviders = [
  Provider<NetworkService>(
    create: (_) {
      final rest = RestClient(baseUrl: AppConfig.restBaseUrl);
      final ws = WSClient(AppConfig.wsUrl);
      final repo = NetworkRepository(restClient: rest, wsClient: ws);
      return NetworkService(repo);
    },
    dispose: (_, service) => service.repo.disconnect(),
  ),
];
