import '../../domain/entities/profile_entity.dart';

// The state classes for the UserProfileCubit.
// No use of Equatable, as requested.
abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfile userProfile;

  UserProfileLoaded(this.userProfile);
}

class UserProfileUpdating extends UserProfileState {}

class UserProfileUpdatingPhoto extends UserProfileState {}

class UserProfileSuccess extends UserProfileState {
  final String message;
  UserProfileSuccess(this.message);
}

class UserProfileError extends UserProfileState {
  final String message;
  UserProfileError(this.message);
}
