import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/core/enums/request_status_enum.dart';
import 'package:news_app/core/models/user_model.dart';
import 'package:news_app/features/auth/repo/auth_reposatory.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepository) : super(const AuthState());

  AuthRepository authRepository;

  Future<void> login({required String username, required String password}) async {

    try{
      emit(state.copyWith(status: RequestStatusEnum.loading, errorMessage: null));

      final userModel = await authRepository.login(username: username, password: password);

      if (userModel != null) {
        emit(state.copyWith(status: RequestStatusEnum.loaded, userModel: userModel));
      }
    }catch(e){
      emit(state.copyWith(status: RequestStatusEnum.error, errorMessage: e.toString()));

    }

  }
}
