import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:week_28/features/google_auth/domain/usecases/get_current_user.dart';
import 'package:week_28/features/google_auth/domain/usecases/sign_in_with_google.dart';
import 'package:week_28/features/google_auth/domain/usecases/sign_out.dart';
import '../../../../helpers/fixtures.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignInWithGoogle signInWithGoogle;
  late GetCurrentUser getCurrentUser;
  late SignOut signOut;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signInWithGoogle = SignInWithGoogle(mockAuthRepository);
    getCurrentUser = GetCurrentUser(mockAuthRepository);
    signOut = SignOut(mockAuthRepository);
  });

  group('SignInWithGoogle', () {
    test(
      'should return UserEntity when repository call is successful',
      () async {
        when(
          () => mockAuthRepository.signInWithGoogle(),
        ).thenAnswer((_) async => tUser);

        final result = await signInWithGoogle();

        expect(result, tUser);
        verify(() => mockAuthRepository.signInWithGoogle()).called(1);
      },
    );
  });

  group('GetCurrentUser', () {
    test('should return UserEntity when user is logged in', () async {
      when(
        () => mockAuthRepository.getCurrentUser(),
      ).thenAnswer((_) async => tUser);

      final result = await getCurrentUser();

      expect(result, tUser);
      verify(() => mockAuthRepository.getCurrentUser()).called(1);
    });
  });

  group('SignOut', () {
    test('should call signOut on repository', () async {
      when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});

      await signOut();

      verify(() => mockAuthRepository.signOut()).called(1);
    });
  });
}
