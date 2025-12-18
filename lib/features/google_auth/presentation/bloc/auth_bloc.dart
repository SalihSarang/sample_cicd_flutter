import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:week_28/features/google_auth/domain/usecases/sign_in_with_google.dart';
import 'package:week_28/features/google_auth/domain/usecases/get_current_user.dart';
import 'package:week_28/features/google_auth/domain/usecases/sign_out.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle _signInWithGoogle;
  final GetCurrentUser _getCurrentUser;
  final SignOut _signOut;

  AuthBloc({
    required SignInWithGoogle signInWithGoogle,
    required GetCurrentUser getCurrentUser,
    required SignOut signOut,
  }) : _signInWithGoogle = signInWithGoogle,
       _getCurrentUser = getCurrentUser,
       _signOut = signOut,
       super(AuthInitial()) {
    on<AuthSignInWithGoogle>(_onSignInWithGoogle);
    on<AuthCheckStatus>(_onAuthCheckStatus);
    on<AuthSignOut>(_onSignOut);
  }

  Future<void> _onSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // ... (existing helper methods)

  Future<void> _onAuthCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _getCurrentUser();
      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSignInWithGoogle(
    AuthSignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _signInWithGoogle();

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
