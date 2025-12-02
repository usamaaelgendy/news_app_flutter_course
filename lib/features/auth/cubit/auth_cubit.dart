import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/core/datasource/local_data/preferences_manager.dart';
import 'package:news_app/core/datasource/local_data/user_repository.dart';
import 'package:news_app/core/enums/request_status_enum.dart';
import 'package:news_app/core/models/user_model.dart';
import 'package:news_app/features/auth/repo/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepository) : super(const AuthState());

  AuthRepository authRepository;

  Future<void> login({required String username, required String password}) async {
    try {
      emit(state.copyWith(status: RequestStatusEnum.loading, errorMessage: null));

      final userModel = await authRepository.login(
        username: username,
        password: password,
      );

      if (userModel != null) {
        emit(state.copyWith(status: RequestStatusEnum.loaded, userModel: userModel));
      }
    } catch (e) {
      emit(state.copyWith(status: RequestStatusEnum.error, errorMessage: e.toString()));
    }
  }

  void register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: RequestStatusEnum.loading, errorMessage: null));

    await Future.delayed(const Duration(seconds: 3));

    final String? error = await UserRepository().signUp(
      name: name,
      email: email,
      password: password,
    );

    if (error != null) {
      emit(state.copyWith(errorMessage: error, status: RequestStatusEnum.error));
      return;
    }
    await PreferencesManager().setBool("is_logged_in", true);

    emit(state.copyWith(status: RequestStatusEnum.loaded, errorMessage: null));
  }
}
