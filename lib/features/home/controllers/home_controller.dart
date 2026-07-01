import 'package:get/get.dart';


class HomeController extends GetxController {
  final RxInt pageIndex = 0.obs;
  final RxInt currentBannerIndex = 0.obs;
  final RxInt selectedTabIndex = 0.obs;

  RxInt get selectedIndex => pageIndex;

  final List<String> tabs = [
    'For you',
    'Movies',
    'Web Series',
    'Micro Drama',
    'Adult',
    'Action',
  ];

  final List<Map<String, dynamic>> continueWatching = [
    {
      'title': 'Forbidden Love',
      'episode': 'S1 E01',
      'progress': 0.35,
      'image': 'https://picsum.photos/seed/show1/200/300',
    },
    {
      'title': 'Forbidden Love',
      'episode': 'S1 E03',
      'progress': 0.6,
      'image': 'https://picsum.photos/seed/show2/200/300',
    },
    {
      'title': 'Forbidden Love',
      'episode': 'S1 E05',
      'progress': 0.8,
      'image': 'https://picsum.photos/seed/show3/200/300',
    },
    {
      'title': 'Forbidden Love',
      'episode': 'S1 E03',
      'progress': 0.6,
      'image': 'https://picsum.photos/seed/show2/200/300',
    },
    {
      'title': 'Forbidden Love',
      'episode': 'S1 E05',
      'progress': 0.8,
      'image': 'https://picsum.photos/seed/show3/200/300',
    },
  ];

  final List<Map<String, dynamic>> popularMovies = [
    {
      'title': 'The Hour You',
      'image': 'https://picsum.photos/seed/movie1/200/300',
    },
    {
      'title': 'The Hour You',
      'image': 'https://picsum.photos/seed/movie2/200/300',
    },
    {
      'title': 'The Hour You',
      'image': 'https://picsum.photos/seed/movie3/200/300',
    },
    {
      'title': 'The Hour You',
      'image': 'https://picsum.photos/seed/movie1/200/300',
    },
    {
      'title': 'The Hour You',
      'image': 'https://picsum.photos/seed/movie2/200/300',
    },
    {
      'title': 'The Hour You',
      'image': 'https://picsum.photos/seed/movie3/200/300',
    },
  ];

  final List<Map<String, dynamic>> topWebSeries = [
    {'title': 'Squid Game', 'image': 'https://picsum.photos/seed/web1/200/300'},
    {'title': 'Squid Game', 'image': 'https://picsum.photos/seed/web2/200/300'},
    {'title': 'Squid Game', 'image': 'https://picsum.photos/seed/web3/200/300'},
    {'title': 'Squid Game', 'image': 'https://picsum.photos/seed/web1/200/300'},
    {'title': 'Squid Game', 'image': 'https://picsum.photos/seed/web2/200/300'},
    {'title': 'Squid Game', 'image': 'https://picsum.photos/seed/web3/200/300'},
  ];

  void onTabSelected(int index) => selectedTabIndex.value = index;
  void onBannerChanged(int index) => currentBannerIndex.value = index;
  void changePage(int index) => pageIndex.value = index;
  void changeTab(int index) => changePage(index);
}

