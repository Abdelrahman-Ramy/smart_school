class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final String? role;
  final String? phone;
  final String? address;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.role,
    this.phone,
    this.address,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      phone: json['phone'],
      address: json['address'],

      isActive:
          json['is_active'] == true ||
          json['is_active'] == 1 ||
          json['is_active'] == "true",

      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
