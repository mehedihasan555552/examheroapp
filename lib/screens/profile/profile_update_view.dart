import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mission_dmc/controllers/profile_controller.dart';
import 'package:mission_dmc/widgets/circle_button.dart';
import 'package:mission_dmc/widgets/reusable_widgets.dart';

class ProfileUpdateView extends StatefulWidget {
  const ProfileUpdateView({Key? key}) : super(key: key);
  
  @override
  _ProfileUpdateViewState createState() => _ProfileUpdateViewState();
}

class _ProfileUpdateViewState extends State<ProfileUpdateView> {
  final ProfileController _profileController = Get.find();
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController _editingControllerFullName = TextEditingController();
  final TextEditingController _editingControllerEmail = TextEditingController();
  final TextEditingController _editingControllerInstitute = TextEditingController();

  // Reactive variables for dropdowns
  RxString selectedClass = ''.obs;
  RxString selectedDepartment = ''.obs;

  // Dropdown options matching your Django model
  final List<Map<String, String>> classOptions = [
    {'value': '', 'label': 'Select Class'},
    {'value': 'ssc', 'label': 'এসএসসি (SSC)'},
    {'value': 'hsc', 'label': 'এইচএসসি (HSC)'},
  ];

  final List<Map<String, String>> departmentOptions = [
    {'value': '', 'label': 'Select Department'},
    {'value': 'science', 'label': 'বিজ্ঞান (Science)'},
    {'value': 'arts', 'label': 'মানবিক (Arts)'},
    {'value': 'commerce', 'label': 'বাণিজ্য (Commerce)'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _profileController.clearUploadedFiles();

    final profile = _profileController.userProfile.value;
    
    // Initialize text controllers with null-safe values
    _editingControllerFullName.text = profile.full_name ?? '';
    _editingControllerEmail.text = profile.email ?? '';
    _editingControllerInstitute.text = profile.institute ?? '';
    
    // Initialize dropdown values
    selectedClass.value = profile.student_class ?? '';
    selectedDepartment.value = profile.department ?? '';
  }

  @override
  void dispose() {
    _editingControllerFullName.dispose();
    _editingControllerEmail.dispose();
    _editingControllerInstitute.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: _profileController.profileUpdateLoading.value,
        progressIndicator: SpinKitPulse(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        ),
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: _buildAppBar(context),
          body: _buildBody(context),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Update Profile',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildProfileImageSection(context),
            _buildFormSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImageSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            children: [
              _buildProfileImage(),
              _buildEditImageButton(context),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _profileController.userProfile.value.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _profileController.userProfile.value.displayEmail,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Obx(() {
      Widget imageWidget;
      
      if (_profileController.selectedProfileImageFile.value.path.isNotEmpty) {
        imageWidget = Image.file(
          _profileController.selectedProfileImageFile.value,
          fit: BoxFit.cover,
        );
      } else if (_profileController.userProfile.value.hasProfileImage) {
        imageWidget = CachedNetworkImage(
          imageUrl: _profileController.userProfile.value.profile_image!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.person, size: 60),
          ),
        );
      } else {
        imageWidget = Image.asset(
          'assets/default/profile.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(Icons.person, size: 60, color: Colors.grey),
            );
          },
        );
      }

      return Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(70),
          child: imageWidget,
        ),
      );
    });
  }

  Widget _buildEditImageButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CircleButton(
          icon: Icons.camera_alt_rounded,
          iconSize: 24.0,
          iconColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          onPressed: _pickAndCropImage,
        ),
      ),
    );
  }

  Widget _buildFormSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Personal Information', Icons.person_rounded),
          const SizedBox(height: 20),
          
          _buildTextField(
            controller: _editingControllerFullName,
            label: 'Full Name',
            hint: 'Enter your full name',
            icon: Icons.person_outline_rounded,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Full name is required';
              }
              if (value.trim().length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: _editingControllerEmail,
            label: 'Email Address',
            hint: 'Enter your email address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              if (!GetUtils.isEmail(value.trim())) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Academic Information', Icons.school_rounded),
          const SizedBox(height: 20),
          
          _buildTextField(
            controller: _editingControllerInstitute,
            label: 'Institute/College',
            hint: 'Enter your institute name',
            icon: Icons.business_rounded,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Institute name is required';
              }
              if (value.trim().length < 3) {
                return 'Institute name must be at least 3 characters';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Student Class Dropdown
          Obx(() => _buildDropdownField(
            label: 'Student Class',
            value: selectedClass.value,
            items: classOptions,
            icon: Icons.class_rounded,
            onChanged: (String? newValue) {
              selectedClass.value = newValue ?? '';
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select student class';
              }
              return null;
            },
          )),
          
          const SizedBox(height: 16),
          
          // Department Dropdown
          Obx(() => _buildDropdownField(
            label: 'Department',
            value: selectedDepartment.value,
            items: departmentOptions,
            icon: Icons.category_rounded,
            onChanged: (String? newValue) {
              selectedDepartment.value = newValue ?? '';
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select department';
              }
              return null;
            },
          )),
          
          const SizedBox(height: 32),
          
          _buildUpdateButton(context),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<Map<String, String>> items,
    required IconData icon,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          hint: Text('Select $label'),
          items: items.skip(1).map((Map<String, String> item) {
            return DropdownMenuItem<String>(
              value: item['value'],
              child: Text(item['label']!),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _handleUpdate,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: const Text(
          'Update Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _pickAndCropImage() async {
    try {
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
              toolbarTitle: 'Crop Profile Image',
              toolbarColor: Theme.of(context).primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: 'Crop Profile Image',
              aspectRatioLockEnabled: true,
              resetAspectRatioEnabled: false,
            ),
          ],
        );
        
        if (croppedFile != null) {
          imageFile = File(croppedFile.path);
          _profileController.putPageProfileImage(
            file: imageFile,
            extension: file.extension!,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _handleUpdate() {
    if (_profileController.profileUpdateLoading.value) {
      return;
    }

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    String fullName = _editingControllerFullName.text.trim();
    String emailAddress = _editingControllerEmail.text.trim();
    String institute = _editingControllerInstitute.text.trim();
    String studentClass = selectedClass.value;
    String department = selectedDepartment.value;

    print('=== PROFILE UPDATE DATA ===');
    print('Full Name: $fullName');
    print('Email: $emailAddress');
    print('Institute: $institute');
    print('Student Class: $studentClass');
    print('Department: $department');

    // Call the profile update method (it handles success/error internally)
    _profileController.tryToUpdateProfile(
      fullName: fullName,
      emailAddress: emailAddress,
      institute: institute,
      studentClass: studentClass,
      department: department,
    );
  }
}
