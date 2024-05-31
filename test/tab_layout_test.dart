import 'package:dish_dispatch/root_navigation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Tab bar layout', (WidgetTester tester) async {
    await tester.pumpWidget(const RootNavigation());
    expect(find.text("Restaurants"), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
  });
}
