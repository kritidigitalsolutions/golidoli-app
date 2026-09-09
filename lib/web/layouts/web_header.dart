import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/app_images.dart';
import 'package:golidoli_app/core/services/storage_service.dart';
import 'package:golidoli_app/features/auth/models/response/user_model.dart';
import 'package:golidoli_app/utils/helpers.dart';
import 'package:golidoli_app/web/routes/web_routes.dart';
import 'package:golidoli_app/web/screens/auth/web_login_dialog.dart';
import 'package:golidoli_app/web/utils/web_responsive.dart';

class WebHeader extends StatefulWidget implements PreferredSizeWidget {
  final String activeRoute;

  const WebHeader({super.key, required this.activeRoute});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  State<WebHeader> createState() => _WebHeaderState();
}

class _WebHeaderState extends State<WebHeader> {
  UserModel? _user;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final token = await StorageService.getToken();
    final user = await StorageService.getUser();
    if (mounted) {
      setState(() {
        _isLoggedIn = token != null && token.isNotEmpty;
        _user = user;
      });
    }
  }

  void _openLogin() {
    showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (ctx) => const WebLoginDialog(),
    ).then((result) {
      if (result == true) {
        _checkAuthState();
      }
    });
  }

  Widget _buildNavItem(String label, String route) {
    final bool isActive =
        widget.activeRoute == route ||
        (route == WebRoutes.home && widget.activeRoute == WebRoutes.root);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (Get.currentRoute != route) {
            Get.toNamed(route);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryPink.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive
                  ? AppColors.primaryPink.withOpacity(0.5)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.primaryPink : AppColors.white,
              fontSize: 15,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = WebResponsive.isMobileOrTablet(context);
    final horizontalPadding = WebResponsive.contentHorizontalPadding(context);

    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor.withOpacity(0.92),
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Mobile Hamburger Button
          if (isMobile) ...[
            IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: Colors.white,
                size: 26,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            const SizedBox(width: 8),
          ],

          // Logo
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                if (Get.currentRoute != WebRoutes.home &&
                    Get.currentRoute != WebRoutes.root) {
                  Get.toNamed(WebRoutes.home);
                }
              },
              child: Row(
                children: [
                  Image.asset(
                    AppImages.logo,
                    height: 38,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.play_circle_fill_rounded,
                      color: AppColors.primaryPink,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'GoliDoli',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Desktop Navigation Menu
          if (!isMobile) ...[
            const SizedBox(width: 36),
            _buildNavItem('Home', WebRoutes.home),

            const SizedBox(width: 8),
            _buildNavItem('Movies', WebRoutes.movies),
            const SizedBox(width: 8),
            _buildNavItem('Series', WebRoutes.series),
            const SizedBox(width: 8),
            _buildNavItem('Micro Dramas', WebRoutes.dramas),
          ],

          const Spacer(),

          // Search Button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              margin: const EdgeInsets.only(right: 14),
              child: IconButton(
                icon: const Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                tooltip: 'Search',
                onPressed: () {
                  if (Get.currentRoute != WebRoutes.search) {
                    Get.toNamed(WebRoutes.search);
                  }
                },
              ),
            ),
          ),

          // Profile or Login Button
          if (_isLoggedIn)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  if (Get.currentRoute != WebRoutes.profile) {
                    Get.toNamed(WebRoutes.profile);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.borderColor.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primaryPink,
                        backgroundImage:
                            (_user?.profileImage != null &&
                                _user!.profileImage.isNotEmpty)
                            ? CachedNetworkImageProvider(
                                formatMediaUrl(_user!.profileImage),
                              )
                            : null,
                        child:
                            (_user?.profileImage == null ||
                                _user!.profileImage.isEmpty)
                            ? Text(
                                (_user?.name.isNotEmpty == true)
                                    ? _user!.name[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      if (!isMobile && _user?.name.isNotEmpty == true) ...[
                        const SizedBox(width: 8),
                        Text(
                          _user!.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            )
          else
            ElevatedButton(
              onPressed: _openLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPink,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 14 : 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
