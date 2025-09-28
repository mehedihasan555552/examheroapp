import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Teacher Model
class Teacher {
  final int id;
  final String name;
  final String instituteName;
  final String experience;
  final String? profileImg;
  final String department;
  final String studentClass;

  Teacher({
    required this.id,
    required this.name,
    required this.instituteName,
    required this.experience,
    this.profileImg,
    required this.department,
    required this.studentClass,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      instituteName: json['institute_name'] ?? '',
      experience: json['experiance'] ?? '', // Note: API has typo "experiance"
      profileImg: json['profile_img'],
      department: json['department'] ?? '',
      studentClass: json['student_class'] ?? '',
    );
  }

  String get fullProfileImageUrl {
    if (profileImg == null || profileImg!.isEmpty) return '';
    if (profileImg!.startsWith('http')) return profileImg!;
    return 'https://admin.examhero.xyz$profileImg';
  }

  String get displayDepartment {
    switch (department.toLowerCase()) {
      case 'science':
        return 'বিজ্ঞান (Science)';
      case 'arts':
        return 'মানবিক (Arts)';
      case 'commerce':
        return 'বাণিজ্য (Commerce)';
      default:
        return department;
    }
  }

  String get displayClass {
    switch (studentClass.toLowerCase()) {
      case 'ssc':
        return 'এসএসসি (SSC)';
      case 'hsc':
        return 'এইচএসসি (HSC)';
      default:
        return studentClass;
    }
  }
}

// Teacher Controller
class TeacherController extends GetxController {
  final Dio _dio = Dio();
  
  var teachers = <Teacher>[].obs;
  var filteredTeachers = <Teacher>[].obs;
  var isLoading = false.obs;
  var totalCount = 0.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeachers();
  }

  Future<void> fetchTeachers() async {
    try {
      isLoading(true);
      final response = await _dio.get(
        'https://admin.examhero.xyz/api/v1/mcq-preparation/teachers/',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final teachersList = (data['teachers'] as List)
            .map((json) => Teacher.fromJson(json))
            .toList();
        
        teachers.assignAll(teachersList);
        filteredTeachers.assignAll(teachersList);
        totalCount.value = data['total_count'] ?? teachersList.length;
        
        print('Teachers loaded: ${teachers.length}');
      }
    } catch (e) {
      print('Error fetching teachers: $e');
      Get.snackbar(
        'Error',
        'Failed to load teachers. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  void searchTeachers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredTeachers.assignAll(teachers);
    } else {
      filteredTeachers.assignAll(
        teachers.where((teacher) =>
            teacher.name.toLowerCase().contains(query.toLowerCase()) ||
            teacher.instituteName.toLowerCase().contains(query.toLowerCase())
        ).toList(),
      );
    }
  }

  int get availableTeachersCount {
    return filteredTeachers.length; // In real app, you might want to check online status
  }

  Future<void> refreshTeachers() async {
    await fetchTeachers();
  }
}

// Main Teacher Panel Screen
class TeacherPanelScreen extends StatelessWidget {
  const TeacherPanelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TeacherController controller = Get.put(TeacherController());
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildSearchBar(searchController, controller),
                  const SizedBox(height: 20),
                  _buildStatsCards(controller),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _buildTeachersList(controller),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF7B68EE),
            Color(0xFF9370DB),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Teacher Panel',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Connect with Expert Educators',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(TextEditingController searchController, TeacherController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) => controller.searchTeachers(value),
        decoration: InputDecoration(
          hintText: 'Search by name or institution...',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Color(0xFF4A90E2),
            size: 24,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(TeacherController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => _buildStatCard(
              title: 'Total Teachers',
              count: controller.totalCount.value.toString(),
              icon: Icons.groups_rounded,
              color: Color(0xFF4A90E2),
            )),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Obx(() => _buildStatCard(
              title: 'Available Now',
              count: controller.availableTeachersCount.toString(),
              icon: Icons.wifi_rounded,
              color: Color(0xFF4CAF50),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTeachersList(TeacherController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: SpinKitPulse(
            color: Color(0xFF4A90E2),
            size: 50,
          ),
        );
      }

      if (controller.filteredTeachers.isEmpty) {
        return _buildEmptyState(controller);
      }

      return RefreshIndicator(
        onRefresh: controller.refreshTeachers,
        color: Color(0xFF4A90E2),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: controller.filteredTeachers.length,
          itemBuilder: (context, index) {
            return _buildTeacherCard(controller.filteredTeachers[index]);
          },
        ),
      );
    });
  }

  Widget _buildEmptyState(TeacherController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            controller.searchQuery.value.isEmpty
                ? 'No teachers available'
                : 'No teachers found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.searchQuery.value.isEmpty
                ? 'Please check back later'
                : 'Try adjusting your search',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: controller.refreshTeachers,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4A90E2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherCard(Teacher teacher) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigate to teacher detail or chat
          _showTeacherDetails(teacher);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildTeacherAvatar(teacher),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTeacherInfo(teacher),
              ),
              _buildTeacherActions(teacher),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherAvatar(Teacher teacher) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(0xFF4A90E2).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: teacher.fullProfileImageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: teacher.fullProfileImageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: Colors.grey[400],
                  ),
                ),
              )
            : Container(
                color: Color(0xFF4A90E2).withOpacity(0.1),
                child: Icon(
                  Icons.person_rounded,
                  size: 40,
                  color: Color(0xFF4A90E2),
                ),
              ),
      ),
    );
  }

  Widget _buildTeacherInfo(Teacher teacher) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                teacher.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF4A90E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'EXPERT',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.school_rounded,
              size: 16,
              color: Colors.grey[500],
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                teacher.instituteName,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Color(0xFF4A90E2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timeline_rounded,
                size: 14,
                color: Color(0xFF4A90E2),
              ),
              const SizedBox(width: 4),
              Text(
                'Experience: ${teacher.experience}',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4A90E2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeacherActions(Teacher teacher) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: () => _showTeacherDetails(teacher),
        icon: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Color(0xFF4A90E2),
          size: 20,
        ),
      ),
    );
  }

  void _showTeacherDetails(Teacher teacher) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _buildTeacherAvatar(teacher),
            const SizedBox(height: 16),
            Text(
              teacher.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              teacher.instituteName,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDetailChip(
                  label: teacher.displayClass,
                  icon: Icons.school_rounded,
                  color: Color(0xFF4A90E2),
                ),
                _buildDetailChip(
                  label: teacher.displayDepartment,
                  icon: Icons.category_rounded,
                  color: Color(0xFF4CAF50),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailChip(
              label: 'Experience: ${teacher.experience}',
              icon: Icons.timeline_rounded,
              color: Color(0xFFFF9800),
            ),
            const SizedBox(height: 24),
           
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDetailChip({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _startChatWithTeacher(Teacher teacher) {
    // Implement chat functionality
    Get.snackbar(
      'Chat',
      'Starting conversation with ${teacher.name}',
      backgroundColor: Color(0xFF4A90E2),
      colorText: Colors.white,
    );
  }
}
