part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.selectedImage,
    this.userName,
    this.countryCode,
    this.countryName,
  });

  final XFile? selectedImage;

  final String? userName;
  final String? countryCode;
  final String? countryName;

  ProfileState copyWith({
    XFile? selectedImage,
    String? userName,
    String? countryCode,
    String? countryName,
  }) {
    return ProfileState(
      selectedImage: selectedImage ?? this.selectedImage,
      userName: userName ?? this.userName,
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
    );
  }

  @override
  List<Object?> get props => [selectedImage, userName, countryCode, countryName];
}
