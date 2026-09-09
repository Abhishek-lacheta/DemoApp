import '../models/crypto_asset.dart';
import '../services/crypto_api_service.dart';
import '../utils/mock_data.dart';

class CryptoRepository {
  CryptoRepository({CryptoApiService? apiService})
      : _apiService = apiService ?? CryptoApiService();

  final CryptoApiService _apiService;

  Future<({List<CryptoAsset> assets, bool isFromMock})> fetchAssets() async {
    try {
      final assets = await _apiService.fetchMarkets();
      if (assets.isEmpty) {
        return (assets: MockData.fallbackAssets, isFromMock: true);
      }
      return (assets: assets, isFromMock: false);
    } catch (_) {
      return (assets: MockData.fallbackAssets, isFromMock: true);
    }
  }
}
