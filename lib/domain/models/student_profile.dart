class StudentProfile {
  const StudentProfile({
    required this.studentId,
    required this.fullName,
    required this.email,
    required this.username,
    required this.gender,
    required this.dob,
    required this.contactNumber,
    required this.address,
    required this.enrollmentDate,
    required this.status,
  });

  final int studentId;
  final String fullName;
  final String email;
  final String username;
  final String gender;
  final String dob;
  final String contactNumber;
  final String address;
  final String enrollmentDate;
  final String status;
}
