import 'package:flutter_test/flutter_test.dart';
import 'package:caiacosmetics_9/app/app_shell.dart';

void main() {
  testWidgets('App shell builds', (tester) async {
    await tester.pumpWidget(const AppShell());
    expect(find.text('CAIA Cosmetics'), findsNothing);
  });
}
