import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:week_28/features/google_auth/presentation/bloc/auth_bloc.dart';
import 'package:week_28/features/home_screen/presentation/screens/home_screen.dart';
import 'package:week_28/features/home_screen/presentation/widgets/home_logout_button.dart';
import 'package:week_28/features/home_screen/presentation/widgets/home_screen_body.dart';
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
        child: const HomeScreen(),
      ),
    );
  }

  testWidgets('HomeScreen renders HomeScreenBody', (tester) async {
    when(() => mockAuthBloc.state).thenReturn(AuthSuccess());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(HomeScreenBody), findsOneWidget);
    expect(find.text('Welcome Home!'), findsOneWidget);
  });

  testWidgets('tapping logout button shows confirmation dialog', (
    tester,
  ) async {
    when(() => mockAuthBloc.state).thenReturn(AuthSuccess());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byType(HomeLogoutButton));
    await tester.pump(); // Frame for dialog

    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('Are you sure you want to log out?'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);
  });

  testWidgets('tapping Confirm in dialog adds AuthSignOut event', (
    tester,
  ) async {
    when(() => mockAuthBloc.state).thenReturn(AuthSuccess());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byType(HomeLogoutButton));
    await tester.pump();

    await tester.tap(find.text('Confirm'));
    await tester.pump();

    verify(() => mockAuthBloc.add(AuthSignOut())).called(1);
  });
}
