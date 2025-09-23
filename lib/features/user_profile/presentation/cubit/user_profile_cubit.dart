import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sagar_chat_demo/features/user_profile/presentation/cubit/user_profile_state.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;

  UserProfileCubit(
      this._getUserProfileUseCase,
      this._updateUserProfileUseCase,

      ) : super(UserProfileInitial());

  Future<void> fetchUserProfile(String userId) async {
    try {
      emit(UserProfileLoading());
      final userProfile = await _getUserProfileUseCase.call(userId);
      emit(UserProfileLoaded(userProfile));
    } catch (e) {
      emit(UserProfileError('Failed to load user profile: $e'));
    }
  }

  Future<void> updateProfile({
    required String userId,
    required String displayName,
  }) async {
    try {
      emit(UserProfileUpdating());
      await _updateUserProfileUseCase.call(
        userId: userId,
        displayName: displayName,
      );
      final updatedProfile = await _getUserProfileUseCase.call(userId);
      emit(UserProfileLoaded(updatedProfile));
      emit(UserProfileSuccess('Profile updated successfully!'));
    } catch (e) {
      emit(UserProfileError('Failed to update profile: $e'));
      // Reload the profile to show the correct state
      fetchUserProfile(userId);
    }
  }

}
