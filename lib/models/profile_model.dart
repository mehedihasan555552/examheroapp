class Profile {
  int? id, hsc_exam_year;
  ProfileUser? user;
  String? full_name,
      email,
      slug,
      institute,
      profile_image,
      referral_code,
      package,
      student_class,
      department,
      registered_datetime,
      updated_datetime;

  Profile();
  
  Profile.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      
      // Handle user object safely
      if (json['user'] != null) {
        user = ProfileUser.fromJson(json['user']);
      }
      
      full_name = json['full_name']?.toString();
      email = json['email']?.toString();
      slug = json['slug']?.toString();
      profile_image = json['profile_image']?.toString();
      referral_code = json['referral_code']?.toString();
      
      // Handle package field safely (might be int or string)
      package = json['package']?.toString();
      
      institute = json['institute']?.toString();
      
      // Handle numeric fields safely
      if (json['hsc_exam_year'] != null) {
        hsc_exam_year = int.tryParse(json['hsc_exam_year'].toString());
      }
      
      // New fields for student class and department
      student_class = json['student_class']?.toString();
      department = json['department']?.toString();
      
      registered_datetime = json['registered_datetime']?.toString();
      updated_datetime = json['updated_datetime']?.toString();
    } catch (e) {
      print('Error parsing Profile JSON: $e');
      // Set default values on error
      _setDefaults();
    }
  }

  void _setDefaults() {
    id = null;
    user = null;
    full_name = null;
    email = null;
    slug = null;
    profile_image = null;
    referral_code = null;
    package = null;
    institute = null;
    hsc_exam_year = null;
    student_class = null;
    department = null;
    registered_datetime = null;
    updated_datetime = null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user?.toJson(),
        'full_name': full_name,
        'email': email,
        'slug': slug,
        'profile_image': profile_image,
        'referral_code': referral_code,
        'package': package,
        'institute': institute,
        'hsc_exam_year': hsc_exam_year,
        'student_class': student_class,
        'department': department,
        'registered_datetime': registered_datetime,
        'updated_datetime': updated_datetime,
      };

  // Helper methods for display
  String get displayName => full_name ?? 'Unknown User';
  String get displayInstitute => institute ?? 'No Institute';
  String get displayEmail => email ?? 'No Email';
  String get displayPhone => user?.phone ?? 'No Phone';
  
  String get displayClass {
    switch (student_class?.toLowerCase()) {
      case 'ssc':
        return 'এসএসসি (SSC)';
      case 'hsc':
        return 'এইচএসসি (HSC)';
      default:
        return student_class ?? 'Not specified';
    }
  }
  
  String get displayDepartment {
    switch (department?.toLowerCase()) {
      case 'science':
        return 'বিজ্ঞান (Science)';
      case 'arts':
        return 'মানবিক (Arts)';
      case 'commerce':
        return 'বাণিজ্য (Commerce)';
      default:
        return department ?? 'Not specified';
    }
  }
  
  // Validation helpers
  bool get hasValidEmail => email != null && email!.isNotEmpty && email!.contains('@');
  bool get hasValidPhone => user?.phone != null && user!.phone!.isNotEmpty;
  bool get hasProfileImage => profile_image != null && profile_image!.isNotEmpty;
  bool get isProfileComplete => 
      full_name != null && 
      email != null && 
      institute != null && 
      student_class != null && 
      department != null;

  // Copy method for updates
  Profile copyWith({
    int? id,
    ProfileUser? user,
    String? full_name,
    String? email,
    String? slug,
    String? institute,
    String? profile_image,
    String? referral_code,
    String? package,
    String? student_class,
    String? department,
    int? hsc_exam_year,
    String? registered_datetime,
    String? updated_datetime,
  }) {
    final newProfile = Profile();
    newProfile.id = id ?? this.id;
    newProfile.user = user ?? this.user;
    newProfile.full_name = full_name ?? this.full_name;
    newProfile.email = email ?? this.email;
    newProfile.slug = slug ?? this.slug;
    newProfile.institute = institute ?? this.institute;
    newProfile.profile_image = profile_image ?? this.profile_image;
    newProfile.referral_code = referral_code ?? this.referral_code;
    newProfile.package = package ?? this.package;
    newProfile.student_class = student_class ?? this.student_class;
    newProfile.department = department ?? this.department;
    newProfile.hsc_exam_year = hsc_exam_year ?? this.hsc_exam_year;
    newProfile.registered_datetime = registered_datetime ?? this.registered_datetime;
    newProfile.updated_datetime = updated_datetime ?? this.updated_datetime;
    return newProfile;
  }

  @override
  String toString() {
    return 'Profile{id: $id, full_name: $full_name, email: $email, institute: $institute, student_class: $student_class, department: $department}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ProfileUser {
  int? uid;
  String? phone;
  bool? active;
  String? student_class;
  String? department;

  ProfileUser();
  
  ProfileUser.fromJson(Map<String, dynamic> json) {
    try {
      // Handle uid safely (might be int or string)
      if (json['uid'] != null) {
        uid = int.tryParse(json['uid'].toString());
      }
      
      phone = json['phone']?.toString();
      
      // Handle boolean field safely
      if (json['active'] != null) {
        active = json['active'] is bool 
            ? json['active'] 
            : json['active'].toString().toLowerCase() == 'true';
      }
      
      // Additional fields from User model
      student_class = json['student_class']?.toString();
      department = json['department']?.toString();
    } catch (e) {
      print('Error parsing ProfileUser JSON: $e');
      // Set default values on error
      uid = null;
      phone = null;
      active = null;
      student_class = null;
      department = null;
    }
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'phone': phone,
        'active': active,
        'student_class': student_class,
        'department': department,
      };

  // Helper methods
  String get displayPhone => phone ?? 'No Phone';
  bool get isActive => active ?? false;
  
  String get displayClass {
    switch (student_class?.toLowerCase()) {
      case 'ssc':
        return 'এসএসসি (SSC)';
      case 'hsc':
        return 'এইচএসসি (HSC)';
      default:
        return student_class ?? 'Not specified';
    }
  }
  
  String get displayDepartment {
    switch (department?.toLowerCase()) {
      case 'science':
        return 'বিজ্ঞান (Science)';
      case 'arts':
        return 'মানবিক (Arts)';
      case 'commerce':
        return 'বাণিজ্য (Commerce)';
      default:
        return department ?? 'Not specified';
    }
  }

  // Validation helpers
  bool get hasValidPhone => phone != null && phone!.isNotEmpty;
  bool get hasValidUid => uid != null && uid! > 0;

  // Copy method for updates
  ProfileUser copyWith({
    int? uid,
    String? phone,
    bool? active,
    String? student_class,
    String? department,
  }) {
    final newUser = ProfileUser();
    newUser.uid = uid ?? this.uid;
    newUser.phone = phone ?? this.phone;
    newUser.active = active ?? this.active;
    newUser.student_class = student_class ?? this.student_class;
    newUser.department = department ?? this.department;
    return newUser;
  }

  @override
  String toString() {
    return 'ProfileUser{uid: $uid, phone: $phone, active: $active, student_class: $student_class, department: $department}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileUser && runtimeType == other.runtimeType && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}
