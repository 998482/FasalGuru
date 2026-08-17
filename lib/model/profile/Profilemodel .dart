class ProfileModel {
  final String uid;
  final String username;
  final String phoneNumber;
  final String village;
  final String state;
  final String? imageUrl;
  final int updatedAt;

  ProfileModel({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.village,
    required this.state,
    this.imageUrl,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "username": username,
      "phoneNumber": phoneNumber,
      "village": village,
      "state": state,
      "imageUrl": imageUrl,
      "updatedAt": updatedAt,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      uid: map["uid"] ?? "",
      username: map["username"] ?? "",
      phoneNumber: map["phoneNumber"] ?? "",
      village: map["village"] ?? "",
      state: map["state"] ?? "",
      imageUrl: map["imageUrl"],
      updatedAt: map["updatedAt"] ?? 0,
    );
  }

  ProfileModel copyWith({
    String? username,
    String? phoneNumber,
    String? village,
    String? state,
    String? imageUrl,
  }) {
    return ProfileModel(
      uid: uid,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      village: village ?? this.village,
      state: state ?? this.state,
      imageUrl: imageUrl ?? this.imageUrl,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }
}