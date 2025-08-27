import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mission_dmc/controllers/profile_controller.dart';
import 'package:mission_dmc/widgets/circle_button.dart';
import 'package:mission_dmc/widgets/reusable_widgets.dart';

class ProfileUpdateView extends StatefulWidget {
  const ProfileUpdateView({super.key});
  @override
  _ProfileUpdateViewState createState() => _ProfileUpdateViewState();
}

class _ProfileUpdateViewState extends State<ProfileUpdateView> {
  final ProfileController _profileController = Get.find();

  final TextEditingController _editingControllerFullName = TextEditingController();
  final TextEditingController _editingControllerEmail = TextEditingController();
  final TextEditingController _editingControllerInstitute = TextEditingController();
  final TextEditingController _editingControllerHSCExamYear = TextEditingController();

  // Dropdown values for class and department
  String? _selectedClass;
  String? _selectedDepartment;

  // Dropdown options
  final List<String> _classOptions = ['ssc', 'hsc'];
  final List<String> _departmentOptions = ['science', 'arts', 'commerce'];

  late String _countryCode, _countryName;

  @override
  void initState() {
    _profileController.clearUploadedFiles();

    _editingControllerFullName.text = _profileController.userProfile.value.full_name ?? '';
    _editingControllerEmail.text = _profileController.userProfile.value.email ?? '';
    _editingControllerInstitute.text = _profileController.userProfile.value.institute ?? '';
    _editingControllerHSCExamYear.text = _profileController.userProfile.value.hsc_exam_year?.toString() ?? '';

    // Initialize dropdown values with current profile data
    _selectedClass = _profileController.userProfile.value.student_class ?? 'hsc';
    _selectedDepartment = _profileController.userProfile.value.department ?? 'science';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: _profileController.profileUpdateLoading.value,
        progressIndicator: SpinKitCubeGrid(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        ),
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text(
              'Update Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image Section
                  Center(
                    child: SizedBox(
                      height: 180,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Center(
                              child: Obx(() {
                                Widget profileImage;
                                
                                if (_profileController.selectedProfileImageFile.value.path != '') {
                                  profileImage = CircleAvatar(
                                    backgroundColor: Colors.blueGrey,
                                    backgroundImage: FileImage(_profileController.selectedProfileImageFile.value),
                                    radius: 80,
                                  );
                                } else if (_profileController.userProfile.value.profile_image != null) {
                                  profileImage = CircleAvatar(
                                    backgroundColor: Colors.blueGrey,
                                    backgroundImage: CachedNetworkImageProvider(
                                        _profileController.userProfile.value.profile_image!),
                                    radius: 80,
                                  );
                                } else {
                                  profileImage = const CircleAvatar(
                                    backgroundColor: Colors.blueGrey,
                                    backgroundImage: AssetImage('assets/default/profile.jpg'),
                                    radius: 80,
                                  );
                                }

                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 3,
                                        blurRadius: 15,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: profileImage,
                                );
                              }),
                            ),
                          ),
                          Positioned(
                            left: 130,
                            right: 0,
                            bottom: 110,
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: CircleButton(
                                  icon: Icons.camera_alt_rounded,
                                  iconSize: 24.0,
                                  iconColor: Colors.white,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  onPressed: () async {
                                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'tiff'],
                                    );

                                    if (result != null) {
                                      PlatformFile file = result.files.first;
                                      File imageFile = File(file.path!);
                                      CroppedFile? croppedFile = await ImageCropper().cropImage(
                                        sourcePath: imageFile.path,
                                        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                                        uiSettings: [
                                          AndroidUiSettings(
                                            toolbarTitle: 'Crop Image',
                                            toolbarColor: Theme.of(context).primaryColor,
                                            toolbarWidgetColor: Colors.white,
                                            lockAspectRatio: true,
                                          ),
                                          IOSUiSettings(
                                            title: 'Crop Image',
                                            aspectRatioLockEnabled: true,
                                          ),
                                        ],
                                      );
                                      if (croppedFile != null) {
                                        imageFile = File(croppedFile.path);
                                      }

                                      _profileController.putPageProfileImage(
                                          file: imageFile, extension: file.extension!);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  // Section Header
                  _buildSectionHeader('Personal Information', Icons.person_rounded),
                  SizedBox(height: 16),

                  // Full Name Field
                  _buildModernTextField(
                    controller: _editingControllerFullName,
                    hintText: "Enter Your Full Name",
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 16),

                  // Email Field
                  _buildModernTextField(
                    controller: _editingControllerEmail,
                    hintText: "Enter Your Email Address",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 24),

                  // Academic Information Section
                  _buildSectionHeader('Academic Information', Icons.school_rounded),
                  SizedBox(height: 16),

                  // Institute Field
                  _buildModernTextField(
                    controller: _editingControllerInstitute,
                    hintText: "Enter Your College/School Name",
                    icon: Icons.account_balance_outlined,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 16),

                  // HSC Exam Year Field
                  _buildModernTextField(
                    controller: _editingControllerHSCExamYear,
                    hintText: "HSC Exam Year (e.g., 2024)",
                    icon: Icons.calendar_today_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),

                  // Class Dropdown
                  _buildModernDropdown(
                    value: _selectedClass,
                    options: _classOptions,
                    hintText: "Select Class",
                    icon: Icons.class_outlined,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedClass = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Department Dropdown
                  _buildModernDropdown(
                    value: _selectedDepartment,
                    options: _departmentOptions,
                    hintText: "Select Department",
                    icon: Icons.category_outlined,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDepartment = newValue;
                      });
                    },
                  ),

                  SizedBox(height: 32),

                  // Save Button
                  _buildModernButton(context),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 15,
          ),
          prefixIcon: Container(
            padding: EdgeInsets.all(12),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildModernDropdown({
    required String? value,
    required List<String> options,
    required String hintText,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: value,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 15,
                  ),
                ),
                dropdownColor: Colors.white,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey[600],
                  size: 24,
                ),
                items: options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            FocusScope.of(context).unfocus();
            if (_profileController.profileUpdateLoading.value) {
              return;
            }

            String fullName = _editingControllerFullName.text.trim();
            String emailAddress = _editingControllerEmail.text.trim();
            String institute = _editingControllerInstitute.text.trim();
            String hscExamYear = _editingControllerHSCExamYear.text.trim();

            // Validation
            if (fullName.isEmpty) {
              Get.snackbar(
                'Validation Error',
                'Please enter your full name.',
                backgroundColor: Colors.red[600],
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
                duration: Duration(seconds: 3),
                icon: Icon(Icons.error_outline, color: Colors.white),
                borderRadius: 10,
                margin: EdgeInsets.all(10),
              );
              return;
            }

            if (emailAddress.isEmpty || !GetUtils.isEmail(emailAddress)) {
              Get.snackbar(
                'Validation Error',
                'Please enter a valid email address.',
                backgroundColor: Colors.red[600],
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
                duration: Duration(seconds: 3),
                icon: Icon(Icons.error_outline, color: Colors.white),
                borderRadius: 10,
                margin: EdgeInsets.all(10),
              );
              return;
            }

            if (institute.isEmpty) {
              Get.snackbar(
                'Validation Error',
                'Please enter your institute name.',
                backgroundColor: Colors.red[600],
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
                duration: Duration(seconds: 3),
                icon: Icon(Icons.error_outline, color: Colors.white),
                borderRadius: 10,
                margin: EdgeInsets.all(10),
              );
              return;
            }

            if (int.tryParse(hscExamYear) == null) {
              Get.snackbar(
                'Validation Error',
                'Please enter a valid HSC exam year.',
                backgroundColor: Colors.red[600],
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
                duration: Duration(seconds: 3),
                icon: Icon(Icons.error_outline, color: Colors.white),
                borderRadius: 10,
                margin: EdgeInsets.all(10),
              );
              return;
            }

            _profileController.tryToUpdateProfile(
              fullName: fullName,
              emailAddress: emailAddress,
              hscPassingYear: int.parse(hscExamYear),
              institute: institute,
              studentClass: _selectedClass ?? 'hsc',
              department: _selectedDepartment ?? 'science',
            );
          },
          child: Center(
            child: _profileController.profileUpdateLoading.value
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Update Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
