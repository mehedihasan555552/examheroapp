import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/controllers/mcq_preparation_controller.dart';
import 'package:mission_dmc/screens/profile/profile_screen.dart';

class RankingScreen extends GetView {
  static const id = 'performance_screen';

  RankingScreen({
    super.key,
    required this.isSubjectWise,
    required this.mcqTest,
  });
  
  final bool isSubjectWise;
  final dynamic mcqTest;
  final AuthController _authController = Get.find();
  final MCQPreparationController _mcqPreparationController =
      Get.put(MCQPreparationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: FutureBuilder(
              future: _mcqPreparationController.fetcMCQTestRankingList(
                  isSubjectWise: isSubjectWise, testId: mcqTest['id']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return _buildErrorWidget();
                  } else if (snapshot.hasData) {
                    final listData = snapshot.data as List<dynamic>;
                    return _buildRankingList(listData);
                  }
                }
                return _buildLoadingWidget(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      title: Column(
        children: [
          const Text(
            'র‍্যাঙ্কিং বোর্ড',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            mcqTest['title'],
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          onPressed: () => Get.forceAppUpdate(),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.amber[300],
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'শীর্ষ পারফরমার তালিকা',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingList(List<dynamic> listData) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: listData.length,
      itemBuilder: (context, index) => _rankingItem(
        data: listData[index],
        context: context,
        serialNumber: index + 1,
      ),
    );
  }

  Widget _rankingItem({
    required dynamic data,
    required BuildContext context,
    required int serialNumber,
  }) {
    Color rankColor = _getRankColor(serialNumber);
    IconData rankIcon = _getRankIcon(serialNumber);
    bool isTopThree = serialNumber <= 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isTopThree 
                ? rankColor.withOpacity(0.2) 
                : Colors.black.withOpacity(0.08),
            blurRadius: isTopThree ? 15 : 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isTopThree
            ? Border.all(color: rankColor.withOpacity(0.3), width: 1)
            : null,
      ),
      child: InkWell(
        onTap: () => Get.to(
          () => ProfileScreen(userId: data['profile']['user']['uid']),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Rank Badge
              _buildRankBadge(serialNumber, rankColor, rankIcon, isTopThree),
              const SizedBox(width: 16),
              
              // Profile Image
              _buildProfileImage(data),
              const SizedBox(width: 16),
              
              // User Details
              Expanded(
                child: _buildUserDetails(data, context),
              ),
              
              // Score Badge
              _buildScoreBadge(data, rankColor, isTopThree),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankBadge(int serialNumber, Color rankColor, IconData rankIcon, bool isTopThree) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: isTopThree
            ? LinearGradient(
                colors: [rankColor.withOpacity(0.8), rankColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.grey[400]!, Colors.grey[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: rankColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: isTopThree
          ? Icon(
              rankIcon,
              color: Colors.white,
              size: 24,
            )
          : Center(
              child: Text(
                '#$serialNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  Widget _buildProfileImage(dynamic data) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey[200]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: data['profile']['profile_image'] == null
            ? Image.asset(
                'assets/default/profile.jpg',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                imageUrl: data['profile']['profile_image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
              ),
      ),
    );
  }

  Widget _buildUserDetails(dynamic data, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data['profile']['full_name'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.school_rounded,
              size: 16,
              color: Colors.blue[600],
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                data['profile']['institute'] ?? 'প্রতিষ্ঠান নেই',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.timer_rounded,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              'পরীক্ষা সম্পন্ন',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreBadge(dynamic data, Color rankColor, bool isTopThree) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: isTopThree
            ? LinearGradient(
                colors: [rankColor.withOpacity(0.1), rankColor.withOpacity(0.2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.grey[100]!, Colors.grey[200]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isTopThree ? rankColor.withOpacity(0.3) : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${data['marks']}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isTopThree ? rankColor : Colors.black87,
            ),
          ),
          Text(
            'নম্বর',
            style: TextStyle(
              fontSize: 10,
              color: isTopThree ? rankColor : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitWave(
            color: Theme.of(context).primaryColor,
            size: 50.0,
          ),
          const SizedBox(height: 20),
          Text(
            'র‍্যাঙ্কিং লোড হচ্ছে...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: Colors.red[400],
            ),
            const SizedBox(height: 24),
            const Text(
              'কোনো সমস্যা হয়েছে',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'র‍্যাঙ্কিং লোড করতে সমস্যা হয়েছে',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.forceAppUpdate(),
              icon: const Icon(Icons.refresh),
              label: const Text('আবার চেষ্টা করুন'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber; // Gold
      case 2:
        return Colors.grey[400]!; // Silver
      case 3:
        return Colors.orange[700]!; // Bronze
      default:
        return Colors.grey[500]!;
    }
  }

  IconData _getRankIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events_rounded; // Trophy
      case 2:
        return Icons.military_tech_rounded; // Medal
      case 3:
        return Icons.workspace_premium_rounded; // Bronze medal
      default:
        return Icons.person_rounded;
    }
  }
}
