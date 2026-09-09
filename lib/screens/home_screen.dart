import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../models/assets_state.dart';
import '../state/assets_controller.dart';
import '../state/providers.dart';
import '../widgets/crypto_list_item.dart';
import '../widgets/empty_search_view.dart';
import '../widgets/error_retry_view.dart';
import '../widgets/hero_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/market_list_header.dart';
import '../widgets/search_bar_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(assetsControllerProvider.notifier).loadAssets();
    });
  }

  Future<void> _onRefresh() async {
    await ref.read(assetsControllerProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(assetsStatusProvider);
    final isMock = ref.watch(isMockDataProvider);
    final errorMessage = ref.watch(assetsErrorProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAppBar(context),
            if (isMock && status == AssetsStatus.success)
              _buildMockBanner(errorMessage),
            const SearchBarWidget(),
            Expanded(child: _buildBody(status)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
      child: Row(
        children: [
          const Text(
            'Crypto Trader',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMockBanner(String? message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message ?? 'Offline demo data active',
              style: const TextStyle(color: AppColors.primary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(AssetsStatus status) {
    switch (status) {
      case AssetsStatus.initial:
      case AssetsStatus.loading:
        return const LoadingShimmer();
      case AssetsStatus.error:
        return ErrorRetryView(
          message: ref.watch(assetsErrorProvider) ??
              'Something went wrong. Please try again.',
          onRetry: () =>
              ref.read(assetsControllerProvider.notifier).loadAssets(),
        );
      case AssetsStatus.success:
        return _MarketList(onRefresh: _onRefresh);
    }
  }
}

class _MarketList extends ConsumerWidget {
  const _MarketList({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetIds = ref.watch(visibleAssetIdsProvider);
    final hasSearch = ref.watch(searchQueryProvider).trim().isNotEmpty;

    if (assetIds.isEmpty && hasSearch) {
      return const EmptySearchView();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      backgroundColor: AppColors.card,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          const SliverToBoxAdapter(child: HeroCard()),
          const SliverToBoxAdapter(child: MarketListHeader()),
          SliverList.builder(
            itemCount: assetIds.length,
            itemBuilder: (context, index) {
              return CryptoListItem(
                key: ValueKey(assetIds[index]),
                assetId: assetIds[index],
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
