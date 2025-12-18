import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:week_28/features/google_auth/domain/repositories/google_auth_repo.dart';
import 'package:week_28/features/google_auth/domain/usecases/get_current_user.dart';
import 'package:week_28/features/google_auth/domain/usecases/sign_in_with_google.dart';
import 'package:week_28/features/google_auth/domain/usecases/sign_out.dart';
import 'package:week_28/features/google_auth/presentation/bloc/auth_bloc.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

class MockSignOut extends Mock implements SignOut {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}
