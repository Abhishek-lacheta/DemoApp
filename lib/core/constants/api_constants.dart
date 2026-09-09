class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.coingecko.com/api/v3';
  static const String marketsEndpoint =
      '$baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=30&page=1&sparkline=true';

  static const Duration liveUpdateInterval = Duration(seconds: 5);
  static const Duration requestTimeout = Duration(seconds: 15);
}
