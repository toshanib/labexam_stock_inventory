import 'package:flutter_test/flutter_test.dart';
import 'package:lab_exam_stock_inventory/main.dart';

void main() {
  testWidgets('Stock Inventory Manager starts', (WidgetTester tester) async {
    await tester.pumpWidget(const StockInventoryApp());

    expect(find.text('Stock Inventory Manager'), findsOneWidget);
    expect(find.text('Add Stock Item'), findsOneWidget);
  });
}