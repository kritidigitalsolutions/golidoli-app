class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<String> interests;
  final String profileImage;
  final bool profileComplete;
  final String role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.interests,
    required this.profileImage,
    required this.profileComplete,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"]?.toString() ?? json["_id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
      phone: json["phone"]?.toString() ?? "",
      interests: List<String>.from(json["interests"] ?? []),
      profileImage: json["profileImage"]?.toString() ??
          json["photoUrl"]?.toString() ??
          json["avatar"]?.toString() ??
          json["image"]?.toString() ??
          "",
      profileComplete: json["profileComplete"] == true,
      role: json["role"]?.toString() ?? "USER",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "interests": interests,
      "profileImage": profileImage,
      "profileComplete": profileComplete,
      "role": role,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    List<String>? interests,
    String? profileImage,
    bool? profileComplete,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      interests: interests ?? this.interests,
      profileImage: profileImage ?? this.profileImage,
      profileComplete: profileComplete ?? this.profileComplete,
      role: role ?? this.role,
    );
  }
}
