import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/micro_drama/datasource/micro_drama_datasource.dart';
import 'package:golidoli_app/features/micro_drama/models/episode_detail_response.dart';
import 'package:golidoli_app/features/web_series/model/episode_response.dart';
import 'package:golidoli_app/utils/helpers.dart';
import 'package:golidoli_app/utils/text_style.dart';
import 'package:golidoli_app/web/routes/web_routes.dart';
import 'package:golidoli_app/web/utils/web_auth_guard.dart';
import 'package:video_player/video_player.dart';

class WebPlayerScreen extends StatefulWidget {
  const WebPlayerScreen({super.key});

  @override
  State<WebPlayerScreen> createState() => _WebPlayerScreenState();
}

class _WebPlayerScreenState extends State<WebPlayerScreen> {
  final MicroDramaDatasource _dramaDatasource = MicroDramaDatasource();
  final FocusNode _keyboardFocusNode = FocusNode();

  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isMuted = false;
  double _volume = 1.0;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  String _contentId = '';
  String _type = 'movie'; // 'drama', 'movie', 'series'
  String _title = '';
  String _dramaTitle = '';
  String _posterUrl = '';
  String _videoUrl = '';
  String? _errorMessage;

  // Episodes List
  List<MicroDramaEpisode> _dramaEpisodes = [];
  List<Episode> _seriesEpisodes = [];
  int _currentEpisodeIndex = 0;

  // Player Preferences
  bool _autoPlayNext = true;
  bool _showEpisodesDrawer = true;
  bool _isLiked = false;
  bool _isLoadingEpisode = false;

  @override
  void initState() {
    super.initState();
    _extractParamsAndInit();
  }

