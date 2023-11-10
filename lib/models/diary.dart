final String tableDiary = 'diary';

class DiaryFields {
  static final String tableDiary = 'diary';
  static final String imagePath = 'imagePath';


  static final List<String> values = [
    id, title, comment, calorie, time, editedTime, user
  ];

  static final String id = '_id';
  static final String title = 'title';
  static final String comment = 'comment';
  static final String calorie = 'calorie';
  static final String time = 'time';
  static final String editedTime = 'editedTime';
  static final String user = 'user';
}

class Diary {
  final int? id;
  final String title;
  final String comment;
  final int calorie;
  final String? imagePath;
  final DateTime createdTime;
  final DateTime editedTime;
  final String? user;

  const Diary({
    this.id,
    required this.title,
    required this.comment,
    required this.calorie,
    this.imagePath,
    required this.createdTime,
    required this.editedTime,
    this.user,
  });

  Diary copy({
    int? id,
    String? title,
    String? comment,
    int? calorie,
    String? imagePath,
    DateTime? createdTime,
    DateTime? editedTime,
    String? user,
  }) =>
      Diary(
        id: id ?? this.id,
        title: title ?? this.title,
        comment: comment ?? this.comment,
        calorie: calorie ?? this.calorie,
        imagePath: imagePath ?? this.imagePath,
        createdTime: createdTime ?? this.createdTime,
        editedTime: editedTime ?? this.editedTime,
        user: user ?? this.user,
      );

  static Diary fromJson(Map<String, Object?> json) => Diary(
    id: json[DiaryFields.id] as int?,
    title: json[DiaryFields.title] as String,
    comment: json[DiaryFields.comment] as String,
    calorie: json[DiaryFields.calorie] as int,
    imagePath: json[DiaryFields.imagePath] as String?,
    createdTime: DateTime.parse(json[DiaryFields.time] as String),
    editedTime: DateTime.parse(json[DiaryFields.editedTime] as String),
    user: json[DiaryFields.user] as String?,
  );

  static Diary fromMap(Map<String, dynamic> map) {
    return Diary(
      id: map[DiaryFields.id],
      title: map[DiaryFields.title],
      comment: map[DiaryFields.comment],
      calorie: map[DiaryFields.calorie],
      imagePath: map[DiaryFields.imagePath],
      createdTime: DateTime.parse(map[DiaryFields.time]),
      editedTime: DateTime.parse(map[DiaryFields.editedTime]),
      user: map[DiaryFields.user],
    );
  }


  Map<String, Object?> toJson() => {
    DiaryFields.id: id,
    DiaryFields.title: title,
    DiaryFields.comment: comment,
    DiaryFields.calorie: calorie,
    DiaryFields.imagePath: imagePath,
    DiaryFields.time: createdTime.toIso8601String(),
    DiaryFields.editedTime: editedTime.toIso8601String(),
    DiaryFields.user: user,
  };
}