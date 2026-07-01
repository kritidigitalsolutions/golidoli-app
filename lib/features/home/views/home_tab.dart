import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/home/controllers/home_controller.dart';
import 'package:golidoli_app/routes/app_routes.dart';
import 'package:golidoli_app/shared/widgets/custom_button.dart';
import 'package:golidoli_app/utils/text_style.dart';

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

class HomeTap extends StatefulWidget {
  const HomeTap({super.key});

  @override
  State<HomeTap> createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> {
  int _currentBannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(controller)),
          SliverToBoxAdapter(child: _buildSearchBar(controller)),
          SliverToBoxAdapter(child: _buildHeroBanner()),
          SliverToBoxAdapter(child: _buildAudioStoriesBanner()),
          SliverToBoxAdapter(child: _buildTabRow(controller)),
          SliverToBoxAdapter(
            child: _buildSection(
              'Continue Watching',
              controller.continueWatching,
              controller,
              isShowViewAll: false,
              onTap: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSection(
              'Popular Movies',
              controller.popularMovies,
              controller,
              showProgress: false,
              onTap: () {
                Get.toNamed(AppRoutes.movieListing);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSection(
              'Top Webseries',
              controller.topWebSeries,
              controller,
              showProgress: false,
              onTap: () {
                Get.toNamed(AppRoutes.webSeries);
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildHeader(HomeController controller) {
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

  Widget _buildSearchBar(HomeController controller) {
    return GestureDetector(
      onTap: () {
        controller.changeTab(3);
      },
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

        // Dot indicators
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
              SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabRow(HomeController controller) {
    return SizedBox(
      height: 38,
      child: Obx(() {
        final selectedTab = controller.selectedTabIndex.value;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.tabs.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final selected = selectedTab == i;
            return GestureDetector(
              onTap: () => controller.onTabSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 3,
                ),
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
                    controller.tabs[i],
                    style: text12(
                      color: selected
                          ? AppColors.black
                          : AppColors.secondaryTextColor,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildSection(
    String title,
    List<Map<String, dynamic>> items,
    HomeController controller, {
    bool showProgress = true,
    bool isShowViewAll = true,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: text16(fontWeight: FontWeight.bold)),
                if (isShowViewAll)
                  CustomTextButton(title: "View All", onTap: onTap),
              ],
            ),
          ),

          SizedBox(
            height: showProgress ? 130 : 150,

            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final item = items[i];
                return _buildMediaCard(item, showProgress: showProgress);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaCard(
    Map<String, dynamic> item, {
    bool showProgress = true,
  }) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.movieDetails);
      },
      child: SizedBox(
        width: 90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Image.network(
                      item['image'],
                      width: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: AppColors.cardColor,
                        child: Center(
                          child: Icon(
                            Icons.movie,
                            color: AppColors.hintTextColor,
                          ),
                        ),
                      ),
                    ),
                    if (showProgress)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          value: item['progress'] ?? 0.5,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.primaryColor,
                          ),
                          minHeight: 3,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              item['title'] ?? '',
              style: text10(fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (item['episode'] != null)
              Text(
                item['episode'],
                style: text9(color: AppColors.hintTextColor),
              ),
          ],
        ),
      ),
    );
  }
}

// Add missing text9 helper (maps to text10 with size 9)
TextStyle text9({
  FontWeight fontWeight = FontWeight.normal,
  Color color = AppColors.textColor,
}) {
  return appTextStyle(fontSize: 9, fontWeight: fontWeight, color: color);
}
