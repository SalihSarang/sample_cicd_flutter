part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthSignInWithGoogle extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}

class AuthSignOut extends AuthEvent {}
