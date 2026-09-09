import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/crypto_repository.dart';
import '../services/crypto_api_service.dart';

final cryptoApiServiceProvider = Provider<CryptoApiService>((ref) {
  final service = CryptoApiService();
  ref.onDispose(service.dispose);
  return service;
});

final cryptoRepositoryProvider = Provider<CryptoRepository>((ref) {
  return CryptoRepository(apiService: ref.watch(cryptoApiServiceProvider));
});

final searchQueryProvider = StateProvider<String>((ref) => '');
