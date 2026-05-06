class AdminCredential {
  final String email;
  final String password;

  AdminCredential({required this.email, required this.password});

  factory AdminCredential.fromJson(Map<String, dynamic> json) {
    return AdminCredential(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class EmailData {
  final List<AdminCredential> adminCredentials;

  EmailData({required this.adminCredentials});

  factory EmailData.fromJson(Map<String, dynamic> json) {
    return EmailData(
      adminCredentials:
          (json['adminCredentials'] as List<dynamic>?)
              ?.map((e) => AdminCredential.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adminCredentials': adminCredentials.map((e) => e.toJson()).toList(),
    };
  }
}
