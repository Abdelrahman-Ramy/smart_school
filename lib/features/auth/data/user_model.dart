class UserModel {
  final int? id;
  final String? firebaseUid; 
  final String? name;
  final String? email;
  final String? password;
  final String? role;
  final String? phone;
  final String? address;
  final String? gender;
  final String? dob;
  final String? specialization;
  final String? grade;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.id,
    this.firebaseUid,
    this.name,
    this.email,
    this.password,
    this.role,
    this.phone,
    this.address,
    this.gender,
    this.dob,
    this.specialization,
    this.grade,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firebaseUid: json['firebase_uid'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      phone: json['phone'],
      address: json['address'],
      gender: json['gender'],
      dob: json['dob'],
      specialization: json['specialization'],
      grade: json['grade'],

      isActive:
          json['is_active'] == true ||
          json['is_active'] == 1 ||
          json['is_active'] == "true",

      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
