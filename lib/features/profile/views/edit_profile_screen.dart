import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/profile/controllers/profile_controller.dart';
import 'package:golidoli_app/features/profile/widgets/profile_page_scaffold.dart';
import 'package:golidoli_app/utils/text_style.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final EditProfileController controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Edit Profile',

      children: [
        Center(
          child: Obx(
            () => Stack(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: AppColors.cardColor,
                  backgroundImage: controller.profileImage.value != null
                      ? FileImage(controller.profileImage.value!)
                      : null,
                  child: controller.profileImage.value == null
                      ? const Icon(
                          Icons.person,
                          color: AppColors.secondaryTextColor,
                          size: 44,
                        )
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: controller.showImagePicker,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: AppColors.black,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        _InputField(label: 'Full Name', controller: controller.nameController),
        _InputField(
          label: 'Mobile Number',
          controller: controller.mobileController,
        ),
        _InputField(
          label: 'Email Address',
          controller: controller.emailController,
        ),
        const SizedBox(height: 18),
        Obx(
          () => ProfilePrimaryButton(
            title: controller.isSaving.value ? 'Saving...' : 'Save Changes',
            onTap: controller.isSaving.value ? () {} : controller.saveProfile,
          ),
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _InputField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: text12(color: AppColors.secondaryTextColor)),
          const SizedBox(height: 7),
          TextField(
            controller: controller,
            style: text14(),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.borderColor.withOpacity(0.6),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.accentColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
