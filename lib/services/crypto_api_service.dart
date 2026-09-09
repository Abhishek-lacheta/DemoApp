import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../core/errors/app_exception.dart';
import '../models/crypto_asset.dart';

class CryptoApiService {
  CryptoApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<CryptoAsset>> fetchMarkets() async {
    try {
      final response = await _client
          .get(Uri.parse(ApiConstants.marketsEndpoint))
          .timeout(ApiConstants.requestTimeout);

      if (response.statusCode != 200) {
        throw AppException(
          'Failed to load markets (${response.statusCode})',
          statusCode: response.statusCode,
        );
      }

      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data
          .map((e) => CryptoAsset.fromJson(e as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Network error: ${e.toString()}');
    }
  }

  void dispose() => _client.close();
}
