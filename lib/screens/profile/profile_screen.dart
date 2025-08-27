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

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, required this.userId});
  static const id = 'profile_screen';
  final int userId;
  final AuthController _authController = Get.find();
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      _profileController.loadProfile(userId: userId);
    });
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Stack(
          children: [
            const CoverImage(),
            
            // Back button
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: kWhiteColor,
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            
            Obx(() {
              if (_profileController.profileLoading.value) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SpinKitCubeGrid(
                          color: Theme.of(context).primaryColor,
                          size: 50.0,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading Profile...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              if (_profileController.userProfile.value.id == null) {
                return Container();
              }
              
              return Container(
                margin: const EdgeInsets.only(top: 75),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      
                      // Profile Image with enhanced design
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(70),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: _profileController.userProfile.value.profile_image == null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(70),
                                  child: Image.asset(
                                    'assets/default/profile.jpg',
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(70),
                                  child: CachedNetworkImage(
                                    imageUrl: _profileController.userProfile.value.profile_image!,
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[200],
                                      child: Icon(Icons.person, size: 60, color: Colors.grey),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      color: Colors.grey[200],
                                      child: Icon(Icons.person, size: 60, color: Colors.grey),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Name with enhanced styling
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          _profileController.userProfile.value.full_name ?? 'Unknown User',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Enhanced Action Button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
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
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              if (_authController.profile.value.user!.uid! != userId) {
                                String chatId = getChatId(
                                    uid: _authController.profile.value.user!.uid!,
                                    peeredUserId: _profileController.userProfile.value.user!.uid!);
                                Get.to(
                                  () => ChatView(
                                    chatId: chatId,
                                    peerUsername: _profileController.userProfile.value.full_name!,
                                    peerUserId: _profileController.userProfile.value.user!.uid!,
                                  ),
                                  fullscreenDialog: true,
                                );
                              } else {
                                Get.to(() => ProfileUpdateView(), fullscreenDialog: true);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _authController.profile.value.user!.uid! != userId
                                        ? Icons.message_rounded
                                        : Icons.edit_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    _authController.profile.value.user!.uid! != userId
                                        ? 'Send Message'
                                        : 'Update Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Profile Information Cards
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            // Academic Information Section
                            _buildSectionHeader('Academic Information', Icons.school_rounded),
                            SizedBox(height: 12),
                            
                            ModernCardDesign(
                              icon: Icons.account_balance_rounded,
                              topicText: 'College',
                              nameText: _profileController.userProfile.value.institute ?? 'Not specified',
                              color: Colors.blue,
                            ),
                            
                            ModernCardDesign(
                              icon: Icons.class_rounded,
                              topicText: 'Class',
                              nameText: _profileController.userProfile.value.student_class?.toUpperCase() ?? 'Not specified',
                              color: Colors.green,
                            ),
                            
                            ModernCardDesign(
                              icon: Icons.category_rounded,
                              topicText: 'Department',
                              nameText: _getDepartmentDisplayName(_profileController.userProfile.value.department),
                              color: Colors.purple,
                            ),
                            
                            ModernCardDesign(
                              icon: Icons.calendar_today_rounded,
                              topicText: 'HSC Passing Year',
                              nameText: '${_profileController.userProfile.value.hsc_exam_year ?? 'Not specified'}',
                              color: Colors.orange,
                            ),
                            
                            // Personal Information Section (only for own profile)
                            if (_authController.profile.value.user!.uid! == userId) ...[
                              SizedBox(height: 20),
                              _buildSectionHeader('Personal Information', Icons.person_rounded),
                              SizedBox(height: 12),
                              
                              ModernCardDesign(
                                icon: Icons.phone_rounded,
                                topicText: 'Mobile Number',
                                nameText: _profileController.userProfile.value.user?.phone ?? 'Not specified',
                                color: Colors.teal,
                              ),
                              
                              ModernCardDesign(
                                icon: Icons.email_rounded,
                                topicText: 'Email',
                                nameText: _profileController.userProfile.value.email ?? 'Not specified',
                                color: Colors.red,
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: kPrimaryColor,
            size: 20,
          ),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  String _getDepartmentDisplayName(String? department) {
    if (department == null || department.isEmpty) return 'Not specified';
    
    switch (department.toLowerCase()) {
      case 'science':
        return 'বিজ্ঞান';
      case 'arts':
        return 'মানবিক';
      case 'commerce':
        return 'বাণিজ্য';
      default:
        return department.substring(0, 1).toUpperCase() + department.substring(1).toLowerCase();
    }
  }
}

class ModernCardDesign extends StatelessWidget {
  final IconData icon;
  final String nameText;
  final String topicText;
  final Color color;

  const ModernCardDesign({
    required this.icon,
    required this.nameText,
    required this.topicText,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topicText,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    nameText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.verified,
                color: color,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Keep your existing classes for backward compatibility
class SingleCardDesign extends StatelessWidget {
  final String image;
  final String nameText;
  final String topicText;
  
  const SingleCardDesign({
    required this.image,
    required this.nameText,
    required this.topicText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Card(
            elevation: 10,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Image.asset(
                    image,
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$topicText :',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          nameText,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CircularImage extends StatelessWidget {
  CircularImage({super.key});
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Positioned(
      top: size.height * .15,
      child: Obx(
        () => _profileController.userProfile.value.profile_image == null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  'assets/default/profile.jpg',
                  width: 120,
                  fit: BoxFit.cover,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: _profileController.userProfile.value.profile_image!,
                  width: 120,
                ),
              ),
      ),
    );
  }
}

class CoverImage extends StatelessWidget {
  const CoverImage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .22,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kPrimaryColor.withOpacity(0.8),
            kPrimaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(
              'https://wallpapercave.com/wp/wp4041548.jpg',
            ),
            colorFilter: ColorFilter.mode(
              kPrimaryColor.withOpacity(0.3),
              BlendMode.overlay,
            ),
          ),
        ),
      ),
    );
  }
}
