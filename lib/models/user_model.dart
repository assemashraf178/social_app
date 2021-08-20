class UserModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? image;
  String? cover;
  String? bio;
  bool? isVerificated;

  UserModel({
    this.email,
    this.name,
    this.phone,
    this.uId,
    this.image,
    this.cover,
    this.bio,
    this.isVerificated,
  });

  UserModel.fromJson(Map<String, dynamic>? json) {
    email = json!['email'];
    name = json['name'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    isVerificated = json['isVerificated'];
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'uId': uId,
      'image': image,
      'cover': cover,
      'bio': bio,
      'isVerificated': isVerificated,
    };
  }
}
