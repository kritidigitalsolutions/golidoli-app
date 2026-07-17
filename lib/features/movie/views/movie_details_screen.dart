import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/features/movie/bloc/movie_bloc.dart';
import 'package:golidoli_app/routes/app_routes.dart';
import 'package:golidoli_app/utils/text_style.dart';

import '../../../constants/enums.dart';
import '../models/MovieModel.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({super.key, this.id});
  final String? id;

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool isInWatchlist = false;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      context.read<MovieBloc>().add(
        MovieEvent.movieDetail(value: widget.id!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        // Handle loading state
        if (state.movieDetailStatus == Status.loading) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: const Center(
              child: CircularProgressIndicator(
                color: AppColors.accentColor,
              ),
            ),
          );
        }

        // Handle error state
        if (state.movieDetailStatus == Status.error) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
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
                    'Failed to load movie details',
                    style: text14(color: AppColors.secondaryTextColor),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.id != null) {
                        context.read<MovieBloc>().add(
                          MovieEvent.movieDetail(value: widget.id!),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentColor,
                      foregroundColor: AppColors.black,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final movie = state.movieDetail;
        if (movie == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: const Center(
              child: Text('No movie found'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHero(movie)),
              SliverToBoxAdapter(child: _buildMovieInfo(movie)),
              SliverToBoxAdapter(child: _buildActions(movie)),
              SliverToBoxAdapter(child: _buildMoreLikeThis(state)),
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHero(MovieModel movie) {
    return Stack(
      children: [
        // Backdrop image
        SizedBox(
          height: 240,
          width: double.infinity,
          child: Image.network(
            "${AppUrl.baseUrl}${movie.banner}",
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.cardColor,
              child: const Icon(
                Icons.movie_outlined,
                color: AppColors.hintTextColor,
                size: 48,
              ),
            ),
          ),
        ),
        // Gradient overlay
        Container(
          height: 240,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.backgroundColor,
              ],
            ),
          ),
        ),
        // Top bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.overlayColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle share
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.overlayColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.share_outlined,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Premium badge if applicable
        if (movie.isPremium)
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'PREMIUM',
                style: text10(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        // Coming soon badge if applicable
        if (movie.isComingSoon)
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Coming Soon',
                style: text10(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMovieInfo(MovieModel movie) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie poster
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              "${AppUrl.baseUrl}${movie.poster}",
              width: 90,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 90,
                height: 120,
                color: AppColors.cardColor,
                child: const Icon(
                  Icons.movie_outlined,
                  color: AppColors.hintTextColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: text20(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                // Rating and year
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.ratingColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      movie.rating.toString(),
                      style: text13(
                        color: AppColors.ratingColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 12,
                      color: AppColors.hintTextColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      movie.releaseYear.toString(),
                      style: text12(color: AppColors.hintTextColor),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 12,
                      color: AppColors.hintTextColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      movie.duration,
                      style: text12(color: AppColors.hintTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Genre tags
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: movie.genre
                      .map((genre) => _buildTag(genre))
                      .toList(),
                ),
                const SizedBox(height: 10),
                Text(
                  movie.description,
                  style: text12(color: AppColors.secondaryTextColor),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: text10(color: AppColors.secondaryTextColor),
      ),
    );
  }

  Widget _buildActions(MovieModel movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          // Watch Now + Watchlist row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (movie.videoUrl.isNotEmpty) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.videoPlayer,
                        arguments: movie,
                      );
                    }
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.play_arrow_rounded,
                          color: AppColors.black,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Watch Now',
                          style: text13(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isInWatchlist = !isInWatchlist;
                    });
                    // Add to watchlist logic here
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.borderColor.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isInWatchlist
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_add_outlined,
                          color: isInWatchlist
                              ? AppColors.primaryColor
                              : AppColors.secondaryTextColor,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isInWatchlist ? 'Saved' : '+ Watchlist',
                          style: text13(
                            color: isInWatchlist
                                ? AppColors.primaryColor
                                : AppColors.secondaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Download button
          GestureDetector(
            onTap: () {
              // Handle download
            },
            child: Container(
              height: 44,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.borderColor.withOpacity(0.4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.download_outlined,
                    color: AppColors.secondaryTextColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Download',
                    style: text13(
                      color: AppColors.secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreLikeThis(MovieState state) {
    final movies = state.allMovies;
    // Filter out current movie and get random 6 movies
    final moreLikeThis = movies
        .where((m) => m.id != widget.id)
        .take(6)
        .toList();

    if (moreLikeThis.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'More Like This',
            style: text16(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: moreLikeThis.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (_, index) {
              final movie = moreLikeThis[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to movie detail
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailsScreen(id: movie.id),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "${AppUrl.baseUrl}${movie.poster}",
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.cardColor,
                      child: const Center(
                        child: Icon(
                          Icons.movie_outlined,
                          color: AppColors.hintTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // Navigate to all movies
              Navigator.pop(context);
            },
            child: Center(
              child: Text(
                'Explore More',
                style: text13(
                  color: AppColors.accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}