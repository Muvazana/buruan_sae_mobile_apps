class UserModel {
  int user_id;
  String name;
  String email;
  String password;
  String? image;
  String? created_at;
  String? updated_at;

  UserModel({
    required this.user_id,
    required this.name,
    required this.password,
    required this.email,
    this.image,
    this.created_at,
    this.updated_at,
  });

  factory UserModel.formJson(Map<String, dynamic> json) {
    return UserModel(
      user_id: json['user_id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      image: json['image'] as String?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
    );
  }

  Map<String, Object> toMap() => {
        'user_id': user_id,
        'name': name,
        'email': email,
        'password': password,
        'image': image ?? '',
        'created_at': created_at ?? '',
        'updated_at': updated_at ?? '',
      };
}
