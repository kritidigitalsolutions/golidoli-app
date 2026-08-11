import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/audio_play/views/audio_stories_screen.dart';
import 'package:golidoli_app/features/home/controllers/content_controller.dart';
import 'package:golidoli_app/features/home/models/content_model.dart';
import 'package:golidoli_app/features/home/controllers/discover_controller.dart';
import 'package:golidoli_app/features/micro_drama/views/micro_drama_detail_screen.dart';
import 'package:golidoli_app/features/movie/views/movie_details_screen.dart';
import 'package:golidoli_app/features/web_series/views/web_series_detail_screen.dart';
import 'package:golidoli_app/utils/text_style.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  late final DiscoverController _controller;
  late final ContentController _contentController;
  late final TextEditingController _searchController;
  Timer? _debounce;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = Get.put(DiscoverController());
    _contentController = Get.find<ContentController>();
    _searchController = _controller.searchController;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = val.trim();
      if (query == _currentQuery) return;
      _currentQuery = query;
      _contentController.searchContent(query);
    });
  }

  void _navigateToDetail(HomeContent item) {
    final type = item.type.toLowerCase();
    if (type == 'movie') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MovieDetailsScreen(id: item.id)),
      );
    } else if (type == 'series' ||
        type == 'web-series' ||
        type == 'webseries') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => WebSeriesDetailScreen(id: item.id)),
      );
    } else if (type == 'microdrama' ||
        type == 'micro-drama' ||
        type == 'micro_drama') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MicroDramaDetailScreen(id: item.id)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isSearching = _currentQuery.isNotEmpty;

      return SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSearchBar()),
            if (!isSearching) ...[
              SliverToBoxAdapter(child: _buildCategoryGrid()),
              SliverToBoxAdapter(child: _buildExcitingBanner()),
            ] else ...[
              SliverToBoxAdapter(child: _buildSearchResults()),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        'Discover',
        style: appTextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.accentColor,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderColor.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search, color: AppColors.hintTextColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: text13(color: AppColors.textColor),
                decoration: InputDecoration(
                  hintText: 'Search movies, series & dramas',
                  hintStyle: text13(color: AppColors.hintTextColor),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _currentQuery = '');
                _contentController.searchContent('');
              },
              child: const Icon(
                Icons.close,
                color: AppColors.hintTextColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final status = _contentController.searchContentStatus.value;
    final items = _contentController.searchContents.value?.content ?? [];

    if (status == Status.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (status == Status.error) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'Something went wrong. Try again.',
            style: text14(color: AppColors.secondaryTextColor),
          ),
        ),
      );
    }

    if (items.isEmpty && status == Status.success) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 48,
                color: AppColors.secondaryTextColor,
              ),
              const SizedBox(height: 12),
              Text(
                'No results for "$_currentQuery"',
                style: text14(color: AppColors.secondaryTextColor),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${items.length} result${items.length == 1 ? '' : 's'} for "$_currentQuery"',
            style: text13(color: AppColors.secondaryTextColor),
          ),
          const SizedBox(height: 14),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _buildSearchResultCard(items[i]),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(HomeContent item) {
    final imageUrl = item.poster.isNotEmpty ? item.poster : item.banner;
    final typeLabel = _typeLabel(item.type);
    final typeColor = _typeColor(item.type);

    return GestureDetector(
      onTap: () => _navigateToDetail(item),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            // Poster
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: "${AppUrl.baseUrl}$imageUrl",
                width: 80,
                height: 110,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 110,
                  color: AppColors.surfaceColor,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.hintTextColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Content info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        typeLabel,
                        style: text10(
                          color: typeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Title
                    Text(
                      item.title,
                      style: text14(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Meta row
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.primaryColor,
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: text12(color: AppColors.primaryColor),
                        ),
                        const SizedBox(width: 10),
                        if (item.language.isNotEmpty)
                          Text(
                            item.language,
                            style: text11(color: AppColors.secondaryTextColor),
                          ),
                      ],
                    ),
                    if (item.genre.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.genre.take(2).join(' • '),
                        style: text11(color: AppColors.hintTextColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.secondaryTextColor,
              size: 14,
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'movie':
        return 'MOVIE';
      case 'series':
      case 'web-series':
      case 'webseries':
        return 'WEB SERIES';
      case 'microdrama':
      case 'micro-drama':
      case 'micro_drama':
        return 'MICRO DRAMA';
      default:
        return type.toUpperCase();
    }
  }

  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'movie':
        return AppColors.accentColor;
      case 'series':
      case 'web-series':
      case 'webseries':
        return AppColors.infoColor;
      case 'microdrama':
      case 'micro-drama':
      case 'micro_drama':
        return AppColors.primaryColor;
      default:
        return AppColors.secondaryTextColor;
    }
  }

  // Widget _buildTrendingSearches() {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text('Trending Searches', style: text16(fontWeight: FontWeight.bold)),
  //         const SizedBox(height: 12),
  //         Wrap(
  //           spacing: 8,
  //           runSpacing: 8,
  //           children: _controller.trendingSearches
  //               .map((tag) => _buildTrendingChip(tag))
  //               .toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildTrendingChip(String label) {
  //   return GestureDetector(
  //     onTap: () {
  //       _searchController.text = label;
  //       _onSearchChanged(label);
  //       setState(() => _currentQuery = label);
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
  //       decoration: BoxDecoration(
  //         color: AppColors.surfaceColor,
  //         borderRadius: BorderRadius.circular(20),
  //         border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5)),
  //       ),
  //       child: Text(label, style: text12(color: AppColors.secondaryTextColor)),
  //     ),
  //   );
  // }

  Widget _buildCategoryGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Browse Categories', style: text16(fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _controller.categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (_, i) {
              final cat = _controller.categories[i];
              return _buildCategoryCard(
                cat['label'],
                cat['icon'] as IconData,
                i,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String label, IconData icon, int index) {
    final colors = [
      AppColors.accentColor,
      AppColors.primaryColor,
      AppColors.infoColor,
      AppColors.errorColor,
      AppColors.accentColor,
      AppColors.warningColor,
      AppColors.successColor,
      AppColors.accentColor,
      AppColors.infoColor,
    ];
    final color = colors[index % colors.length];

    return GestureDetector(
      onTap: () => _onCategoryTap(label), // 🔹 dedicated handler
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderColor.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: text11(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 New: category tap ke liye alag, debounce-free handler
  void _onCategoryTap(String query) {
    _debounce?.cancel();
    _searchController.text = query;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    setState(() => _currentQuery = query);
    _contentController.searchContent(query);
  }

  Widget _buildExcitingBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AudioStoriesScreen()),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // 🔹 Icon-based background instead of Image.network
              Container(
                height: 130,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [Color(0xFF2E1A4A), Color(0xFF1A0A2E)],
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.headphones_rounded,
                      color: AppColors.primaryColor.withOpacity(0.3),
                      size: 90,
                    ),
                  ),
                ),
              ),
              Container(
                height: 130,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1A0A2E).withValues(alpha: 0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exciting\nStories for you!',
                      style: text16(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.play_arrow_rounded,
                            color: AppColors.black,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Watch Now',
                            style: text11(
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
