part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState({
    this.status = RequestStatusEnum.initial,
    this.userModel,
    this.errorMessage,
  });

  final RequestStatusEnum status;
  final UserModel? userModel;
  final String? errorMessage;

  AuthState copyWith({
    RequestStatusEnum? status,
    UserModel? userModel,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      userModel: userModel ?? this.userModel,
      errorMessage: errorMessage ,
    );
  }

  @override
  List<Object?> get props => [status, userModel, errorMessage];
}
