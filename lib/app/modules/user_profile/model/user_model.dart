

class UserModel {
  final String? id;
  final String? employeeId;
  final dynamic profileImage;
  final String? name;
  final String? email;
  final double? hourlyRate;
  final String? role;
  final String? status;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    this.employeeId,
    this.profileImage,
    this.name,
    this.email,
    this.hourlyRate,
    this.role,
    this.status,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    employeeId: json["employeeId"],
    profileImage: json["profileImage"],
    name: json["name"],
    email: json["email"],
    hourlyRate: json["hourlyRate"]?.toDouble(),
    role: json["role"],
    status: json["status"],
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employeeId": employeeId,
    "profileImage": profileImage,
    "name": name,
    "email": email,
    "hourlyRate": hourlyRate,
    "role": role,
    "status": status,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
