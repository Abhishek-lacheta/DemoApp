import '../models/crypto_asset.dart';

class MockData {
  MockData._();

  static List<double> _generateSparkline(double base, {int points = 24}) {
    final prices = <double>[];
    var price = base * 0.92;
    for (var i = 0; i < points; i++) {
      price += base * 0.003 * (i % 3 == 0 ? -1 : 1);
      prices.add(price);
    }
    prices.add(base);
    return prices;
  }

  static List<CryptoAsset> get fallbackAssets => [
        CryptoAsset(
          id: 'bitcoin',
          symbol: 'BTC',
          name: 'Bitcoin',
          imageUrl:
              'https://assets.coingecko.com/coins/images/1/small/bitcoin.png',
          currentPrice: 67500.42,
          priceChangePercent24h: 2.34,
          sparklinePrices: _generateSparkline(67500.42),
        ),
        CryptoAsset(
          id: 'ethereum',
          symbol: 'ETH',
          name: 'Ethereum',
          imageUrl:
              'https://assets.coingecko.com/coins/images/279/small/ethereum.png',
          currentPrice: 3520.18,
          priceChangePercent24h: 1.87,
          sparklinePrices: _generateSparkline(3520.18),
        ),
        CryptoAsset(
          id: 'solana',
          symbol: 'SOL',
          name: 'Solana',
          imageUrl:
              'https://assets.coingecko.com/coins/images/4128/small/solana.png',
          currentPrice: 168.55,
          priceChangePercent24h: 4.12,
          sparklinePrices: _generateSparkline(168.55),
        ),
        CryptoAsset(
          id: 'binancecoin',
          symbol: 'BNB',
          name: 'BNB',
          imageUrl:
              'https://assets.coingecko.com/coins/images/825/small/bnb-icon2_2x.png',
          currentPrice: 612.30,
          priceChangePercent24h: -0.45,
          sparklinePrices: _generateSparkline(612.30),
        ),
        CryptoAsset(
          id: 'ripple',
          symbol: 'XRP',
          name: 'XRP',
          imageUrl:
              'https://assets.coingecko.com/coins/images/44/small/xrp-symbol-white-128.png',
          currentPrice: 0.62,
          priceChangePercent24h: -1.23,
          sparklinePrices: _generateSparkline(0.62),
        ),
        CryptoAsset(
          id: 'cardano',
          symbol: 'ADA',
          name: 'Cardano',
          imageUrl:
              'https://assets.coingecko.com/coins/images/975/small/cardano.png',
          currentPrice: 0.58,
          priceChangePercent24h: 0.92,
          sparklinePrices: _generateSparkline(0.58),
        ),
        CryptoAsset(
          id: 'dogecoin',
          symbol: 'DOGE',
          name: 'Dogecoin',
          imageUrl:
              'https://assets.coingecko.com/coins/images/5/small/dogecoin.png',
          currentPrice: 0.16,
          priceChangePercent24h: 3.45,
          sparklinePrices: _generateSparkline(0.16),
        ),
        CryptoAsset(
          id: 'polkadot',
          symbol: 'DOT',
          name: 'Polkadot',
          imageUrl:
              'https://assets.coingecko.com/coins/images/12171/small/polkadot.png',
          currentPrice: 7.82,
          priceChangePercent24h: -2.11,
          sparklinePrices: _generateSparkline(7.82),
        ),
        CryptoAsset(
          id: 'avalanche-2',
          symbol: 'AVAX',
          name: 'Avalanche',
          imageUrl:
              'https://assets.coingecko.com/coins/images/12559/small/Avalanche_Circle_RedWhite_Trans.png',
          currentPrice: 38.45,
          priceChangePercent24h: 1.56,
          sparklinePrices: _generateSparkline(38.45),
        ),
        CryptoAsset(
          id: 'chainlink',
          symbol: 'LINK',
          name: 'Chainlink',
          imageUrl:
              'https://assets.coingecko.com/coins/images/877/small/chainlink-new-logo.png',
          currentPrice: 15.20,
          priceChangePercent24h: -0.88,
          sparklinePrices: _generateSparkline(15.20),
        ),
      ];
}
