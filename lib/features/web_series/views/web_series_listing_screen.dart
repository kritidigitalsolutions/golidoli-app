import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/web_series/controllers/series_controller.dart';
import 'package:golidoli_app/features/web_series/model/SeriesModel.dart';
import 'package:golidoli_app/features/web_series/views/web_series_detail_screen.dart';
import 'package:golidoli_app/utils/text_style.dart';

class WebSeriesListingScreen extends StatefulWidget {
  const WebSeriesListingScreen({super.key});

  @override
  State<WebSeriesListingScreen> createState() => _WebSeriesListingScreenState();
}

class _WebSeriesListingScreenState extends State<WebSeriesListingScreen> {
  int selectedCategoryIndex = 0;
  late final SeriesController _controller;
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
    _controller = Get.find<SeriesController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchAllSeries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          final status = _controller.allSeriesStatus.value;

          if (status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (status == Status.error) {
            return const Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final allSeries = _controller.allSeries.value?.series ?? [];
          final filteredSeries = _filterSeries(allSeries);

          return Column(
            children: [
              _buildTopBar(),
              _buildCategoryTabs(),
              const SizedBox(height: 12),
              Expanded(child: _buildGrid(filteredSeries)),
              _buildExploreMore(),
              const SizedBox(height: 16),
            ],
          );
        }),
      ),
    );
  }

  List<Series> _filterSeries(List<Series> series) {
    final selectedCategory = categories[selectedCategoryIndex];
    if (selectedCategory == 'All') return series;

    return series.where((item) {
      return item.genre.any(
        (g) => g.toLowerCase() == selectedCategory.toLowerCase(),
      );
    }).toList();
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text('Web Series', style: text18(fontWeight: FontWeight.bold)),
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
                selectedCategoryIndex = index;
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

  Widget _buildGrid(List<Series> series) {
    if (series.isEmpty) {
      return const Center(
        child: Text("No Series Found", style: TextStyle(color: Colors.white)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: series.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (_, i) => _buildCard(series[i]),
    );
  }

  Widget _buildCard(Series item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WebSeriesDetailScreen(id: item.id),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              "${AppUrl.baseUrl}${item.poster}",
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppColors.cardColor,
                child: Center(
                  child: Icon(
                    Icons.movie_outlined,
                    color: AppColors.hintTextColor,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: text12(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
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
        onTap: () {},
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
