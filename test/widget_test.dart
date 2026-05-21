import 'package:flutter_test/flutter_test.dart';
import 'package:tontonhub/app.dart';

void main() {
  testWidgets('TontonHub app can render initial screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TontonHubApp());
    await tester.pump();
    expect(find.text('TontonHub'), findsOneWidget);
  });
}
