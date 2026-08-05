import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/micro_drama/bloc/micro_drama_bloc.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_model.dart';
import 'package:golidoli_app/features/micro_drama/views/micro_drama_detail_screen.dart';
import 'package:golidoli_app/utils/text_style.dart';

class MicroDramaScreen extends StatefulWidget {
  const MicroDramaScreen({super.key});

  @override
  State<MicroDramaScreen> createState() => _MicroDramaScreenState();
}

class _MicroDramaScreenState extends State<MicroDramaScreen> {
  int selectedCategoryIndex = 0;

  final List<String> categories = [
    'All',
    'Action',
    'Romance',
    'Thriller',
    'Horror',
    'Comedy',
  ];

  List<Microdrama> _filteredDramas(List<Microdrama> allDramas) {
    if (selectedCategoryIndex == 0) return allDramas;
    final genre = categories[selectedCategoryIndex];
    return allDramas
        .where(
          (d) => d.genre.any(
            (g) => g.toString().toLowerCase() == genre.toLowerCase(),
      ),
    )
        .toList();
  }

  void _onCategorySelected(int index) {
    setState(() => selectedCategoryIndex = index);
  }

  void _onDramaTap(Microdrama drama) {
    // TODO: navigate to drama detail, e.g.
    // Get.toNamed(AppRoutes.microDramaDetail, arguments: drama);
  }

  @override
  void initState() {
    super.initState();
    context.read<MicroDramaBloc>().add(const MicroDramaEvent.allMicroDrama());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocBuilder<MicroDramaBloc, MicroDramaState>(
          builder: (context, state) {
            if (state.allMicroDramaStatus == Status.loading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentColor,
                ),
              );
            }

            final allDramas = state.allMicroDrama?.microdramas ?? [];

            if (allDramas.isEmpty) {
              return Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: Center(
                      child: Text(
                        'No micro dramas found',
                        style: text13(color: AppColors.secondaryTextColor),
                      ),
                    ),
                  ),
                ],
              );
            }

            final dramas = _filteredDramas(allDramas);
            final heroDrama = allDramas.first;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildTopBar()),
                SliverToBoxAdapter(child: _buildCategoryTabs()),
                SliverToBoxAdapter(child: _buildHeroBanner(heroDrama)),
                SliverToBoxAdapter(child: _buildDramaGrid(dramas)),
                SliverToBoxAdapter(child: _buildExploreMore()),
                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.borderColor.withOpacity(0.4),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text('Micro Dramas', style: text18(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ── Category chips ─────────────────────────────────────────────────────────
  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final isSelected = selectedCategoryIndex == i;
          return GestureDetector(
            onTap: () => _onCategorySelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 3,
              ),
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
                  categories[i],
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

  // ── Hero banner (first drama) ─────────────────────────────────────────────
  Widget _buildHeroBanner(Microdrama drama) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: GestureDetector(
        onTap: () => _onDramaTap(drama),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.network(
                "${AppUrl.baseUrl}${drama.banner}",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 200,
                  color: AppColors.cardColor,
                  child: Center(
                    child: Icon(
                      Icons.movie_outlined,
                      color: AppColors.hintTextColor,
                      size: 40,
                    ),
                  ),
                ),
              ),
              // Gradient overlay
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.backgroundColor.withOpacity(0.92),
                    ],
                  ),
                ),
              ),
              // Title at bottom
              Positioned(
                bottom: 14,
                left: 14,
                right: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(drama.title, style: text20(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      '${drama.totalEpisodes} Episodes',
                      style: text12(color: AppColors.secondaryTextColor),
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

  // ── Drama grid  ────────────────────────────────────────────────────────────
  Widget _buildDramaGrid(List<Microdrama> dramas) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: dramas.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (_, i) => _buildDramaCard(dramas[i]),
      ),
    );
  }

  Widget _buildDramaCard(Microdrama drama) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MicroDramaDetailScreen(id: drama.id),
          ),
        );
      },

      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              "${AppUrl.baseUrl}${drama.poster}",
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
            // Gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
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
              ),
            ),
            // Title
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Text(
                drama.title.toUpperCase(),
                style: text10(fontWeight: FontWeight.bold),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Explore more ──────────────────────────────────────────────────────────
  Widget _buildExploreMore() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderColor.withOpacity(0.4)),
          ),
          child: Center(
            child: Text(
              'Explore More',
              style: text13(
                color: AppColors.secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}