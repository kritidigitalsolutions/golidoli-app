import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/profile/bloc/document_bloc/help_cubit.dart';
import 'package:golidoli_app/features/profile/widgets/profile_page_scaffold.dart';
import 'package:golidoli_app/utils/text_style.dart';
import '../../../constants/enums.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HelpCubit>().getDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HelpCubit, HelpState>(
      builder: (context, state) {
        // Loading State
        if (state.documentStatus == Status.loading) {
          return ProfilePageScaffold(
            title: 'Terms & Conditions',
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
        if (state.documentStatus == Status.error) {
          return ProfilePageScaffold(
            title: 'Terms & Conditions',
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
                      'Failed to load terms & conditions',

                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<HelpCubit>()
                            .getDocuments();
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
        if (state.documentStatus == Status.success && state.documents != null) {
          final document = state.documents!;

          // If no documents found
          if (document.documents.isEmpty) {
            return ProfilePageScaffold(
              title: 'Terms & Conditions',
              children: [
                const SizedBox(height: 100),
                Center(
                  child: Text(
                    'No terms & conditions available',

                  ),
                ),
              ],
            );
          }

          // Get the first document (assuming there's only one terms document)
          final termsDoc = document.documents.first;

          return ProfilePageScaffold(
            title: 'Terms & Conditions',
            children: [
              Text(
                'Please read these terms before using GoliDoli.',
                style: text13(color: AppColors.secondaryTextColor),
              ),
              const SizedBox(height: 14),

              // Display the document content
              ProfileSurfaceTile(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      termsDoc.title,
                      style: text15(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      termsDoc.content,
                      style: text13(color: AppColors.secondaryTextColor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Last updated: ${_formatDate(termsDoc.updatedAt)}',
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
          title: 'Terms & Conditions',
          children: [
            const SizedBox(height: 100),
            Center(
              child: Text(
                'Loading terms & conditions...',

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