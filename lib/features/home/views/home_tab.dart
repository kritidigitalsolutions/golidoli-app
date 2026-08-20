import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/core/services/firebase_service.dart';
import 'package:golidoli_app/features/home/controllers/home_controller.dart';
import 'package:golidoli_app/features/home/models/category_model.dart';
import 'package:golidoli_app/features/home/models/home_banner_model.dart';
import 'package:golidoli_app/features/micro_drama/views/micro_drama_detail_screen.dart';
import 'package:golidoli_app/features/movie/controllers/movie_controller.dart';
import 'package:golidoli_app/features/movie/models/MovieModel.dart';
import 'package:golidoli_app/features/movie/views/movie_details_screen.dart';
import 'package:golidoli_app/features/web_series/controllers/series_controller.dart';
import 'package:golidoli_app/features/web_series/model/SeriesModel.dart';
import 'package:golidoli_app/features/web_series/views/web_series_detail_screen.dart';
import 'package:golidoli_app/routes/app_routes.dart';
import 'package:golidoli_app/shared/widgets/custom_button.dart';
import 'package:golidoli_app/utils/helpers.dart';
import 'package:golidoli_app/utils/text_style.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _currentBannerIndex = 0;
  int _selectedTabIndex = 0; // 0 = For You, 1 = Movies, 2 = Web Series

  final List<String> _tabLabels = [
    'For You',
    'Movies',
    'Web Series',
  ];

  // ─── GetX Controllers ────────────────────────────────────────────────────
  final HomeController _homeController = Get.put(HomeController());
  final MovieController _movieController = Get.put(MovieController());
  final SeriesController _seriesController = Get.put(SeriesController());

  @override
  void initState() {
    super.initState();
    _movieController.fetchAllMovies();
    _seriesController.fetchAllSeries();
    _homeController.fetchHomeBanners();
    _homeController.fetchCategories();
  }

  void _onTabTapped(int index) {
    setState(() => _selectedTabIndex = index);
  }

  // ─── Navigation helper ──────────────────────────────────────────────────
  void _navigateToDetail(String id, {String type = 'movie'}) {
    if (type == 'movie') {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => MovieDetailsScreen(id: id)));
    } else {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => WebSeriesDetailScreen(id: id)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildSearchBar()),
          SliverToBoxAdapter(child: _buildHeroBanner()),
          SliverToBoxAdapter(child: _buildAudioStoriesBanner()),
          SliverToBoxAdapter(child: _buildTabRow()),
          SliverToBoxAdapter(child: _buildContentForSelectedTab()),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  // ─── Content selection ──────────────────────────────────────────────────
  Widget _buildContentForSelectedTab() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildForYouContent();
      case 1:
        return _buildMoviesContent();
      case 2:
        return _buildSeriesContent();
      default:
        return _buildForYouContent();
    }
  }

  // ─── 1. "For You" Tab Content ───────────────────────────────────────────
  // Shows only: Continue Watching, Popular Movies, Top Web Series
  Widget _buildForYouContent() {
    return Obx(() {
      final isMoviesLoading =
          _movieController.allMoviesStatus.value == Status.loading;
      final isSeriesLoading =
          _seriesController.allSeriesStatus.value == Status.loading;

      if (isMoviesLoading && isSeriesLoading) {
        return const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      // Popular Movies
      List<MovieModel> popularMovies =
          _movieController.allMovies.where((m) => m.isPopular).toList();
      if (popularMovies.isEmpty) {
        popularMovies = List<MovieModel>.from(_movieController.allMovies)
          ..sort((a, b) => b.rating.compareTo(a.rating));
      }

      // Top Web Series
      final allSeries = _seriesController.allSeries.value?.series ?? [];
      List<Series> topSeries = allSeries.where((s) => s.isTop).toList();
      if (topSeries.isEmpty) {
        topSeries = List<Series>.from(allSeries)
          ..sort((a, b) => b.rating.compareTo(a.rating));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContinueWatchingSection(),
          if (popularMovies.isNotEmpty)
            _buildMediaSection(
              title: 'Popular Movies',
              items: popularMovies.map((m) => _toMap(m, 'movie')).toList(),
              onViewAll: () => Get.toNamed(AppRoutes.movieListing),
            ),
          if (topSeries.isNotEmpty)
            _buildMediaSection(
              title: 'Top Web Series',
              items: topSeries.map((s) => _toMap(s, 'series')).toList(),
              onViewAll: () => Get.toNamed(AppRoutes.webSeries),
            ),
        ],
      );
    });
  }

  // ─── 2. "Movies" Tab Content ────────────────────────────────────────────
  // Shows: Continue Watching + Priority <= 10 Category sections
  Widget _buildMoviesContent() {
    return Obx(() {
      final isMoviesLoading =
          _movieController.allMoviesStatus.value == Status.loading;
      final isCatsLoading = _homeController.isCategoriesLoading.value;

      if (isMoviesLoading && isCatsLoading) {
        return const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final allMovies = _movieController.allMovies;
      final topCategories = _homeController.categories;

      final List<Widget> categorySections = [];
      for (final cat in topCategories) {
        final matchedMovies =
            allMovies.where((m) => _matchesMovieCategory(m, cat)).toList();

        if (matchedMovies.isNotEmpty) {
          categorySections.add(
            _buildMediaSection(
              title: cat.name,
              items: matchedMovies.map((m) => _toMap(m, 'movie')).toList(),
              onViewAll: () => Get.toNamed(AppRoutes.movieListing),
            ),
          );
        }
      }

      // If no categories matched, show all movies
      if (categorySections.isEmpty && allMovies.isNotEmpty) {
        categorySections.add(
          _buildMediaSection(
            title: 'All Movies',
            items: allMovies.map((m) => _toMap(m, 'movie')).toList(),
            onViewAll: () => Get.toNamed(AppRoutes.movieListing),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContinueWatchingSection(),
          ...categorySections,
        ],
      );
    });
  }

  // ─── 3. "Web Series" Tab Content ────────────────────────────────────────
  // Shows: Continue Watching + Priority <= 10 Category sections
  Widget _buildSeriesContent() {
    return Obx(() {
      final isSeriesLoading =
          _seriesController.allSeriesStatus.value == Status.loading;
      final isCatsLoading = _homeController.isCategoriesLoading.value;

      if (isSeriesLoading && isCatsLoading) {
        return const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final allSeries = _seriesController.allSeries.value?.series ?? [];
      final topCategories = _homeController.categories;

      final List<Widget> categorySections = [];
      for (final cat in topCategories) {
        final matchedSeries =
            allSeries.where((s) => _matchesSeriesCategory(s, cat)).toList();

        if (matchedSeries.isNotEmpty) {
          categorySections.add(
            _buildMediaSection(
              title: cat.name,
              items: matchedSeries.map((s) => _toMap(s, 'series')).toList(),
              onViewAll: () => Get.toNamed(AppRoutes.webSeries),
            ),
          );
        }
      }

      // If no categories matched, show all series
      if (categorySections.isEmpty && allSeries.isNotEmpty) {
        categorySections.add(
          _buildMediaSection(
            title: 'All Web Series',
            items: allSeries.map((s) => _toMap(s, 'series')).toList(),
            onViewAll: () => Get.toNamed(AppRoutes.webSeries),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContinueWatchingSection(),
          ...categorySections,
        ],
      );
    });
  }

  // ─── Category Match Helpers ─────────────────────────────────────────────
  bool _matchesMovieCategory(MovieModel movie, CategoryModel category) {
    for (final c in movie.category) {
      if (c == category.id || c == category.slug || c == category.name) {
        return true;
      }
      if (c is Map) {
        if (c['_id'] == category.id ||
            c['name'] == category.name ||
            c['slug'] == category.slug) {
          return true;
        }
      }
    }
    for (final g in movie.genre) {
      if (g.toLowerCase() == category.name.toLowerCase() ||
          g.toLowerCase() == category.slug.toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  bool _matchesSeriesCategory(Series series, CategoryModel category) {
    for (final c in series.category) {
      if (c == category.id || c == category.slug || c == category.name) {
        return true;
      }
      if (c is Map) {
        if (c['_id'] == category.id ||
            c['name'] == category.name ||
            c['slug'] == category.slug) {
          return true;
        }
      }
    }
    for (final g in series.genre) {
      if (g.toLowerCase() == category.name.toLowerCase() ||
          g.toLowerCase() == category.slug.toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  // ─── Continue Watching Section ──────────────────────────────────────────
  Widget _buildContinueWatchingSection() {
    final list = _homeController.continueWatching;
    if (list.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Continue Watching',
                style: text16(fontWeight: FontWeight.bold),
              ),
              CustomTextButton(
                title: "View All",
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = list[index];
                final progress = (item['progress'] as num?)?.toDouble() ?? 0.0;
                final imageUrl = formatMediaUrl(item['image']?.toString());

                return GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    width: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              Image.network(
                                imageUrl,
                                width: 140,
                                height: 85,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  width: 140,
                                  height: 85,
                                  color: AppColors.cardColor,
                                  child: const Center(
                                    child: Icon(
                                      Icons.play_circle_outline,
                                      color: AppColors.hintTextColor,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.white24,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    AppColors.accentColor,
                                  ),
                                  minHeight: 3,
                                ),
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['title'] ?? '',
                          style: text12(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item['episode'] != null)
                          Text(
                            item['episode'] ?? '',
                            style: text10(color: AppColors.hintTextColor),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helper to convert MovieModel / Series to Map with type ──────────
  Map<String, dynamic> _toMap(dynamic item, String type) {
    if (item is MovieModel) {
      return {
        'id': item.id,
        'title': item.title,
        'image': item.poster,
        'type': type,
      };
    } else if (item is Series) {
      return {
        'id': item.id,
        'title': item.title,
        'image': item.poster,
        'type': type,
      };
    }
    return {};
  }

  // ─── Generic Media Section (Movies / Series) ──────────────────────────
  Widget _buildMediaSection({
    required String title,
    required List<Map<String, dynamic>> items,
    required VoidCallback onViewAll,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: text16(fontWeight: FontWeight.bold)),
              CustomTextButton(title: "View All", onTap: onViewAll),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final item = items[i];
                final type = item['type'] ?? 'movie';
                return _buildContentCard(
                  title: item['title'] ?? '',
                  imageUrl: item['image'] ?? '',
                  onTap: () => _navigateToDetail(item['id'], type: type),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── Universal Content Card ────────────────────────────────────────────
  Widget _buildContentCard({
    required String title,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    final processedUrl = formatMediaUrl(imageUrl);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  processedUrl,
                  width: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: AppColors.cardColor,
                    child: const Center(
                      child: Icon(
                        Icons.movie,
                        color: AppColors.hintTextColor,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: text10(fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Tab Row ──────────────────────────────────────────────────────────
  Widget _buildTabRow() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabLabels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final label = _tabLabels[i];
          final selected = _selectedTabIndex == i;
          return GestureDetector(
            onTap: () => _onTabTapped(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.accentColor
                    : AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: selected
                      ? AppColors.accentColor
                      : AppColors.borderColor.withOpacity(0.4),
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: text12(
                    color: selected
                        ? AppColors.black
                        : AppColors.secondaryTextColor,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Header ─────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Good Evening',
                          style: text14(color: AppColors.secondaryTextColor),
                        ),
                        const SizedBox(width: 4),
                        const Text('👋', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.microDrama);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.accentColor.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text('🎬', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        'Enjoy Micro Dramas',
                        style: text10(
                          color: AppColors.accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'What do you want\nto watch today?',
                  style: text20(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  Obx(() {
                    final unreadCount = Get.isRegistered<NotificationService>()
                        ? Get.find<NotificationService>().unreadCount.value
                        : 0;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.borderColor,
                          child: CustomIconButton(
                            color: AppColors.white,
                            icon: Icons.notifications_none_rounded,
                            onPressed: () {
                              Get.toNamed(AppRoutes.notifications);
                            },
                          ),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.accentColor,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Center(
                                child: Text(
                                  unreadCount > 99 ? '99+' : '$unreadCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.editProfile);
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.cardColor,
                      backgroundImage: NetworkImage(
                        'https://picsum.photos/seed/avatar/100/100',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Search Bar ─────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(Icons.search, color: AppColors.hintTextColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: AbsorbPointer(
                  child: TextField(
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
              ),
              const Icon(
                Icons.mic_none_rounded,
                color: AppColors.hintTextColor,
                size: 20,
              ),
              const SizedBox(width: 14),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Hero Banner ────────────────────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Obx(() {
      final List<dynamic> banners = _homeController.banners.isNotEmpty
          ? _homeController.banners
          : [];

      if (banners.isEmpty) return const SizedBox.shrink();

      final int activeIndex = _currentBannerIndex >= banners.length
          ? 0
          : _currentBannerIndex;

      return Column(
        children: [
          CarouselSlider.builder(
            itemCount: banners.length,
            itemBuilder: (context, index, realIndex) {
              final bannerItem = banners[index];
              String title = '';
              String imageUrl = '';
              VoidCallback? onBannerTap;

              if (bannerItem is HomeBannerItem) {
                title = bannerItem.title ?? bannerItem.content?.title ?? '';
                imageUrl = formatMediaUrl(
                  bannerItem.banner ??
                      bannerItem.content?.banner ??
                      bannerItem.content?.poster ??
                      '',
                );
                final contentId = bannerItem.content?.id ?? '';
                final type =
                    (bannerItem.contentType ?? bannerItem.content?.type ?? '')
                        .toLowerCase();

                onBannerTap = () {
                  if (contentId.isEmpty) return;
                  if (type == 'movie') {
                    Get.to(() => MovieDetailsScreen(id: contentId));
                  } else if (type == 'series' ||
                      type == 'web_series' ||
                      type == 'webseries') {
                    Get.to(() => WebSeriesDetailScreen(id: contentId));
                  } else if (type == 'microdrama' ||
                      type == 'micro_drama' ||
                      type == 'micro-drama') {
                    Get.to(() => MicroDramaDetailScreen(id: contentId));
                  }
                };
              } else if (bannerItem is Map<String, dynamic>) {
                title = bannerItem['title'] ?? '';
                imageUrl = formatMediaUrl(bannerItem['image'] ?? '');
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: onBannerTap,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        if (imageUrl.isNotEmpty)
                          Image.network(
                            imageUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              height: 180,
                              color: AppColors.cardColor,
                              child: const Center(
                                child: Icon(
                                  Icons.movie,
                                  color: AppColors.hintTextColor,
                                  size: 40,
                                ),
                              ),
                            ),
                          )
                        else
                          Container(
                            height: 180,
                            color: AppColors.cardColor,
                            child: const Center(
                              child: Icon(
                                Icons.movie,
                                color: AppColors.hintTextColor,
                                size: 40,
                              ),
                            ),
                          ),
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.backgroundColor.withOpacity(0.85),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: text16(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: onBannerTap,
                                child: Container(
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
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Watch Now',
                                        style: text12(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
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
            },
            options: CarouselOptions(
              height: 180,
              viewportFraction: 0.92,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayCurve: Curves.easeInOut,
              autoPlayAnimationDuration: const Duration(milliseconds: 700),
              onPageChanged: (index, reason) {
                setState(() => _currentBannerIndex = index);
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(banners.length, (index) {
              final isActive = activeIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.accentColor
                      : AppColors.borderColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      );
    });
  }

  // ─── Audio Stories Banner ──────────────────────────────────────────────
  Widget _buildAudioStoriesBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.audioStories),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF0564),
                Color(0xFFFF6B35),
                AppColors.buttonColor,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Text('🎧', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                'Enjoy Audio Stories',
                style: text13(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.black,
                  size: 14,
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
