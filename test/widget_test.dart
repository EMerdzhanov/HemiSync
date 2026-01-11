import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hemissync/app.dart';

void main() {
  testWidgets('HemiSync app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: HemiSyncApp(),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('HemiSync'), findsOneWidget);
  });
}
