class User {
  const User({
    required this.userId,
    required this.username,
    required this.email,
    required this.role,
    required this.status,
    this.teacherId,
    this.studentId,
  });

  final int userId;
  final String username;
  final String email;
  final String role;
  final String status;
  final int? teacherId;
  final int? studentId;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] as int? ?? json['userId'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      status: json['status'] as String? ?? '',
      teacherId: json['teacher_id'] as int? ?? json['teacherId'] as int?,
      studentId: json['student_id'] as int? ?? json['studentId'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'username': username,
    'email': email,
    'role': role,
    'status': status,
    'teacher_id': teacherId,
    'student_id': studentId,
  };
}
