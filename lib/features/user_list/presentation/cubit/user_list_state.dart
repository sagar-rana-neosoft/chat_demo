import '../../domain/entities/user_entity.dart';

abstract class UserListState {}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {}

class UserListLoaded extends UserListState {
  final List<UserEntity> users;
  UserListLoaded(this.users);
}

class UserListError extends UserListState {
  final String message;
  UserListError(this.message);
}

class UserListEmpty extends UserListState {}