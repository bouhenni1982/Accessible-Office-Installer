// This is a basic Flutter widget test.
import 'package:flutter_test/flutter_test.dart';

import 'package:accessible_office_installer/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AccessibleOfficeInstallerApp());

    // Verify that the app's title or main structure is built
    expect(find.text('Accessible Office Installer'), findsWidgets);
  });
}
