import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:week_28/features/google_auth/presentation/bloc/auth_bloc.dart';
import '../../../../helpers/fixtures.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockSignInWithGoogle mockSignInWithGoogle;
  late MockGetCurrentUser mockGetCurrentUser;
  late MockSignOut mockSignOut;

  setUp(() {
    mockSignInWithGoogle = MockSignInWithGoogle();
    mockGetCurrentUser = MockGetCurrentUser();
    mockSignOut = MockSignOut();
    authBloc = AuthBloc(
      signInWithGoogle: mockSignInWithGoogle,
      getCurrentUser: mockGetCurrentUser,
      signOut: mockSignOut,
    );
  });

  group('Initial State', () {
    test('is AuthInitial', () {
      expect(authBloc.state, AuthInitial());
    });
  });

  group('AuthSignInWithGoogle', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess(tUser)] when successful',
      build: () {
        when(() => mockSignInWithGoogle()).thenAnswer((_) async => tUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthSignInWithGoogle()),
      expect: () => [AuthLoading(), const AuthSuccess(tUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when unsuccessful',
      build: () {
        when(() => mockSignInWithGoogle()).thenThrow(Exception('Failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthSignInWithGoogle()),
      expect: () => [AuthLoading(), const AuthFailure('Exception: Failed')],
    );
  });

  group('AuthCheckStatus', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess(tUser)] when user is present',
      build: () {
        when(() => mockGetCurrentUser()).thenAnswer((_) async => tUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckStatus()),
      expect: () => [AuthLoading(), const AuthSuccess(tUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when user is null',
      build: () {
        when(() => mockGetCurrentUser()).thenAnswer((_) async => null);
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckStatus()),
      expect: () => [AuthLoading(), AuthUnauthenticated()],
    );
  });

  group('AuthSignOut', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when successful',
      build: () {
        when(() => mockSignOut()).thenAnswer((_) async => {});
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthSignOut()),
      expect: () => [AuthLoading(), AuthUnauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when unsuccessful',
      build: () {
        when(() => mockSignOut()).thenThrow(Exception('Failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthSignOut()),
      expect: () => [AuthLoading(), const AuthFailure('Exception: Failed')],
    );
  });
}
