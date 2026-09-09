import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../models/assets_state.dart';
import '../models/crypto_asset.dart';
import '../repositories/crypto_repository.dart';
import '../utils/price_simulator.dart';
import 'providers.dart';

class LiveAssetsState {
  const LiveAssetsState({
    this.status = AssetsStatus.initial,
    this.assetsById = const {},
    this.orderedIds = const [],
    this.errorMessage,
    this.isFromMock = false,
  });

  final AssetsStatus status;
  final Map<String, CryptoAsset> assetsById;
  final List<String> orderedIds;
  final String? errorMessage;
  final bool isFromMock;

  String? get heroAssetId {
    if (assetsById.isEmpty) return null;
    var topId = orderedIds.first;
    var topChange = assetsById[topId]?.priceChangePercent24h ?? double.negativeInfinity;
    for (final id in orderedIds) {
      final change = assetsById[id]?.priceChangePercent24h ?? double.negativeInfinity;
      if (change > topChange) {
        topChange = change;
        topId = id;
      }
    }
    return topId;
  }
}

class AssetsController extends StateNotifier<LiveAssetsState> {
  AssetsController(this._repository) : super(const LiveAssetsState());

  final CryptoRepository _repository;
  Timer? _liveTimer;

  Future<void> loadAssets() async {
    state = LiveAssetsState(
      status: AssetsStatus.loading,
      assetsById: state.assetsById,
      orderedIds: state.orderedIds,
      isFromMock: state.isFromMock,
    );

    try {
      final result = await _repository.fetchAssets();
      if (result.assets.isEmpty) {
        state = const LiveAssetsState(
          status: AssetsStatus.error,
          errorMessage: 'No market data available. Please try again.',
        );
        return;
      }

      final assetsById = {for (final a in result.assets) a.id: a};
      final orderedIds = result.assets.map((a) => a.id).toList();

      state = LiveAssetsState(
        status: AssetsStatus.success,
        assetsById: assetsById,
        orderedIds: orderedIds,
        isFromMock: result.isFromMock,
        errorMessage: result.isFromMock
            ? 'Using offline demo data'
            : null,
      );

      _startLiveUpdates();
    } catch (e) {
      state = LiveAssetsState(
        status: AssetsStatus.error,
        errorMessage: 'Failed to load markets. Check your connection.',
      );
    }
  }

  Future<void> refresh() => loadAssets();

  void _startLiveUpdates() {
    _liveTimer?.cancel();
    _liveTimer = Timer.periodic(ApiConstants.liveUpdateInterval, (_) {
      _applyLiveTick();
    });
  }

  void _applyLiveTick() {
    if (state.status != AssetsStatus.success || state.assetsById.isEmpty) {
      return;
    }

    final nextMap = Map<String, CryptoAsset>.from(state.assetsById);
    for (final id in state.orderedIds) {
      final asset = nextMap[id];
      if (asset != null) {
        nextMap[id] = PriceSimulator.applyRandomMovement(asset);
      }
    }

    state = LiveAssetsState(
      status: state.status,
      assetsById: nextMap,
      orderedIds: state.orderedIds,
      errorMessage: state.errorMessage,
      isFromMock: state.isFromMock,
    );
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    super.dispose();
  }
}

final assetsControllerProvider =
    StateNotifierProvider<AssetsController, LiveAssetsState>((ref) {
  final controller = AssetsController(ref.watch(cryptoRepositoryProvider));
  ref.onDispose(controller.dispose);
  return controller;
});

final cryptoAssetProvider = Provider.family<CryptoAsset?, String>((ref, id) {
  return ref.watch(
    assetsControllerProvider.select((s) => s.assetsById[id]),
  );
});

final heroAssetProvider = Provider<CryptoAsset?>((ref) {
  final heroId = ref.watch(
    assetsControllerProvider.select((s) => s.heroAssetId),
  );
  if (heroId == null) return null;
  return ref.watch(cryptoAssetProvider(heroId));
});

final visibleAssetIdsProvider = Provider<List<String>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final orderedIds = ref.watch(
    assetsControllerProvider.select((s) => s.orderedIds),
  );
  final assetsById = ref.watch(
    assetsControllerProvider.select((s) => s.assetsById),
  );

  if (query.isEmpty) return orderedIds;

  return orderedIds.where((id) {
    final asset = assetsById[id];
    if (asset == null) return false;
    return asset.name.toLowerCase().contains(query) ||
        asset.symbol.toLowerCase().contains(query);
  }).toList();
});

final assetsStatusProvider = Provider<AssetsStatus>((ref) {
  return ref.watch(assetsControllerProvider.select((s) => s.status));
});

final assetsErrorProvider = Provider<String?>((ref) {
  return ref.watch(assetsControllerProvider.select((s) => s.errorMessage));
});

final isMockDataProvider = Provider<bool>((ref) {
  return ref.watch(assetsControllerProvider.select((s) => s.isFromMock));
});
