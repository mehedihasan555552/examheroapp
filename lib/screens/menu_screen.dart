import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/app/modules/info/views/about_app_view.dart';
import 'package:mission_dmc/app/modules/info/views/privacy_policy_view.dart';
import 'package:mission_dmc/app/modules/info/views/refun_policy_view.dart';
import 'package:mission_dmc/app/modules/info/views/terms_and_conditions_view.dart';
import 'package:mission_dmc/screens/auth/password/change_password_view.dart';
import 'package:mission_dmc/screens/chat/chat_list_view.dart';
import 'package:mission_dmc/screens/profile/profile_screen.dart';
import 'package:mission_dmc/widgets/refer_widget.dart';

import '../controllers/auth_controller.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});

  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    _authController.menuDataList();
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Profile Image
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blueGrey,
                        backgroundImage: _authController.profile.value.profile_image == null
                            ? const AssetImage('assets/default/profile.jpg')
                            : CachedNetworkImageProvider(
                                _authController.profile.value.profile_image!) as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Name
                    Text(
                      _authController.profile.value.full_name ?? 'User',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // View Profile Button
                    GestureDetector(
                      onTap: () => Get.to(() => ProfileScreen(
                          userId: _authController.profile.value.user!.uid!)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: const Text(
                          'View Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Menu Items Section
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.key_outlined,
                    title: 'Change Password',
                    iconColor: Colors.blue,
                    onTap: () => Get.to(() => ChangePasswordView(), fullscreenDialog: true),
                  ),
                  _buildDivider(),
                  _buildMenuTile(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    iconColor: Colors.orange,
                    onTap: () => Get.to(() => TermsAndConfitionsView(authController: _authController)),
                  ),
                  _buildDivider(),
                  _buildMenuTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    iconColor: Colors.green,
                    onTap: () => Get.to(() => PrivacyPolicyView(authController: _authController)),
                  ),
                  _buildDivider(),
                  _buildMenuTile(
                    icon: Icons.policy_outlined,
                    title: 'Refund Policy',
                    iconColor: Colors.purple,
                    onTap: () => Get.to(() => RefunPolicyView(authController: _authController)),
                  ),
                  _buildDivider(),
                  _buildMenuTile(
                    icon: Icons.info_outline,
                    title: 'About App',
                    iconColor: Colors.teal,
                    onTap: () => Get.to(() => AboutAppView(authController: _authController)),
                  ),
                ],
              ),
            ),

            // Logout Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(() {
                if (_authController.authLoading.value) {
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SpinKitThreeBounce(
                        color: Colors.red,
                        size: 20.0,
                      ),
                    ),
                    title: const Text(
                      'Logging out...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  );
                }
                return ListTile(
                  onTap: () => _authController.tryToSignOut(),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.red,
                    size: 16,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                );
              }),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 16,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: Colors.grey.shade100,
    );
  }
}
