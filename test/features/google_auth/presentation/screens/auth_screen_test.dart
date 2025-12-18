import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:week_28/features/google_auth/presentation/bloc/auth_bloc.dart';
import 'package:week_28/features/google_auth/presentation/screens/auth_screen.dart';
import 'package:week_28/features/google_auth/presentation/widgets/auth_screen_body/auth_screen_body.dart';
import 'package:week_28/features/google_auth/presentation/widgets/login_button/login_button.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const AuthScreen(),
      ),
    );
  }

  testWidgets('AuthScreen renders AuthScreenBody when state is AuthInitial', (
    tester,
  ) async {
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(AuthScreenBody), findsOneWidget);
    expect(find.byType(LoginButton), findsOneWidget);
  });

  testWidgets('tapping login button adds AuthSignInWithGoogle event', (
    tester,
  ) async {
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byType(LoginButton));
    await tester.pump();

    verify(() => mockAuthBloc.add(AuthSignInWithGoogle())).called(1);
  });
}
