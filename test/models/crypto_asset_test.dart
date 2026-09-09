import 'package:crypto_trader/models/crypto_asset.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CryptoAsset', () {
    test('fromJson parses market response fields', () {
      final json = {
        'id': 'bitcoin',
        'symbol': 'btc',
        'name': 'Bitcoin',
        'image': 'https://example.com/btc.png',
        'current_price': 50000.5,
        'price_change_percentage_24h': 2.5,
        'sparkline_in_7d': {
          'price': [1.0, 2.0, 3.0],
        },
      };

      final asset = CryptoAsset.fromJson(json);

      expect(asset.id, 'bitcoin');
      expect(asset.symbol, 'BTC');
      expect(asset.name, 'Bitcoin');
      expect(asset.currentPrice, 50000.5);
      expect(asset.priceChangePercent24h, 2.5);
      expect(asset.sparklinePrices, [1.0, 2.0, 3.0]);
      expect(asset.isPositive, isTrue);
    });

    test('copyWith updates price fields', () {
      const asset = CryptoAsset(
        id: 'eth',
        symbol: 'ETH',
        name: 'Ethereum',
        imageUrl: '',
        currentPrice: 3000,
        priceChangePercent24h: -1.2,
        sparklinePrices: [],
      );

      final updated = asset.copyWith(currentPrice: 3100);

      expect(updated.currentPrice, 3100);
      expect(updated.priceChangePercent24h, -1.2);
      expect(updated.isPositive, isFalse);
    });
  });
}
