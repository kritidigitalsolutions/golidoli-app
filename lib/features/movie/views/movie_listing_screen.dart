import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/movie/controllers/movie_controller.dart';
import 'package:golidoli_app/features/movie/models/MovieModel.dart';
import 'package:golidoli_app/features/movie/views/movie_details_screen.dart';
import 'package:golidoli_app/utils/text_style.dart';

class MovieListingScreen extends StatefulWidget {
  const MovieListingScreen({super.key});

  @override
  State<MovieListingScreen> createState() => _MovieListingScreenState();
}

class _MovieListingScreenState extends State<MovieListingScreen> {
  int selectedCategoryIndex = 0;
  late final MovieController _controller;
  final List<String> categories = [
    'All',
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Sci-Fi',
    'Romance',
    'Thriller',
  ];

  @override
  void initState() {
    super.initState();
    _controller = Get.find<MovieController>();
    _controller.fetchAllMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              _buildCategoryTabs(),
              const SizedBox(height: 12),
              Expanded(child: _buildGrid()),
              _buildExploreMore(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text('Movie', style: text18(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final isSelected = selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategoryIndex =
                    index; // 🔹 sirf index update — filtering build() me apply hogi
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accentColor
                    : AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected
                      ? AppColors.accentColor
                      : AppColors.borderColor.withOpacity(0.4),
                ),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: text12(
                    color: isSelected
                        ? AppColors.black
                        : AppColors.secondaryTextColor,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 🔹 Filtering logic — genre list ke andar case-insensitive match
  List<MovieModel> _filterMovies(List<MovieModel> movies) {
    final selectedCategory = categories[selectedCategoryIndex];
    if (selectedCategory == 'All') return movies;

    return movies.where((movie) {
      return movie.genre.any(
        (g) => g.toLowerCase() == selectedCategory.toLowerCase(),
      );
    }).toList();
  }

  Widget _buildGrid() {
    final status = _controller.allMoviesStatus.value;
    // Handle loading state
    if (status == Status.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accentColor),
      );
    }

    // Handle error state
    if (status == Status.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppColors.errorColor,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'Failed to load movies',
              style: text14(color: AppColors.secondaryTextColor),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _controller.fetchAllMovies();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentColor,
                foregroundColor: AppColors.black,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // 🔹 Apply filter on top of the full list
    final movies = _filterMovies(_controller.allMovies.toList());

    // Handle empty state
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_outlined,
              color: AppColors.hintTextColor,
              size: 64,
            ),
            const SizedBox(height: 12),
            Text(
              'No movies found',
              style: text16(color: AppColors.secondaryTextColor),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (_, index) => _buildCard(movies[index]),
    );
  }

  Widget _buildCard(MovieModel movie) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(id: movie.id),
          ),
        );
        _controller.fetchMovieDetail(movie.id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              "${AppUrl.baseUrl}${movie.poster}",
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppColors.cardColor,
                child: Center(
                  child: Icon(
                    Icons.movie_outlined,
                    color: AppColors.hintTextColor,
                    size: 32,
                  ),
                ),
              ),
            ),
            // Premium badge
            if (movie.isPremium)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'PREMIUM',
                    style: text8(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            // Coming soon badge
            if (movie.isComingSoon)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Coming Soon',
                    style: text8(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            // Gradient overlay and info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.backgroundColor.withOpacity(0.9),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: text10(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 10,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            movie.rating.toString(),
                            style: text8(color: AppColors.white),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 1,
                            height: 8,
                            color: AppColors.secondaryTextColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            movie.releaseYear.toString(),
                            style: text8(color: AppColors.secondaryTextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreMore() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: GestureDetector(
        onTap: () {
          // Load more movies
          // context.read<MovieBloc>().add(const MovieEvent.loadMore());
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderColor.withOpacity(0.4)),
          ),
          child: Center(
            child: Text(
              'Explore More',
              style: text13(color: AppColors.secondaryTextColor),
            ),
          ),
        ),
      ),
    );
  }
}

// Add text style helper for small text
TextStyle text8({Color? color, FontWeight? fontWeight}) {
  return TextStyle(
    fontSize: 8,
    color: color ?? AppColors.white,
    fontWeight: fontWeight ?? FontWeight.normal,
  );
}
