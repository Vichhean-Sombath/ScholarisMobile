import '../../domain/models/student_profile.dart';

class StudentProfileDto {
  const StudentProfileDto({
    required this.studentId,
    this.firstName,
    this.lastName,
    this.fullName,
    this.dob,
    this.gender,
    this.contactNumber,
    this.address,
    this.enrollmentDate,
    this.status,
    this.user,
  });

  final int studentId;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? dob;
  final String? gender;
  final String? contactNumber;
  final String? address;
  final String? enrollmentDate;
  final String? status;
  final UserInfoDto? user;

  factory StudentProfileDto.fromJson(Map<String, dynamic> json) {
    return StudentProfileDto(
      studentId: json['studentId'] as int? ?? 0,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      fullName: json['fullName'] as String?,
      dob: json['dob'] as String?,
      gender: json['gender'] as String?,
      contactNumber: json['contactNumber'] as String?,
      address: json['address'] as String?,
      enrollmentDate: json['enrollmentDate'] as String?,
      status: json['status'] as String?,
      user: json['user'] == null
          ? null
          : UserInfoDto.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  StudentProfile toDomain() {
    return StudentProfile(
      studentId: studentId,
      fullName: fullName ?? '${firstName ?? ''} ${lastName ?? ''}'.trim(),
      email: user?.email ?? '',
      username: user?.username ?? '',
      gender: gender ?? '',
      dob: dob ?? '',
      contactNumber: contactNumber ?? '',
      address: address ?? '',
      enrollmentDate: enrollmentDate ?? '',
      status: status ?? '',
    );
  }
}

class UserInfoDto {
  const UserInfoDto({this.userId, this.username, this.email, this.status, this.lastLoginAt});

  final int? userId;
  final String? username;
  final String? email;
  final String? status;
  final String? lastLoginAt;

  factory UserInfoDto.fromJson(Map<String, dynamic> json) {
    return UserInfoDto(
      userId: json['userId'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      status: json['status'] as String?,
      lastLoginAt: json['lastLoginAt'] as String?,
    );
  }
}
