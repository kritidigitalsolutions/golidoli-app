import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/core/services/storage_service.dart';
import 'package:golidoli_app/features/auth/repositories/auth_datasource.dart';
import 'package:golidoli_app/features/home/controllers/ai_reels_controller.dart';
import 'package:golidoli_app/features/profile/controllers/profile_controller.dart';
import 'package:golidoli_app/utils/text_style.dart';
import 'package:golidoli_app/web/layouts/web_main_layout.dart';
import 'package:golidoli_app/web/routes/web_routes.dart';
import 'package:golidoli_app/web/utils/web_responsive.dart';

class WebDeleteAccountScreen extends StatefulWidget {
  const WebDeleteAccountScreen({super.key});

  @override
  State<WebDeleteAccountScreen> createState() => _WebDeleteAccountScreenState();
}

class _WebDeleteAccountScreenState extends State<WebDeleteAccountScreen> {
  final AuthDatasource _authDatasource = AuthDatasource();
  final TextEditingController _feedbackController = TextEditingController();

  bool _isDeleting = false;
  String? _selectedReason;
  bool _understandCheck = false;

  // Backend Spec Reason Categories (enum)
  final List<String> _reasons = [
    'Privacy Concerns',
    'No Longer Using',
    'Too Expensive',
    'Found Alternative',
    'Security Concerns',
    'Accidental Submission',
    'App Performance',
    'Billing Dispute',
    'Other',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _onReasonChanged(String? value) {
    setState(() {
      _selectedReason = value;
    });
  }

  void _onSubmitPressed() {
    if (_selectedReason == null || _selectedReason!.isEmpty) {
      Get.snackbar(
        'Reason Required',
        'Please select a reason category for deleting your account.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (_selectedReason == 'Other' &&
        _feedbackController.text.trim().isEmpty) {
      Get.snackbar(
        'Feedback Required',
        'Please provide reason details in the text box for "Other".',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (!_understandCheck) {
      Get.snackbar(
        'Confirmation Required',
        'Please check the box to confirm that you understand account deletion is permanent.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    _showConfirmationPopup();
  }

  void _showConfirmationPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 460),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.redAccent.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent.withValues(alpha: 0.15),
                      ),
                      child: const Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.redAccent,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Permanently Delete Account?',
                      textAlign: TextAlign.center,
                      style: text20(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Do you really want your account permanently delete? After this you dont use this.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryTextColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        // Cancel Button -> click back (cancel click back kr dena)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isDeleting
                                ? null
                                : () {
                                    Navigator.of(dialogCtx).pop();
                                  },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                color: AppColors.borderColor.withValues(alpha: 0.6),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: text14(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Yes / OK Button -> delete (ok pr click karke delete)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isDeleting
                                ? null
                                : () async {
                                    setDialogState(() {
                                      _isDeleting = true;
                                    });
                                    setState(() {
                                      _isDeleting = true;
                                    });

                                    try {
                                      final response =
                                          await _authDatasource.submitDeletionRequest(
                                        reasonCategory: _selectedReason ?? 'Other',
                                        reasonDetails: _feedbackController.text,
                                      );

                                      final success = response != null &&
                                          (response['success'] == true ||
                                              response['status'] == 'success' ||
                                              response['request'] != null);

                                      final message = response != null
                                          ? response['message']?.toString()
                                          : null;

                                      await StorageService.logout();

                                      if (Get.isRegistered<AiReelsController>()) {
                                        Get.find<AiReelsController>().resetState();
                                        Get.delete<AiReelsController>(force: true);
                                      }
                                      if (Get.isRegistered<ProfileController>()) {
                                        Get.delete<ProfileController>(force: true);
                                      }

                                      if (mounted) {
                                        Navigator.of(dialogCtx).pop();
                                        Get.snackbar(
                                          success ? 'Deletion Request Submitted' : 'Account Deletion',
                                          message ??
                                              'Account deletion request submitted successfully. It will be reviewed by our team.',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: success
                                              ? Colors.green.withValues(alpha: 0.9)
                                              : Colors.orange.withValues(alpha: 0.9),
                                          colorText: Colors.white,
                                          duration: const Duration(seconds: 4),
                                          margin: const EdgeInsets.all(16),
                                        );
                                        Get.offAllNamed(WebRoutes.home);
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        setDialogState(() {
                                          _isDeleting = false;
                                        });
                                        setState(() {
                                          _isDeleting = false;
                                        });
                                        Navigator.of(dialogCtx).pop();
                                        Get.snackbar(
                                          'Error',
                                          'Failed to submit deletion request: $e',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor:
                                              Colors.redAccent.withValues(alpha: 0.9),
                                          colorText: Colors.white,
                                          margin: const EdgeInsets.all(16),
                                        );
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _isDeleting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Yes',
                                    style: text14(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text('Delete Account'),
          backgroundColor: AppColors.backgroundColor,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.computer_rounded,
                  size: 64,
                  color: AppColors.secondaryTextColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Website Only Feature',
                  style: text20(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Account deletion via this page is only available on our official website. Please open https://golidoli.com/delete-account in a web browser.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryTextColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    'Go Back',
                    style: text14(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isMobile = WebResponsive.isMobile(context);
    final horizontalPadding = WebResponsive.contentHorizontalPadding(context);

    return WebMainLayout(
      activeRoute: WebRoutes.deleteAccount,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: isMobile ? 32 : 56,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Container(
              padding: EdgeInsets.all(isMobile ? 20 : 36),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.borderColor.withValues(alpha: 0.4),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Icon & Title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.person_remove_rounded,
                          color: Colors.redAccent,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delete Account',
                              style: text24(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Submit an account deletion request using your authenticated session.',
                              style: text13(
                                color: AppColors.secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
                  const Divider(color: AppColors.borderColor),
                  const SizedBox(height: 24),

                  // Reason Category Selection
                  Text(
                    'Select Reason Category',
                    style: text15(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ..._reasons.map((reason) {
                    final isSelected = _selectedReason == reason;
                    return InkWell(
                      onTap: () => _onReasonChanged(reason),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accentColor.withValues(alpha: 0.12)
                              : AppColors.backgroundColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accentColor
                                : AppColors.borderColor.withValues(alpha: 0.3),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: reason,
                              groupValue: _selectedReason,
                              activeColor: AppColors.accentColor,
                              onChanged: _onReasonChanged,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                reason,
                                style: text14(
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.secondaryTextColor,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  // Reason Details / Feedback Field
                  Text(
                    'Reason Details / Feedback (Optional)',
                    style: text14(
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _feedbackController,
                    maxLines: 4,
                    style: text14(color: AppColors.white),
                    decoration: InputDecoration(
                      hintText:
                          'Please provide additional details or feedback...',
                      hintStyle: text13(
                        color: AppColors.secondaryTextColor.withValues(alpha: 0.6),
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundColor.withValues(alpha: 0.6),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.borderColor.withValues(alpha: 0.4),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.accentColor,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Warning Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.redAccent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.redAccent,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Permanent Action Warning',
                                style: text14(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Identity is extracted securely on the server from your token. After deletion, you won\'t be able to use this account or access your subscription.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.secondaryTextColor,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Confirmation Checkbox
                  CheckboxListTile(
                    value: _understandCheck,
                    onChanged: (val) {
                      setState(() {
                        _understandCheck = val ?? false;
                      });
                    },
                    activeColor: Colors.redAccent,
                    checkColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      'I understand that my account and data will be permanently deleted and cannot be recovered.',
                      style: text13(
                        color: _understandCheck
                            ? AppColors.white
                            : AppColors.secondaryTextColor,
                        fontWeight: _understandCheck
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _onSubmitPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Submit',
                            style: text15(
                              color: Colors.white,
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
          ),
        ),
      ),
    );
  }
}
