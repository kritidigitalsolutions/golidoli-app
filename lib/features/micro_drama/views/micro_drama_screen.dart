import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/home/widgets/continue_watching_helper.dart';
import 'package:golidoli_app/features/micro_drama/controllers/continue_watching_controller.dart';
import 'package:golidoli_app/features/micro_drama/controllers/micro_drama_controller.dart';
import 'package:golidoli_app/features/micro_drama/models/continue_watching_model.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_model.dart';
import 'package:golidoli_app/features/micro_drama/views/micro_drama_detail_screen.dart';
import 'package:golidoli_app/utils/helpers.dart';
import 'package:golidoli_app/utils/text_style.dart';

class MicroDramaScreen extends StatefulWidget {
  const MicroDramaScreen({super.key});

  @override
  State<MicroDramaScreen> createState() => _MicroDramaScreenState();
}

class _MicroDramaScreenState extends State<MicroDramaScreen> {
  final RxInt selectedCategoryIndex = 0.obs;
  late final MicroDramaController _controller;
  late final ContinueWatchingController _cwController;

  final List<String> categories = [
    'All',
    'Action',
    'Romance',
    'Thriller',
    'Horror',
    'Comedy',
  ];

  List<Microdrama> _filteredDramas(List<Microdrama> allDramas) {
    if (selectedCategoryIndex.value == 0) return allDramas;
    final genre = categories[selectedCategoryIndex.value];
    return allDramas
        .where(
          (d) => d.genre.any(
            (g) => g.toString().toLowerCase() == genre.toLowerCase(),
          ),
        )
        .toList();
  }

  void _onCategorySelected(int index) {
    selectedCategoryIndex.value = index;
  }

  void _onDramaTap(Microdrama drama) {
    Get.to(
      () => MicroDramaDetailScreen(id: drama.id),
    )?.then((_) => _cwController.fetchContinueWatching());
  }

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<MicroDramaController>()
        ? Get.find<MicroDramaController>()
        : Get.put(MicroDramaController());
    _cwController = Get.isRegistered<ContinueWatchingController>()
        ? Get.find<ContinueWatchingController>()
        : Get.put(ContinueWatchingController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchAllMicroDrama();
      _cwController.fetchContinueWatching();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopBar()),
            SliverToBoxAdapter(child: _buildCategoryTabs()),
            // SliverToBoxAdapter(child: _buildHeroBannerSection()),
            SliverToBoxAdapter(child: _buildContinueWatchingSection()),
            SliverToBoxAdapter(child: _buildDramaGridSection()),
            SliverToBoxAdapter(child: _buildExploreMore()),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
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
                  color: AppColors.borderColor.withValues(alpha: 0.4),
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
          return Obx(() {
            final isSelected = selectedCategoryIndex.value == i;

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
                        : AppColors.borderColor.withValues(alpha: 0.4),
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
          });
        },
      ),
    );
  }

  // ── Hero banner section ────────────────────────────────────────────────────
  Widget _buildHeroBannerSection() {
    return Obx(() {
      final allDramas = _controller.allMicroDrama.value?.microdramas ?? [];
      if (allDramas.isEmpty) return const SizedBox.shrink();
      final heroDrama = allDramas.first;
      return _buildHeroBanner(heroDrama);
    });
  }

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
                  child: const Center(
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
                      AppColors.backgroundColor.withValues(alpha: 0.92),
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
                    Text(
                      drama.title,
                      style: text20(fontWeight: FontWeight.bold),
                    ),
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

  // ── Continue Watching section ──────────────────────────────────────────────
  Widget _buildContinueWatchingSection() {
    return Obx(() {
      final list = _cwController.continueWatchingList;
      if (list.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.accentColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Continue Watching',
                  style: text15(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${list.length} ${list.length == 1 ? 'Drama' : 'Dramas'}',
                  style: text12(color: AppColors.secondaryTextColor),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 175,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _buildContinueWatchingCard(list[i]),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildContinueWatchingCard(ContinueWatchingItem item) {
    final posterUrl = formatMediaUrl(item.displayPoster);
    final title = item.displayTitle;
    final epNum = item.displayEpisodeNumber;
    final epTitle = item.displayEpisodeTitle;
    final progress = item.progressRatio;
    final percentage = item.progressPercentage;

    return GestureDetector(
      onTap: () {
        ContinueWatchingHelper.playDirectly(
          context,
          item,
          onFinished: () => _cwController.fetchContinueWatching(),
        );
      },
      child: SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with progress bar & play icon
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  posterUrl.isNotEmpty
                      ? Image.network(
                          posterUrl,
                          height: 105,
                          width: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _fallbackThumbnail(),
                        )
                      : _fallbackThumbnail(),

                  // Dark gradient at bottom
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
                            Colors.black.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Center Play Icon
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.accentColor.withValues(alpha: 0.85),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),

                  // Episode badge (bottom left)
                  if (epNum != null)
                    Positioned(
                      left: 7,
                      bottom: 8,
                      child: Text(
                        'Ep $epNum',
                        style: text10(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  // Percentage badge (bottom right)
                  Positioned(
                    right: 7,
                    bottom: 8,
                    child: Text(
                      '$percentage%',
                      style: text10(
                        color: AppColors.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Progress bar at very bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.accentColor,
                      ),
                      minHeight: 3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Card Bottom Row: Left has Title & Subtitle, Right has 3-dots icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: text11(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (epTitle.isNotEmpty)
                        Text(
                          epTitle,
                          style: text10(color: AppColors.secondaryTextColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    ContinueWatchingHelper.showOptionsBottomSheet(
                      context,
                      item,
                      onDelete: () => _cwController.deleteItem(item),
                      onPlay: () => ContinueWatchingHelper.playDirectly(
                        context,
                        item,
                        onFinished: () => _cwController.fetchContinueWatching(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackThumbnail() {
    return Container(
      height: 105,
      width: 140,
      color: AppColors.cardColor,
      child: const Center(
        child: Icon(
          Icons.movie_outlined,
          color: AppColors.hintTextColor,
          size: 28,
        ),
      ),
    );
  }

  // ── Drama grid section ─────────────────────────────────────────────────────
  Widget _buildDramaGridSection() {
    return Obx(() {
      if (_controller.allMicroDramaStatus.value == Status.loading) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(color: AppColors.accentColor),
          ),
        );
      }

      final allDramas = _controller.allMicroDrama.value?.microdramas ?? [];
      if (allDramas.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'No micro dramas found',
              style: text13(color: AppColors.secondaryTextColor),
            ),
          ),
        );
      }

      final dramas = _filteredDramas(allDramas);
      return _buildDramaGrid(dramas);
    });
  }

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
    final bannerUrl = formatMediaUrl(drama.banner);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (_) => MicroDramaDetailScreen(id: drama.id),
              ),
            )
            .then((_) => _cwController.fetchContinueWatching());
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              bannerUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppColors.cardColor,
                child: const Center(
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
                      AppColors.backgroundColor.withValues(alpha: 0.9),
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
            border: Border.all(
              color: AppColors.borderColor.withValues(alpha: 0.4),
            ),
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
