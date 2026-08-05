import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/home/bloc/category/category_bloc.dart';
import 'package:golidoli_app/features/home/models/category_model.dart';
import 'package:golidoli_app/features/home/models/category_detail_model.dart';
import 'package:golidoli_app/features/movie/bloc/movie_bloc.dart';
import 'package:golidoli_app/features/movie/models/MovieModel.dart';
import 'package:golidoli_app/features/movie/views/movie_details_screen.dart';
import 'package:golidoli_app/features/web_series/model/SeriesModel.dart';
import 'package:golidoli_app/routes/app_routes.dart';
import 'package:golidoli_app/shared/widgets/custom_button.dart';
import 'package:golidoli_app/utils/text_style.dart';

import '../../web_series/bloc/series_bloc/series_bloc.dart';

// ─── Static banner data ────────────────────────────────────────────────────
const List<Map<String, dynamic>> _heroBanners = [
  {
    'title': 'Chandru Champion',
    'image': 'https://picsum.photos/seed/chandruchampion/700/300',
  },
  {
    'title': 'My Racer Stepbrother',
    'image': 'https://picsum.photos/seed/drama1/700/300',
  },
  {
    'title': 'The True Heiress',
    'image': 'https://picsum.photos/seed/drama3/700/300',
  },
];

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _currentBannerIndex = 0;
  int _selectedTabIndex = 0; // 0 = For You, 1+ = static categories

  final List<String> _tabLabels = [
    'For You',
    'Movies',
    'Web Series',
    'Adult',
    'Action',
  ];

  // ─── Category state ──────────────────────────────────────────────────────
  List<CategoryModel> _allCategories = [];
  List<CategoryModel> _activeCategories = [];
  final Set<String> _categoriesWithContent = {};
  final Set<String> _processedCategories = {};
  final Map<String, CategoryContentResponse> _categoryDetails = {};

  // ─── Movie & Series state ──────────────────────────────────────────────
  bool _moviesFetched = false;
  bool _seriesFetched = false;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(const CategoryEvent.allCategory());
  }

  void _updateActiveCategories() {
    setState(() {
      _activeCategories = _allCategories
          .where((cat) => _categoriesWithContent.contains(cat.id))
          .toList();
    });
  }

  CategoryModel? _getCategoryByName(String name) {
    return _allCategories.firstWhereOrNull((cat) => cat.name == name);
  }

  void _onTabTapped(int index) {
    setState(() => _selectedTabIndex = index);
    final label = _tabLabels[index];

    if (label == 'Movies' && !_moviesFetched) {
      context.read<MovieBloc>().add(const MovieEvent.allMovies());
      setState(() => _moviesFetched = true);
    } else if (label == 'Web Series' && !_seriesFetched) {
      context.read<SeriesBloc>().add(const SeriesEvent.allSeries());
      setState(() => _seriesFetched = true);
    } else if (index > 0 && label != 'Movies' && label != 'Web Series') {
      final category = _getCategoryByName(label);
      if (category != null && !_categoryDetails.containsKey(category.id)) {
        context.read<CategoryBloc>().add(
          CategoryEvent.detailCategory(id: category.id),
        );
      }
    }
  }

  // ─── Navigation helper ──────────────────────────────────────────────────
  void _navigateToDetail(String id, {String type = 'movie'}) {
    // If you have separate screens for movies and series, use this:
    // if (type == 'movie') {
    //   Get.toNamed(AppRoutes.movieDetails, arguments: id);
    // } else {
    //   Get.toNamed(AppRoutes.seriesDetails, arguments: id);
    // }

    // For now, we use a common screen but pass the type as an extra parameter.
    // The MovieDetailsScreen should read the 'type' argument and use the appropriate bloc.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MovieDetailsScreen(
          id: id,
        ),
      ),
    );
    // If you're using GetX, you can also do:
    // Get.toNamed(AppRoutes.movieDetails, arguments: {'id': id, 'type': type});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state.detailCategoryStatus == Status.success &&
              state.categoryDetail != null) {
            final detail = state.categoryDetail!;
            final categoryId = detail.category.id;
            _categoryDetails[categoryId] = detail;

            if (detail.content.isNotEmpty) {
              _categoriesWithContent.add(categoryId);
            }
            _processedCategories.add(categoryId);
            _updateActiveCategories();
          }

          if (state.categoryStatus == Status.success &&
              state.allCategories != null &&
              _allCategories.isEmpty) {
            final allCats =
            state.allCategories!.categories
                .where((cat) => cat.isActive)
                .toList()
              ..sort((a, b) => a.priority.compareTo(b.priority));

            if (allCats.isNotEmpty) {
              _allCategories = allCats;
              for (final cat in _allCategories) {
                context.read<CategoryBloc>().add(
                  CategoryEvent.detailCategory(id: cat.id),
                );
              }
            }
          }
        },
        builder: (context, state) {
          if (state.categoryStatus == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.categoryStatus == Status.error ||
              state.allCategories == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load categories',
                    style: text15(color: AppColors.secondaryTextColor),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CategoryBloc>().add(
                        const CategoryEvent.allCategory(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (_selectedTabIndex >= _tabLabels.length) {
            _selectedTabIndex = 0;
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildSearchBar()),
              SliverToBoxAdapter(child: _buildHeroBanner()),
              SliverToBoxAdapter(child: _buildAudioStoriesBanner()),
              SliverToBoxAdapter(child: _buildTabRow()),
              SliverToBoxAdapter(child: _buildContentForSelectedTab()),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          );
        },
      ),
    );
  }

  // ─── Content selection ──────────────────────────────────────────────────
  Widget _buildContentForSelectedTab() {
    final selectedLabel = _tabLabels[_selectedTabIndex];

    if (selectedLabel == 'For You') {
      return _buildForYouContent();
    }

    if (selectedLabel == 'Movies') {
      return _buildMoviesContent();
    }

    if (selectedLabel == 'Web Series') {
      return _buildSeriesContent();
    }

    final category = _getCategoryByName(selectedLabel);
    if (category == null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'No category found for "$selectedLabel"',
            style: text14(color: AppColors.secondaryTextColor),
          ),
        ),
      );
    }

    return _buildSingleCategoryContent(category);
  }

  // ─── Movies Content ─────────────────────────────────────────────────────
  Widget _buildMoviesContent() {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        if (state.allMoviesStatus == Status.loading) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.allMoviesStatus == Status.error) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Failed to load movies',
                style: text14(color: AppColors.secondaryTextColor),
              ),
            ),
          );
        }
        final movies = state.allMovies ?? [];
        if (movies.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'No movies available',
              style: TextStyle(color: AppColors.white),
            ),
          );
        }

        return _buildMediaSection(
          title: 'Movies',
          items: movies.map((m) => _toMap(m, 'movie')).toList(),
          onViewAll: () {
            Get.toNamed(AppRoutes.movieListing);
          },
        );
      },
    );
  }

  // ─── Web Series Content ─────────────────────────────────────────────────
  Widget _buildSeriesContent() {
    return BlocBuilder<SeriesBloc, SeriesState>(
      builder: (context, state) {
        if (state.allSeriesStatus == Status.loading) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.allSeriesStatus == Status.error) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Failed to load web series',
                style: text14(color: AppColors.secondaryTextColor),
              ),
            ),
          );
        }

        List<Series> series = [];
        if (state.allSeries is SeriesResponse) {
          series = (state.allSeries as SeriesResponse).series;
        } else if (state.allSeries is List<Series>) {
          series = state.allSeries as List<Series>;
        } else if (state.allSeries != null) {
          try {
            series = (state.allSeries as dynamic).series ?? [];
          } catch (_) {
            series = [];
          }
        }

        if (series.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'No web series available',
              style: TextStyle(color: AppColors.white),
            ),
          );
        }

        return _buildMediaSection(
          title: 'Web Series',
          items: series.map((s) => _toMap(s, 'series')).toList(),
          onViewAll: () {
            Get.toNamed(AppRoutes.webSeries);
          },
        );
      },
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

  // ─── "For You" – combined category content ──────────────────────────
  Widget _buildForYouContent() {
    if (_activeCategories.isEmpty) {
      if (_allCategories.isNotEmpty && _processedCategories.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'No content available',
          style: TextStyle(color: AppColors.white),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          ..._activeCategories.map((cat) {
            final detail = _categoryDetails[cat.id];
            if (detail == null) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cat.name, style: text16(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
              );
            }
            if (detail.content.isEmpty) return const SizedBox.shrink();
            return _buildContentSection(
              title: cat.name,
              content: detail.content,
              onViewAll: () {
                // Navigate to full category listing (implement later)
                // Get.toNamed(AppRoutes.categoryDetail, arguments: cat.id);
              },
            );
          }),
        ],
      ),
    );
  }

  // ─── Single category content ──────────────────────────────────────────
  Widget _buildSingleCategoryContent(CategoryModel category) {
    final detail = _categoryDetails[category.id];

    if (detail == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category.name, style: text16(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      );
    }

    if (detail.content.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category.name, style: text16(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'No content available for "${category.name}"',
                style: text13(color: AppColors.secondaryTextColor),
              ),
            ),
          ],
        ),
      );
    }

    return _buildContentSection(
      title: category.name,
      content: detail.content,
      onViewAll: () {
        // Navigate to full category listing (implement later)
        // Get.toNamed(AppRoutes.categoryDetail, arguments: category.id);
      },
    );
  }

  // ─── Content Section for Category (ContentModel) ──────────────────────
  Widget _buildContentSection({
    required String title,
    required List<ContentModel> content,
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
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: content.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final item = content[i];
                return _buildContentCard(
                  title: item.title,
                  imageUrl: item.poster.isNotEmpty ? item.poster : item.banner,
                  onTap: () => _navigateToDetail(item.id, type: 'movie'), // category items are treated as movies
                );
              },
            ),
          ),
        ],
      ),
    );
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
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final item = items[i];
                final type = item['type'] ?? 'movie';
                return _buildContentCard(
                  title: item['title'] ?? '',
                  imageUrl: item['image'] ?? '',
                  onTap: () => _navigateToDetail(
                    item['id'],
                    type: type,
                  ),
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
    String processedUrl = imageUrl;
    if (processedUrl.isEmpty) {
      processedUrl =
      'https://via.placeholder.com/90x135/333333/FFFFFF?text=No+Image';
    } else if (!processedUrl.startsWith('http')) {
      processedUrl = '${AppUrl.baseUrl}$processedUrl';
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  processedUrl,
                  width: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: AppColors.cardColor,
                    child: Center(
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
        separatorBuilder: (_, __) => const SizedBox(width: 8),
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
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.editProfile);
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.cardColor,
                      backgroundImage: const NetworkImage(
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
              Icon(Icons.search, color: AppColors.hintTextColor, size: 20),
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
              Icon(
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
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _heroBanners.length,
          itemBuilder: (context, index, realIndex) {
            final banner = _heroBanners[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.network(
                      banner['image'],
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        height: 180,
                        color: AppColors.cardColor,
                        child: Center(
                          child: Icon(
                            Icons.movie,
                            color: AppColors.hintTextColor,
                            size: 40,
                          ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner['title'],
                            style: text16(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
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
          children: List.generate(_heroBanners.length, (index) {
            final isActive = _currentBannerIndex == index;
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
              Center(
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