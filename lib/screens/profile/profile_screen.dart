import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/config/constants.dart';
import 'package:mission_dmc/config/utils.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/controllers/profile_controller.dart';
import 'package:mission_dmc/screens/chat/chat_view.dart';
import 'package:mission_dmc/screens/profile/profile_update_view.dart';
import 'package:mission_dmc/widgets/reusable_widgets.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, required this.userId}) : super(key: key);
  static const id = 'profile_screen';
  final int userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> 
    with AutomaticKeepAliveClientMixin {
  final AuthController _authController = Get.find();
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileController.loadProfile(userId: widget.userId);
    });
  }

  bool get isOwnProfile => 
      _authController.profile.value.user?.uid == widget.userId;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Stack(
          children: [
            const CoverImage(),
            _buildBackButton(context),
            _buildProfileContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(25),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: kWhiteColor,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return Obx(() {
      if (_profileController.profileLoading.value) {
        return _buildLoadingState(context);
      }
      
      if (_profileController.userProfile.value.id == null) {
        return _buildErrorState(context);
      }
      
      return _buildProfileData(context);
    });
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 120),
      child: Center(
        child: Column(
          children: [
            SpinKitPulse(
              color: Theme.of(context).primaryColor,
              size: 50.0,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading profile...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 120),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.person_off_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Profile not found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This user profile could not be loaded',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadProfileData,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileData(BuildContext context) {
    final profile = _profileController.userProfile.value;
    
    return Container(
      margin: const EdgeInsets.only(top: 95),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildProfileHeader(context, profile),
            const SizedBox(height: 20),
            _buildActionButton(context, profile),
            const SizedBox(height: 24),
            _buildProfileInfo(profile),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic profile) {
    return Column(
      children: [
        _buildProfileImage(profile),
        const SizedBox(height: 16),
        _buildProfileName(profile),
        const SizedBox(height: 8),
        _buildProfileSubtitle(profile),
      ],
    );
  }

  Widget _buildProfileImage(dynamic profile) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(65),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: profile.profile_image == null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(61),
                child: Container(
                  color: Colors.grey[100],
                  child: Image.asset(
                    'assets/default/profile.jpg',
                    width: 122,
                    height: 122,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person_rounded,
                        size: 60,
                        color: Colors.grey[400],
                      );
                    },
                  ),
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(61),
                child: CachedNetworkImage(
                  imageUrl: profile.profile_image!,
                  width: 122,
                  height: 122,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[100],
                    child: Icon(
                      Icons.person_rounded,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildProfileName(dynamic profile) {
    return Text(
      profile.displayName,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildProfileSubtitle(dynamic profile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        profile.displayInstitute,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, dynamic profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: rPrimaryElevatedButton(
        onPressed: () => _handleActionButton(profile),
        primaryColor: Theme.of(context).primaryColor,
        buttonText: isOwnProfile ? 'Update Profile' : 'Send Message',
        fontSize: 16,
        fixedSize: const Size(200, 48),
        borderRadius: 24,
      ),
    );
  }

  void _handleActionButton(dynamic profile) {
    if (!isOwnProfile) {
      // Navigate to chat
      String chatId = getChatId(
        uid: _authController.profile.value.user!.uid!,
        peeredUserId: profile.user!.uid!,
      );
      Get.to(
        () => ChatView(
          chatId: chatId,
          peerUsername: profile.full_name!,
          peerUserId: profile.user!.uid!,
        ),
        fullscreenDialog: true,
        transition: Transition.rightToLeft,
      );
    } else {
      // Navigate to profile update
      Get.to(
        () => ProfileUpdateView(),
        fullscreenDialog: true,
        transition: Transition.upToDown,
      );
    }
  }

  Widget _buildProfileInfo(dynamic profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Institute Information
          _buildInfoCard(
            'assets/profilepageicon/college.png',
            'Institute',
            profile.displayInstitute,
          ),
          
          // Academic Information Section
          if (_hasAcademicInfo(profile)) ...[
            const SizedBox(height: 16),
            _buildSectionDivider('Academic Information'),
            const SizedBox(height: 12),
            _buildAcademicInfoSection(profile),
          ],

          // Personal Information Section (only for own profile)
          if (isOwnProfile) ...[
            const SizedBox(height: 16),
            _buildSectionDivider('Personal Information'),
            const SizedBox(height: 12),
            _buildInfoCard(
              'assets/profilepageicon/mobilenumber.png',
              'Mobile Number',
              profile.displayPhone,
            ),
            _buildInfoCard(
              'assets/profilepageicon/email.png',
              'Email',
              profile.displayEmail,
            ),
          ],
        ],
      ),
    );
  }

  bool _hasAcademicInfo(dynamic profile) {
    return (profile.student_class != null && profile.student_class!.isNotEmpty) ||
           (profile.department != null && profile.department!.isNotEmpty);
  }

  Widget _buildAcademicInfoSection(dynamic profile) {
    bool hasClass = profile.student_class != null && profile.student_class!.isNotEmpty;
    bool hasDepartment = profile.department != null && profile.department!.isNotEmpty;
    
    if (hasClass && hasDepartment) {
      return _buildCombinedAcademicCard(profile.student_class!, profile.department!);
    } else if (hasClass) {
      return _buildInfoCard(
        'assets/profilepageicon/class.png',
        'Student Class',
        profile.displayClass,
      );
    } else if (hasDepartment) {
      return _buildInfoCard(
        'assets/profilepageicon/department.png',
        'Department',
        profile.displayDepartment,
      );
    }
    
    return Container();
  }

  Widget _buildCombinedAcademicCard(String studentClass, String department) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.school_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Academic Information:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            _getClassDisplayName(studentClass),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            _getDepartmentDisplayName(department),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionDivider(String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            title == 'Academic Information' ? Icons.school_rounded : Icons.person_rounded,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String iconPath, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      _getIconForLabel(label),
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    );
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$label:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'institute':
        return Icons.school_rounded;
      case 'student class':
        return Icons.class_rounded;
      case 'department':
        return Icons.category_rounded;
      case 'mobile number':
        return Icons.phone_rounded;
      case 'email':
        return Icons.email_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  String _getClassDisplayName(String? classValue) {
    switch (classValue?.toLowerCase()) {
      case 'ssc':
        return 'এসএসসি (SSC)';
      case 'hsc':
        return 'এইচএসসি (HSC)';
      default:
        return classValue ?? 'Not specified';
    }
  }

  String _getDepartmentDisplayName(String? departmentValue) {
    switch (departmentValue?.toLowerCase()) {
      case 'science':
        return 'বিজ্ঞান (Science)';
      case 'arts':
        return 'মানবিক (Arts)';
      case 'commerce':
        return 'বাণিজ্য (Commerce)';
      default:
        return departmentValue ?? 'Not specified';
    }
  }
}

// Enhanced CoverImage with gradient overlay
class CoverImage extends StatelessWidget {
  const CoverImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.25,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: 'https://wallpapercave.com/wp/wp4041548.jpg',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Theme.of(context).primaryColor,
              ),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
