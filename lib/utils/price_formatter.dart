import 'package:intl/intl.dart';

class PriceFormatter {
  PriceFormatter._();

  static final _compact = NumberFormat.compactCurrency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final _standard = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static String formatPrice(double price) {
    if (price >= 1000) {
      return _compact.format(price);
    }
    if (price >= 1) {
      return _standard.format(price);
    }
    if (price >= 0.01) {
      return '\$${price.toStringAsFixed(4)}';
    }
    return '\$${price.toStringAsFixed(8)}';
  }

  static String formatPercent(double percent) {
    final sign = percent >= 0 ? '+' : '';
    return '$sign${percent.toStringAsFixed(2)}%';
  }
}
