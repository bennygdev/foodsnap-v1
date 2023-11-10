import 'package:flutter/material.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:foodsnap/db/waterintake_database.dart';
import 'package:foodsnap/models/user.dart';
import 'package:foodsnap/models/waterintake.dart';
import 'package:foodsnap/screens/healthhub/add_water_intake.dart';
import 'package:foodsnap/screens/healthhub/edit_water_intake.dart';
import 'package:foodsnap/screens/healthhub/editwatergoal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class WaterIntakePage extends StatefulWidget {
  const WaterIntakePage({Key? key}) : super(key: key);

  @override
  State<WaterIntakePage> createState() => _WaterIntakePageState();
}

class _WaterIntakePageState extends State<WaterIntakePage> {
  User? loggedInUser;
  String _username = "";
  late Future<List<WaterIntake>> _waterIntakeFuture = Future.value([]);
  int _totalWaterIntakeToday = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails().then((_) {
      _refreshWaterIntakes();
    });
  }

  Future<void> _refreshWaterIntakes() async {
    final waterIntakes = await WaterIntakeDatabase.instance.readAllWaterIntake();
    final filteredWaterIntakes = waterIntakes.where((waterAmt) => waterAmt.user == _username).toList();

    // Calculate total water intake for today
    final today = DateTime.now();
    final todayWaterIntakes = filteredWaterIntakes.where((waterIntake) {
      final createdDate = waterIntake.createdTime;
      return createdDate.year == today.year &&
          createdDate.month == today.month &&
          createdDate.day == today.day;
    });

    final totalWaterIntakeToday = todayWaterIntakes.fold<int>(0, (sum, waterIntake) {
      return sum + waterIntake.waterAmount;
    });

    setState(() {
      _waterIntakeFuture = Future.value(filteredWaterIntakes);
      _totalWaterIntakeToday = totalWaterIntakeToday;
    });
  }


  Future<void> _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');

    if (storedUsername != null) {
      User? user = await UserDatabase.instance.getUserByUsername(storedUsername);
      if (user != null) {
        setState(() {
          loggedInUser = user;
          _username = storedUsername ?? '';
        });
      }
    }
  }

  Future<void> _editWaterIntake(WaterIntake waterIntake) async {
    final editedWaterIntake = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditWaterIntakePage(waterintake: waterIntake),
      ),
    ) as WaterIntake?;

    if (editedWaterIntake != null) {
      await WaterIntakeDatabase.instance.update(editedWaterIntake);
      _refreshWaterIntakes();
    }
  }

  Future<void> _deleteWaterIntake(WaterIntake waterintake) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this intake?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await WaterIntakeDatabase.instance.delete(waterintake.id!);
      _refreshWaterIntakes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daily Water Intake",
          style: TextStyle(
            color: Colors.black
          )
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                    color: Color(0xFF003cc0)
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Color(0xFF1b51c7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Goal:",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                  ),
                                ),
                                if (loggedInUser != null) ...[
                                  Text(
                                    '${loggedInUser!.watergoal.toString()}mL',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "SegoeUIBold",
                                      fontSize: 20
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xFF1b51c7),
                          child: IconButton(
                            onPressed: () async {
                              User? updatedUser = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditWaterGoalPage(user: loggedInUser!),
                                ),
                              );

                              if (updatedUser != null) {
                                setState(() {
                                  loggedInUser = updatedUser;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    if (loggedInUser != null) ...[
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Container(
                          height: 200,
                          width: 200,
                          child: CustomPaint(
                            size: Size(25, 25),
                            painter: CircleProgressBar(
                              progress: (_totalWaterIntakeToday?.toDouble() ?? 0.0) / (loggedInUser?.watergoal?.toDouble() ?? 1.0),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${(loggedInUser?.watergoal ?? 0) - _totalWaterIntakeToday} mL',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontFamily: "SegoeUIBold",
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    (_totalWaterIntakeToday > (loggedInUser?.watergoal ?? 0))
                                        ? 'Good job!'
                                        : 'left to drink',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: "SegoeUI"
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Current intake:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "SegoeUI"
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                              '$_totalWaterIntakeToday/${loggedInUser!.watergoal.toString()} ml',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "SegoeUIBold",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Text(
                'Weather',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: "SegoeUI"
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFF003cc0),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Icon(
                      Icons.water,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 18,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "It's always hot!",
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: "SegoeUIBold"
                        ),
                      ),
                      SizedBox(height: 15,),
                      Text(
                        "Don't forget to take your water \nbottle with you.",
                        style: TextStyle(
                          fontFamily: "SegoeUI"
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Text(
                'Your water intakes',
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: "SegoeUI"
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: FutureBuilder<List<WaterIntake>>(
                future: _waterIntakeFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error loading water intakes'),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return Column(
                      children: [
                        SizedBox(height: 20),
                        Center(
                          child: Text('No water intakes found. Start drinking today!'),
                        ),
                        SizedBox(height: 50),
                      ],
                    );
                  } else {
                    final waterintakes = snapshot.data!;
                    final reversedWaterIntakes = List.from(waterintakes.reversed);
                    int oldestIntakeTitle = waterintakes.length;

                    return SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: reversedWaterIntakes.length,
                        itemBuilder: (context, index) {
                          final waterintake = reversedWaterIntakes[index];
                          final createdDate = DateFormat('yyyy-MM-dd').format(waterintake.createdTime);
                          final editedDate = DateFormat('yyyy-MM-dd').format(waterintake.editedTime);
                          final intakeTitle = oldestIntakeTitle - index;

                          return GestureDetector(
                            onTap: () {
                              _editWaterIntake(waterintake);
                            },
                            onLongPress: () => _deleteWaterIntake(waterintake),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  height: 90,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFC4C4C4),
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Icon(
                                            Icons.water_drop,
                                            color: Color(0xFF707070)
                                          ),
                                        ),
                                        Expanded(
                                          child: ListTile(
                                            title: Text(
                                              'Water Intake ${intakeTitle.toString()}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  '${waterintake.waterAmount.toString()} ml',
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                                Text(
                                                  'Drank on ${createdDate}',
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              _editWaterIntake(waterintake);
                                            },
                                            //onLongPress: () => _deleteNote(note),

                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                if(index != waterintakes.length -1)
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                                    color: Colors.grey.withOpacity(0.2), // Customize the line color
                                    height: 1.0,
                                  ),
                                SizedBox(height: 5),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddWaterIntakePage()
          )).then((_) => _refreshWaterIntakes());
        },
        child: Icon(Icons.add, color: Color(0xFFFFFFFF)),
        backgroundColor: Color(0xFF1b51c7),
      ),
    );
  }
}

class CircleProgressBar extends CustomPainter {
  final double progress;

  CircleProgressBar({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF1b51c7)// Grey background color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw grey circle as background
    canvas.drawCircle(center, radius, paint);

    final progressPaint = Paint()
      ..color = Color(0xFFFFFFFF) // Blue progress color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11;

    // Calculate the sweep angle based on progress
    final sweepAngle = 360 * progress;

    // Draw the progress arc
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -90 * (3.14159265359 / 180),
        (sweepAngle * (3.14159265359 / 180)), false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}