import 'crypto_asset.dart';

enum AssetsStatus { initial, loading, success, error }

class AssetsState {
  const AssetsState({
    this.status = AssetsStatus.initial,
    this.assets = const [],
    this.errorMessage,
    this.isFromMock = false,
  });

  final AssetsStatus status;
  final List<CryptoAsset> assets;
  final String? errorMessage;
  final bool isFromMock;

  bool get isLoading => status == AssetsStatus.loading;
  bool get isSuccess => status == AssetsStatus.success;
  bool get isError => status == AssetsStatus.error;

  CryptoAsset? get topPerformer {
    if (assets.isEmpty) return null;
    return assets.reduce(
      (a, b) =>
          a.priceChangePercent24h >= b.priceChangePercent24h ? a : b,
    );
  }

  AssetsState copyWith({
    AssetsStatus? status,
    List<CryptoAsset>? assets,
    String? errorMessage,
    bool? isFromMock,
    bool clearError = false,
  }) {
    return AssetsState(
      status: status ?? this.status,
      assets: assets ?? this.assets,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isFromMock: isFromMock ?? this.isFromMock,
    );
  }
}
