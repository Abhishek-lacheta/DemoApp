import 'dart:math';

import '../models/crypto_asset.dart';

class PriceSimulator {
  PriceSimulator._();

  static final _random = Random();

  static CryptoAsset applyRandomMovement(CryptoAsset asset) {
    final priceDeltaPercent = (_random.nextDouble() * 0.008) - 0.004;
    final newPrice = asset.currentPrice * (1 + priceDeltaPercent);
    final clampedPrice = newPrice.clamp(
      asset.currentPrice * 0.95,
      asset.currentPrice * 1.05,
    );

    final changeDelta = (_random.nextDouble() * 0.4) - 0.2;
    final newChangePercent =
        (asset.priceChangePercent24h + changeDelta).clamp(-15.0, 15.0);

    final updatedSparkline = List<double>.from(asset.sparklinePrices);
    if (updatedSparkline.isNotEmpty) {
      updatedSparkline.removeAt(0);
      updatedSparkline.add(clampedPrice);
    }

    return asset.copyWith(
      currentPrice: clampedPrice,
      priceChangePercent24h: newChangePercent,
      sparklinePrices: updatedSparkline.isEmpty
          ? asset.sparklinePrices
          : updatedSparkline,
    );
  }

  static List<CryptoAsset> updateAll(List<CryptoAsset> assets) {
    return assets.map(applyRandomMovement).toList();
  }
}