  Future<void> _extractParamsAndInit() async {
    final args = Get.arguments as Map<String, dynamic>?;
    _contentId = args?['contentId']?.toString() ?? Get.parameters['id'] ?? '';
    _type = (args?['type']?.toString() ?? Get.parameters['type'] ?? 'movie')
        .toLowerCase();
    _title = args?['title']?.toString() ??
        Get.parameters['title'] ??
        'Playing Media';
    _dramaTitle = args?['dramaTitle']?.toString() ?? _title;
    _posterUrl = args?['poster']?.toString() ?? '';
    _videoUrl =
        args?['videoUrl']?.toString() ?? Get.parameters['videoUrl'] ?? '';
    _currentEpisodeIndex = args?['initialEpisodeIndex'] as int? ?? 0;

    if (args?['dramaEpisodes'] is List<MicroDramaEpisode>) {
      _dramaEpisodes = args!['dramaEpisodes'] as List<MicroDramaEpisode>;
    }
    if (args?['seriesEpisodes'] is List<Episode>) {
      _seriesEpisodes = args!['seriesEpisodes'] as List<Episode>;
    }

    final bool isPremium = args?['isPremium'] == true ||
        Get.parameters['isPremium'] == 'true';

    if (isPremium) {
      final isSubscribed = await WebAuthGuard.isSubscribed();
      if (!isSubscribed) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offNamed(WebRoutes.subscription);
            Get.snackbar(
              'VIP Subscription Required',
              'Please subscribe to a VIP plan to watch this content.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.primaryPink.withValues(alpha: 0.9),
              colorText: Colors.white,
            );
          });
        }
        return;
      }
    }

    // If micro drama and episodes list is empty, fetch from API
    if (_type.contains('drama') &&
        _dramaEpisodes.isEmpty &&
        _contentId.isNotEmpty) {
      _fetchDramaEpisodes();
    }

    if (_videoUrl.isNotEmpty) {
      _initPlayer(formatMediaUrl(_videoUrl));
    } else if (_type.contains('drama') && _dramaEpisodes.isNotEmpty) {
      _playEpisode(_currentEpisodeIndex);
    } else {
      setState(() => _errorMessage = 'No video stream URL provided');
    }
  }

  Future<void> _fetchDramaEpisodes() async {
    try {
      final res = await _dramaDatasource.episodeDetail(id: _contentId);
      if (res != null && res.episodes.isNotEmpty && mounted) {
        setState(() {
          _dramaEpisodes = res.episodes;
        });
        if (_videoUrl.isEmpty) {
          _playEpisode(_currentEpisodeIndex);
        }
      }
    } catch (e) {
      debugPrint('Error fetching drama episodes: $e');
    }
  }

  Future<void> _initPlayer(String url) async {
    try {
      setState(() {
        _isLoadingEpisode = true;
        _errorMessage = null;
      });

      _controller?.removeListener(_videoListener);
      _controller?.dispose();

      final uri = Uri.parse(url);
      _controller = VideoPlayerController.networkUrl(uri);

      await _controller!.initialize();
      _controller!.addListener(_videoListener);
      _controller!.setVolume(_isMuted ? 0.0 : _volume);
      await _controller!.play();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isPlaying = true;
          _isLoadingEpisode = false;
          _errorMessage = null;
        });
        _startHideControlsTimer();
        _keyboardFocusNode.requestFocus();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load video: $e';
          _isInitialized = false;
          _isLoadingEpisode = false;
        });
      }
    }
  }

  void _videoListener() {
    if (!mounted || _controller == null || !_isInitialized) return;
    final isPlaying = _controller!.value.isPlaying;
    if (isPlaying != _isPlaying) {
      setState(() => _isPlaying = isPlaying);
    }

    // Auto-advance next episode on completion
    final position = _controller!.value.position;
    final duration = _controller!.value.duration;
    if (duration > Duration.zero &&
        position >= duration - const Duration(milliseconds: 300)) {
      if (_autoPlayNext && !_isLoadingEpisode) {
        if (_hasEpisodeNext()) {
          _playNextEpisode();
        }
      }
    }
  }

  bool _hasEpisodeNext() {
    if (_type.contains('drama')) {
      return _currentEpisodeIndex + 1 < _dramaEpisodes.length;
    } else if (_type.contains('series')) {
      return _currentEpisodeIndex + 1 < _seriesEpisodes.length;
    }
    return false;
  }

  bool _hasEpisodePrev() {
    return _currentEpisodeIndex > 0;
  }

  Future<void> _playEpisode(int index) async {
    if (_type.contains('drama')) {
      if (index < 0 || index >= _dramaEpisodes.length) return;
      final ep = _dramaEpisodes[index];

      // Check premium VIP guard
      if (ep.isPremium || ep.isLocked) {
        final isSubscribed = await WebAuthGuard.isSubscribed();
        if (!isSubscribed) {
          if (mounted) {
            Get.snackbar(
              'VIP Episode',
              'Episode ${ep.episodeNumber} is premium. Please subscribe to continue watching.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.primaryPink.withValues(alpha: 0.9),
              colorText: Colors.white,
            );
            Get.toNamed(WebRoutes.subscription);
          }
          return;
        }
      }

      setState(() {
        _currentEpisodeIndex = index;
        _title = 'Episode ${ep.episodeNumber}: ${ep.title}';
        _videoUrl = ep.videoUrl;
      });
      _initPlayer(formatMediaUrl(ep.videoUrl));
    } else if (_type.contains('series')) {
      if (index < 0 || index >= _seriesEpisodes.length) return;
      final ep = _seriesEpisodes[index];

      setState(() {
        _currentEpisodeIndex = index;
        _title = 'Episode ${ep.episodeNumber}: ${ep.title}';
        _videoUrl = ep.videoUrl;
      });
      _initPlayer(formatMediaUrl(ep.videoUrl));
    }
  }

  void _playNextEpisode() {
    if (_hasEpisodeNext()) {
      _playEpisode(_currentEpisodeIndex + 1);
    } else {
      Get.snackbar(
        'Drama Completed',
        'You have reached the latest episode!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primaryPink.withValues(alpha: 0.85),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _playPreviousEpisode() {
    if (_hasEpisodePrev()) {
      _playEpisode(_currentEpisodeIndex - 1);
    } else {
      Get.snackbar(
        'First Episode',
        'You are already on the first episode.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.surfaceColor,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && _isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  void _onUserInteraction() {
    if (!_showControls) {
      setState(() => _showControls = true);
    }
    _startHideControlsTimer();
  }

  void _togglePlayPause() {
    if (_controller == null || !_isInitialized) return;
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
    _onUserInteraction();
  }

  void _seekRelative(int seconds) {
    if (_controller == null || !_isInitialized) return;
    var newPos = _controller!.value.position + Duration(seconds: seconds);
    final maxDuration = _controller!.value.duration;
    if (newPos < Duration.zero) newPos = Duration.zero;
    if (newPos > maxDuration) newPos = maxDuration;
    _controller!.seekTo(newPos);
    _onUserInteraction();
  }

  void _toggleMute() {
    if (_controller == null || !_isInitialized) return;
    setState(() {
      _isMuted = !_isMuted;
      _controller!.setVolume(_isMuted ? 0.0 : _volume);
    });
    _onUserInteraction();
  }

  void _onVolumeChanged(double val) {
    if (_controller == null || !_isInitialized) return;
    setState(() {
      _volume = val;
      _isMuted = val == 0;
      _controller!.setVolume(val);
    });
    _onUserInteraction();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      final hours = duration.inHours.toString();
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space) {
        _togglePlayPause();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.pageUp) {
        _playPreviousEpisode();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.pageDown) {
        _playNextEpisode();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _seekRelative(10);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _seekRelative(-10);
      } else if (event.logicalKey == LogicalKeyboardKey.keyM) {
        _toggleMute();
      } else if (event.logicalKey == LogicalKeyboardKey.keyE) {
        setState(() => _showEpisodesDrawer = !_showEpisodesDrawer);
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        Get.back();
      }
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDrama = _type.contains('drama');

    return KeyboardListener(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 768;
            return isDrama
                ? _buildMicroDramaPlayerLayout(isMobile, constraints)
                : _buildStandardWidescreenPlayerLayout(isMobile, constraints);
          },
        ),
      ),
    );
  }

  // ─── MICRO DRAMA (VERTICAL 9:16) REEL-STYLE PLAYER ─────────────────────────

  Widget _buildMicroDramaPlayerLayout(
    bool isMobile,
    BoxConstraints constraints,
  ) {
    final formattedPoster = formatMediaUrl(_posterUrl);

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Ambient Blurred Backdrop
        if (formattedPoster.isNotEmpty)
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
              child: CachedNetworkImage(
                imageUrl: formattedPoster,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    Container(color: Colors.black),
              ),
            ),
          ),

        // Dark Vignette Gradient
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Colors.black.withValues(alpha: 0.65),
                  Colors.black.withValues(alpha: 0.95),
                ],
              ),
            ),
          ),
        ),

        // 2. Main Content Area
        SafeArea(
          child: isMobile
              ? _buildMobileMicroDramaLayout(constraints)
              : _buildDesktopMicroDramaLayout(constraints),
        ),
      ],
    );
  }

  // Mobile / Narrow Screen Full-Height Reel Layout (< 768px)
  Widget _buildMobileMicroDramaLayout(BoxConstraints constraints) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Fullscreen Vertical Video Surface
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            color: Colors.black,
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: _buildVerticalVideoSurface(isMobile: true),
            ),
          ),
        ),

        // Top Gradient & Header (Overlay on Video)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _buildMicroDramaTopHeader(isMobile: true),
        ),

        // Mobile Floating Action Rail (Right Side Overlaid on Video)
        Positioned(
          right: 12,
          bottom: 90,
          child: _buildMobileActionRail(),
        ),
      ],
    );
  }

  // Desktop / Tablet Layout (>= 768px)
  Widget _buildDesktopMicroDramaLayout(BoxConstraints constraints) {
    return Column(
      children: [
        // Top Navigation Header
        _buildMicroDramaTopHeader(isMobile: false),

        // Center Stage (Player + Action Rail + Episode Panel)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Center Vertical Video Container
                Flexible(
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 440,
                        maxHeight: constraints.maxHeight * 0.84,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.borderColor.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.8),
                            blurRadius: 30,
                            spreadRadius: 2,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: _buildVerticalVideoSurface(isMobile: false),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),
                _buildSideActionRail(),

                // Collapsible Desktop Episode Sidebar
                if (_showEpisodesDrawer && _dramaEpisodes.isNotEmpty) ...[
                  const SizedBox(width: 20),
                  _buildDesktopEpisodePanel(constraints),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMicroDramaTopHeader({required bool isMobile}) {
    final epCount = _dramaEpisodes.length;
    final currentEpNum = _dramaEpisodes.isNotEmpty &&
            _currentEpisodeIndex < _dramaEpisodes.length
        ? _dramaEpisodes[_currentEpisodeIndex].episodeNumber
        : (_currentEpisodeIndex + 1);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 32,
        vertical: isMobile ? 8 : 12,
      ),
      decoration: isMobile
          ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.85),
                  Colors.transparent,
                ],
              ),
            )
          : null,
      child: Row(
        children: [
          // Back Button
          IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 8),

          // Drama Title & Episode Pill
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _dramaTitle.isNotEmpty ? _dramaTitle : _title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: appTextStyle(
                    fontSize: isMobile ? 14 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.primaryPink.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        'EP $currentEpNum ${epCount > 0 ? '/ $epCount' : ''}',
                        style: const TextStyle(
                          color: AppColors.primaryPink,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (!isMobile) ...[
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: appTextStyle(
                            fontSize: 12,
                            color: AppColors.secondaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Auto-Play Toggle
          InkWell(
            onTap: () {
              setState(() => _autoPlayNext = !_autoPlayNext);
              Get.snackbar(
                'Auto-Play Next Episode',
                _autoPlayNext ? 'Enabled' : 'Disabled',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.surfaceColor,
                colorText: Colors.white,
                duration: const Duration(seconds: 1),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 8 : 12,
                vertical: isMobile ? 5 : 6,
              ),
              decoration: BoxDecoration(
                color: _autoPlayNext
                    ? AppColors.primaryPink.withValues(alpha: 0.2)
                    : Colors.white10,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _autoPlayNext
                      ? AppColors.primaryPink
                      : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _autoPlayNext
                        ? Icons.autorenew_rounded
                        : Icons.pause_circle_outline_rounded,
                    color:
                        _autoPlayNext ? AppColors.primaryPink : Colors.white60,
                    size: 15,
                  ),
                  if (!isMobile) ...[
                    const SizedBox(width: 6),
                    Text(
                      'Auto Next',
                      style: TextStyle(
                        color: _autoPlayNext
                            ? AppColors.primaryPink
                            : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Mobile Episodes Button
          if (isMobile && _dramaEpisodes.isNotEmpty) ...[
            const SizedBox(width: 6),
            IconButton(
              icon: const Icon(
                Icons.format_list_bulleted_rounded,
                color: Colors.white,
                size: 22,
              ),
              onPressed: _openMobileEpisodesModal,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVerticalVideoSurface({required bool isMobile}) {
    return MouseRegion(
      onHover: (_) => _onUserInteraction(),
      child: GestureDetector(
        onTap: _togglePlayPause,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video Stream
            if (_isInitialized && _controller != null)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.size.width > 0
                      ? _controller!.value.size.width
                      : 9,
                  height: _controller!.value.size.height > 0
                      ? _controller!.value.size.height
                      : 16,
                  child: VideoPlayer(_controller!),
                ),
              )
            else if (_errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.primaryPink,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: () => _playEpisode(_currentEpisodeIndex),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPink,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: AppColors.primaryPink),
              ),

            // Loading Indicator during episode transitions
            if (_isLoadingEpisode)
              Container(
                color: Colors.black45,
                child: const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primaryPink),
                ),
              ),

            // Center Play / Pause Animated Overlay
            if (_showControls || !_isPlaying)
              Center(
                child: GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      _isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                ),
              ),

            // Bottom Player Scrubber Overlay
            if (_showControls || !_isPlaying)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 16, 14, 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Scrubber Bar
                      if (_isInitialized && _controller != null)
                        VideoProgressIndicator(
                          _controller!,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            playedColor: AppColors.primaryPink,
                            bufferedColor: Colors.white24,
                            backgroundColor: Colors.white12,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                        ),

                      // Control Buttons Row (Responsive)
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            icon: Icon(
                              Icons.skip_previous_rounded,
                              color: _hasEpisodePrev()
                                  ? Colors.white
                                  : Colors.white24,
                              size: 22,
                            ),
                            tooltip: 'Previous Episode (Up Arrow)',
                            onPressed:
                                _hasEpisodePrev() ? _playPreviousEpisode : null,
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            icon: Icon(
                              _isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                            onPressed: _togglePlayPause,
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            icon: Icon(
                              Icons.skip_next_rounded,
                              color: _hasEpisodeNext()
                                  ? Colors.white
                                  : Colors.white24,
                              size: 22,
                            ),
                            tooltip: 'Next Episode (Down Arrow)',
                            onPressed:
                                _hasEpisodeNext() ? _playNextEpisode : null,
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            icon: Icon(
                              _isMuted || _volume == 0
                                  ? Icons.volume_off_rounded
                                  : Icons.volume_up_rounded,
                              color: Colors.white,
                              size: 19,
                            ),
                            onPressed: _toggleMute,
                          ),
                          const Spacer(),
                          if (_isInitialized && _controller != null)
                            ValueListenableBuilder(
                              valueListenable: _controller!,
                              builder: (context, VideoPlayerValue val, _) {
                                return Text(
                                  '${_formatDuration(val.position)} / ${_formatDuration(val.duration)}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideActionRail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRailButton(
          icon: Icons.keyboard_arrow_up_rounded,
          label: 'Prev',
          onTap: _hasEpisodePrev() ? _playPreviousEpisode : null,
          enabled: _hasEpisodePrev(),
        ),
        const SizedBox(height: 14),
        _buildRailButton(
          icon: Icons.keyboard_arrow_down_rounded,
          label: 'Next',
          onTap: _hasEpisodeNext() ? _playNextEpisode : null,
          enabled: _hasEpisodeNext(),
        ),
        const SizedBox(height: 14),
        _buildRailButton(
          icon: _isLiked
              ? Icons.favorite_rounded
              : Icons.favorite_outline_rounded,
          label: 'Like',
          color: _isLiked ? AppColors.primaryPink : Colors.white,
          onTap: () {
            setState(() => _isLiked = !_isLiked);
            if (_contentId.isNotEmpty) {
              _dramaDatasource.toggleLike(_contentId);
            }
          },
        ),
        const SizedBox(height: 14),
        if (_dramaEpisodes.isNotEmpty)
          _buildRailButton(
            icon: Icons.format_list_bulleted_rounded,
            label: 'Episodes',
            isActive: _showEpisodesDrawer,
            onTap: () =>
                setState(() => _showEpisodesDrawer = !_showEpisodesDrawer),
          ),
      ],
    );
  }

  Widget _buildMobileActionRail() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMobileFloatingButton(
          icon: Icons.keyboard_arrow_up_rounded,
          onTap: _hasEpisodePrev() ? _playPreviousEpisode : null,
          enabled: _hasEpisodePrev(),
        ),
        const SizedBox(height: 12),
        _buildMobileFloatingButton(
          icon: Icons.keyboard_arrow_down_rounded,
          onTap: _hasEpisodeNext() ? _playNextEpisode : null,
          enabled: _hasEpisodeNext(),
        ),
        const SizedBox(height: 12),
        _buildMobileFloatingButton(
          icon: _isLiked
              ? Icons.favorite_rounded
              : Icons.favorite_outline_rounded,
          color: _isLiked ? AppColors.primaryPink : Colors.white,
          onTap: () {
            setState(() => _isLiked = !_isLiked);
            if (_contentId.isNotEmpty) {
              _dramaDatasource.toggleLike(_contentId);
            }
          },
        ),
      ],
    );
  }

  Widget _buildMobileFloatingButton({
    required IconData icon,
    VoidCallback? onTap,
    Color color = Colors.white,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: enabled ? color : Colors.white24,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildRailButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    Color color = Colors.white,
    bool enabled = true,
    bool isActive = false,
  }) {
    final effectiveColor =
        enabled ? (isActive ? AppColors.primaryPink : color) : Colors.white24;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryPink.withValues(alpha: 0.25)
                    : AppColors.surfaceColor.withValues(alpha: 0.8),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive
                      ? AppColors.primaryPink
                      : Colors.white.withValues(alpha: 0.15),
                ),
              ),
              child: Icon(icon, color: effectiveColor, size: 24),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: effectiveColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopEpisodePanel(BoxConstraints constraints) {
    return Container(
      width: 300,
      height: constraints.maxHeight * 0.84,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All Episodes',
                      style: text16(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_dramaEpisodes.length} Episodes Total',
                      style: text12(color: AppColors.secondaryTextColor),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.secondaryTextColor,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _showEpisodesDrawer = false),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white12),

          // Scrollable Episode Grid / List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _dramaEpisodes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final ep = _dramaEpisodes[index];
                final isCurrent = index == _currentEpisodeIndex;

                return InkWell(
                  onTap: () => _playEpisode(index),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.primaryPink.withValues(alpha: 0.2)
                          : AppColors.surfaceColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isCurrent
                            ? AppColors.primaryPink
                            : AppColors.borderColor.withValues(alpha: 0.3),
                        width: isCurrent ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? AppColors.primaryPink
                                : Colors.white10,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: isCurrent && _isPlaying
                                ? const Icon(
                                    Icons.graphic_eq_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  )
                                : Text(
                                    '${ep.episodeNumber}',
                                    style: TextStyle(
                                      color: isCurrent
                                          ? Colors.white
                                          : Colors.white70,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ep.title.isNotEmpty
                                    ? ep.title
                                    : 'Episode ${ep.episodeNumber}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isCurrent
                                      ? AppColors.primaryPink
                                      : Colors.white,
                                  fontWeight: isCurrent
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: 12.5,
                                ),
                              ),
                              if (ep.duration.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  ep.duration,
                                  style: text11(
                                    color: AppColors.secondaryTextColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (ep.isPremium || ep.isLocked)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37)
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.lock_rounded,
                                  color: Color(0xFFD4AF37),
                                  size: 11,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  'VIP',
                                  style: TextStyle(
                                    color: Color(0xFFD4AF37),
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
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
            ),
          ),
        ],
      ),
    );
  }

  void _openMobileEpisodesModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(18),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Episodes (${_dramaEpisodes.length})',
                    style: text18(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.secondaryTextColor,
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _dramaEpisodes.length,
                  itemBuilder: (context, index) {
                    final ep = _dramaEpisodes[index];
                    final isCurrent = index == _currentEpisodeIndex;

                    return InkWell(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        _playEpisode(index);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? AppColors.primaryPink
                              : AppColors.surfaceColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isCurrent
                                ? AppColors.primaryPink
                                : AppColors.borderColor.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${ep.episodeNumber}',
                            style: TextStyle(
                              color: isCurrent
                                  ? Colors.white
                                  : AppColors.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── STANDARD WIDESCREEN CINEMA PLAYER (FOR MOVIES & SERIES) ───────────────

  Widget _buildStandardWidescreenPlayerLayout(
    bool isMobile,
    BoxConstraints constraints,
  ) {
    return MouseRegion(
      onHover: (_) => _onUserInteraction(),
      child: GestureDetector(
        onTap: _togglePlayPause,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Video Player Surface
            if (_isInitialized && _controller != null)
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              )
            else if (_errorMessage != null)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.primaryPink,
                      size: 46,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          _initPlayer(formatMediaUrl(_videoUrl)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPink,
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            else
              const Center(
                child:
                    CircularProgressIndicator(color: AppColors.primaryPink),
              ),

            // 2. Overlay Controls
            if (_showControls || !_isPlaying) ...[
              // Top Gradient Bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 24,
                    vertical: isMobile ? 10 : 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.85),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 14 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Center Play / Pause Icon
              Center(
                child: GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      _isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ),
              ),

              // Bottom Gradient Bar (Fully Responsive)
              if (_isInitialized && _controller != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      isMobile ? 12 : 24,
                      16,
                      isMobile ? 12 : 24,
                      isMobile ? 10 : 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.9),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        VideoProgressIndicator(
                          _controller!,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            playedColor: AppColors.primaryPink,
                            bufferedColor: Colors.white24,
                            backgroundColor: Colors.white10,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                        ),
                        Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              icon: Icon(
                                _isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: _togglePlayPause,
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              icon: const Icon(
                                Icons.replay_10_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () => _seekRelative(-10),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              icon: const Icon(
                                Icons.forward_10_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () => _seekRelative(10),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              icon: Icon(
                                _isMuted || _volume == 0
                                    ? Icons.volume_off_rounded
                                    : Icons.volume_up_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _toggleMute,
                            ),
                            if (!isMobile) ...[
                              const SizedBox(width: 4),
                              SizedBox(
                                width: 80,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: AppColors.primaryPink,
                                    inactiveTrackColor: Colors.white24,
                                    thumbColor: Colors.white,
                                    trackHeight: 2.5,
                                    thumbShape:
                                        const RoundSliderThumbShape(
                                      enabledThumbRadius: 5.0,
                                    ),
                                  ),
                                  child: Slider(
                                    value: _isMuted ? 0.0 : _volume,
                                    min: 0.0,
                                    max: 1.0,
                                    onChanged: _onVolumeChanged,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(width: 8),
                            ValueListenableBuilder(
                              valueListenable: _controller!,
                              builder: (context, VideoPlayerValue val, _) {
                                return Text(
                                  '${_formatDuration(val.position)} / ${_formatDuration(val.duration)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ),
                            const Spacer(),
                            if (!isMobile)
                              const Text(
                                'Press ESC to exit',
                                style: TextStyle(
                                  color: AppColors.secondaryTextColor,
                                  fontSize: 11.5,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
