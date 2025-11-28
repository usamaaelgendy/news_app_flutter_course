import 'package:news_app/core/datasource/remote_data/api_config.dart';
import 'package:news_app/core/datasource/remote_data/api_service.dart';

class AuthRepository {
  AuthRepository(this.apiService);

  final ApiService apiService;

  Future<void> login({required String username, required String password}) async {
    final response = await apiService.post(
      ApiConfig.login,
      ApiConfig.authBaseUrl,
      body: {"username": "emilys", "password": "emilyspass", "expiresInMins": 30},
    );

    print(response);
  }
}
