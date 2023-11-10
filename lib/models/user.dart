final String tableUsers = 'users';

class UserFields {
  static final String urlAvatar = 'urlAvatar';

  static final List<String> values = [
    /// Add all fields
    id, username, email, password, age, gender, weight, height, watergoal
  ];

  static final String id = '_id';
  static final String username = 'username';
  static final String email = 'email';
  static final String password = 'password';
  static final String age = 'age';
  static final String gender = 'gender';
  static final String weight = 'weight';
  static final String height = 'height';
  static final String watergoal = 'watergoal';
}

class User {
  final int? id;
  final String username;
  final String email;
  final String password;
  final int? age;
  final String? gender;
  final int? weight;
  final int? height;
  final int? watergoal;
  final String? urlAvatar;

  const User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.age,
    this.gender,
    this.weight,
    this.height,
    this.watergoal,
    this.urlAvatar,
  });

  User copy({
    int? id,
    String? username,
    String? email,
    String? password,
    int? age,
    String? gender,
    int? weight,
    int? height,
    int? watergoal,
    String? urlAvatar,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        age: age ?? this.age,
        gender: gender ?? this.gender,
        weight: weight ?? this.weight,
        height: height ?? this.height,
        watergoal: watergoal ?? this.watergoal,
        urlAvatar: urlAvatar ?? this.urlAvatar,
      );

  static User fromJson(Map<String, Object?> json) => User(
    id: json[UserFields.id] as int?,
    username: json[UserFields.username] as String,
    email: json[UserFields.email] as String,
    password: json[UserFields.password] as String,
    age: json[UserFields.age] as int?,
    gender: json[UserFields.gender] as String?,
    weight: json[UserFields.weight] as int?,
    height: json[UserFields.height] as int?,
    watergoal: json[UserFields.watergoal] as int?,
    urlAvatar: json[UserFields.urlAvatar] as String?,
  );

  Map<String, Object?> toJson() => {
    UserFields.id: id,
    UserFields.username: username,
    UserFields.email: email,
    UserFields.password: password,
    UserFields.age: age,
    UserFields.gender: gender,
    UserFields.weight: weight,
    UserFields.height: height,
    UserFields.watergoal: watergoal,
    UserFields.urlAvatar: urlAvatar,
  };
}