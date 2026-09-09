import 'package:crypto_trader/utils/price_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PriceFormatter', () {
    test('formatPrice handles large values', () {
      expect(PriceFormatter.formatPrice(67500), contains('\$'));
    });

    test('formatPercent includes sign for positive', () {
      expect(PriceFormatter.formatPercent(2.34), '+2.34%');
    });

    test('formatPercent handles negative', () {
      expect(PriceFormatter.formatPercent(-1.5), '-1.50%');
    });
  });
}
