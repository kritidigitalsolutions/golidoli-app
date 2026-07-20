import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/profile/bloc/document_bloc/help_cubit.dart';
import 'package:golidoli_app/features/profile/widgets/profile_page_scaffold.dart';
import 'package:golidoli_app/utils/text_style.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HelpCubit>().singleDocument(id: "privacy-policy");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HelpCubit, HelpState>(
      builder: (context, state) {
        // Loading State
        if (state.singleDocumentStatus == Status.loading) {
          return ProfilePageScaffold(
            title: 'Privacy Policy',
            children: [
              const SizedBox(height: 100),
              const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          );
        }

        // Error State
        if (state.singleDocumentStatus == Status.error) {
          return ProfilePageScaffold(
            title: 'Privacy Policy',
            children: [
              const SizedBox(height: 100),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.grey[400],
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load privacy policy',
                      style: text13(color: AppColors.secondaryTextColor),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<HelpCubit>()
                            .singleDocument(id: "privacy-policy");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        // Success State
        if (state.singleDocumentStatus == Status.success &&
            state.singleDocument != null) {
          final document = state.singleDocument!;

          // If document has no content
          if (document.content.isEmpty) {
            return ProfilePageScaffold(
              title: 'Privacy Policy',
              children: [
                const SizedBox(height: 100),
                Center(
                  child: Text(
                    'No privacy policy available',
                    style: text13(color: AppColors.secondaryTextColor),
                  ),
                ),
              ],
            );
          }

          return ProfilePageScaffold(
            title: 'Privacy Policy',
            children: [
              Text(
                'Last updated: ${_formatDate(document.updatedAt)}',
                style: text12(color: AppColors.secondaryTextColor),
              ),
              const SizedBox(height: 14),

              // Display the document content
              ProfileSurfaceTile(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: text15(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      document.content,
                      style: text13(color: AppColors.secondaryTextColor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Last updated: ${_formatDate(document.updatedAt)}',
                      style: text11(color: AppColors.secondaryTextColor),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        // Default/Initial state
        return ProfilePageScaffold(
          title: 'Privacy Policy',
          children: [
            const SizedBox(height: 100),
            Center(
              child: Text(
                'Loading privacy policy...',
                style: text13(color: AppColors.secondaryTextColor),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}