import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/profile/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:golidoli_app/features/auth/models/response/user_model.dart';
import 'package:golidoli_app/features/profile/controllers/fetch_profile_controller.dart';
import 'package:golidoli_app/shared/widgets/custom_image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:golidoli_app/constants/app_colors.dart';

import 'package:golidoli_app/features/profile/widgets/profile_page_scaffold.dart';
import 'package:golidoli_app/utils/text_style.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FetchProfileController fetchController = Get.put(
    FetchProfileController(),
  );

  late final EditProfileBloc _editProfileBloc;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Worker? _userWorker;
  bool _seeded = false;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _editProfileBloc = context.read<EditProfileBloc>();
      _isInit = true;

      // Seed the form once from whatever user data is already available.
      final existingUser = fetchController.user.value;
      if (existingUser != null) {
        _editProfileBloc.add(EditProfileEvent.initialize(user: existingUser));
        _nameController.text = existingUser.name;
        _emailController.text = existingUser.email;
        _phoneController.text = existingUser.phone;
        _seeded = true;
      } else {
        // Not loaded yet — wait for the first successful fetch, seed once,
        // then stop listening so later refreshes don't clobber user edits.
        _userWorker = ever<UserModel?>(fetchController.user, (userData) {
          if (!_seeded && userData != null) {
            _editProfileBloc.add(EditProfileEvent.initialize(user: userData));
            _nameController.text = userData.name;
            _emailController.text = userData.email;
            _phoneController.text = userData.phone;
            _seeded = true;
            _userWorker?.dispose();
            _userWorker = null;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _userWorker?.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    // Drop the fetch controller when leaving the screen so a future visit
    // starts clean instead of reusing stale state / re-registering.
    Get.delete<FetchProfileController>();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked == null) return;

    // Dispatch event to bloc with picked image file
    _editProfileBloc.add(EditProfileEvent.localImageChanged(
      imageFile: File(picked.path),
    ));
  }

  void _onSave() {
    _editProfileBloc.add(EditProfileEvent.saveProfile(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Edit Profile',
      children: [
        BlocConsumer<EditProfileBloc, EditProfileState>(
          listener: (context, state) {
            if (state.status == Status.success) {
              if (state.user != null) {
                fetchController.updateUser(state.user!);
              }
              Get.back();
            } else if (state.status == Status.error) {
              Get.snackbar(
                "Error",
                state.errorMessage ?? "Failed to update profile",
              );
            }
          },
          builder: (context, state) {
            final user = state.user;

            // Only block the whole form on the very first load, when there's
            // no cached user yet to show.
            if (fetchController.isLoading.value && user == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (fetchController.error.value.isNotEmpty && user == null) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Text(
                      fetchController.error.value,
                      style: text14(color: AppColors.secondaryTextColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: fetchController.refreshProfile,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Center(
                  child: CustomImagePicker(
                    imageFile: state.localImageFile,
                    imageUrl: user?.profileImage ?? "",
                    onTap: _pickAndUploadImage,
                    radius: 42,
                  ),
                ),
                const SizedBox(height: 22),
                _InputField(
                  label: 'Full Name',
                  controller: _nameController,
                ),
                _InputField(
                  label: 'Mobile Number',
                  controller: _phoneController,
                ),
                _InputField(
                  label: 'Email Address',
                  controller: _emailController,
                ),
                const SizedBox(height: 18),
                ProfilePrimaryButton(
                  title: state.status == Status.loading
                      ? 'Saving...'
                      : 'Save Changes',
                  onTap: state.status == Status.loading ? () {} : _onSave,
                ),
              ],
            );
          },
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
