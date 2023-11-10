final String tableWaterIntake = 'waterintake';

class WaterIntakeFields {
  static final String tableWaterIntake = 'waterintake';


  static final List<String> values = [
    id, waterAmount, time, editedTime, user
  ];

  static final String id = '_id';
  static final String waterAmount = "waterAmount";
  static final String time = 'time';
  static final String editedTime = 'editedTime';
  static final String user = 'user';
}

class WaterIntake {
  final int? id;
  final int waterAmount;
  final DateTime createdTime;
  final DateTime editedTime;
  final String? user;

  const WaterIntake({
    this.id,
    required this.waterAmount,
    required this.createdTime,
    required this.editedTime,
    this.user,
  });

  WaterIntake copy({ // copywith defualt is copy
    int? id,
    int? waterAmount,
    DateTime? createdTime,
    DateTime? editedTime,
    String? user,
  }) =>
      WaterIntake(
        id: id ?? this.id,
        waterAmount: waterAmount ?? this.waterAmount,
        createdTime: createdTime ?? this.createdTime,
        editedTime: editedTime ?? this.editedTime,
        user: user ?? this.user,
      );

  static WaterIntake fromJson(Map<String, Object?> json) => WaterIntake(
    id: json[WaterIntakeFields.id] as int?,
    waterAmount: json[WaterIntakeFields.waterAmount] as int,
    createdTime: DateTime.parse(json[WaterIntakeFields.time] as String),
    editedTime: DateTime.parse(json[WaterIntakeFields.editedTime] as String),
    user: json[WaterIntakeFields.user] as String?,
  );

  static WaterIntake fromMap(Map<String, dynamic> map) {
    return WaterIntake(
      id: map[WaterIntakeFields.id],
      waterAmount: map[WaterIntakeFields.waterAmount],
      createdTime: DateTime.parse(map[WaterIntakeFields.time]),
      editedTime: DateTime.parse(map[WaterIntakeFields.editedTime]),
      user: map[WaterIntakeFields.user],
    );
  }


  Map<String, Object?> toJson() => {
    WaterIntakeFields.id: id,
    WaterIntakeFields.waterAmount: waterAmount,
    WaterIntakeFields.time: createdTime.toIso8601String(),
    WaterIntakeFields.editedTime: editedTime.toIso8601String(),
    WaterIntakeFields.user: user,
  };
}