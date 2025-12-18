import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:week_28/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app starts and shows Auth or Home screen', (
    WidgetTester tester,
  ) async {
    await app.main();
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate((widget) {
        if (widget is Text) {
          final text = widget.data;
          return text == 'Welcome Back' || text == 'Welcome Home!';
        }
        return false;
      }),
      findsOneWidget,
    );
  });
}
