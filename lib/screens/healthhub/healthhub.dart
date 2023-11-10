import 'package:flutter/material.dart';
import 'package:foodsnap/screens/healthhub/BMICalculator.dart';
import 'package:foodsnap/screens/healthhub/CalorieCalculator.dart';
import 'package:foodsnap/screens/healthhub/waterIntake.dart';
import 'package:foodsnap/screens/healthhub/watergoal_input_page.dart';
import 'package:foodsnap/screens/locator/locator.dart';
import 'package:foodsnap/screens/profile/user_profile.dart';
import 'package:foodsnap/screens/recipes/recipes.dart';
import 'package:foodsnap/screens/diary/diary.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:foodsnap/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodsnap/models/user.dart';

class HealthHubPage extends StatefulWidget {
  @override
  _HealthHubPageState createState() => _HealthHubPageState();
}

class _HealthHubPageState extends State<HealthHubPage> {
  int _currentIndex = 2;
  String _username = "";

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    setState(() {
      _username = storedUsername ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'HealthHub',
          style: TextStyle(
              color: Colors.white,
              fontFamily: "SegoeUIBold"
          ),
        ),
        leading: IconButton(
            onPressed: () {
              showModalBottomSheet(context: context, builder: (context) => Services());
            },
            icon: Icon(Icons.sort, size: 35, color: Color(0xFFFFFFFF))
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(context: context, builder: (context) => UserProfilePage(), isScrollControlled: true);
            },
            child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[100],
                child: Icon(Icons.person, size: 20, color: Color(0xFF707070))
            ),
          ),
          SizedBox(width: 10,)
        ],
        centerTitle: true,
        //backgroundColor: Color(0xFFF8F8F9),
        //backgroundColor: Color(0xFFf7f7f7),
        backgroundColor: Color(0xFF00E708),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BMICalculator(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF9C4AFF), Color(0xFF6800E8)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 175,
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.line_weight, color: Colors.white,),
                                SizedBox(width: 5,),
                                Text(
                                  "BMI Calculator",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFFFFF),
                                    fontFamily: "SegoeUIBold"
                                  ),
                                ),
                              ],
                            ),
                            Text("Calculate your BMI Precisely",
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontFamily: "SegoeUIBold"
                                )),
                            // Row(
                            //   children: [
                            //     Spacer(),
                            //     Image.asset(
                            //       "assets/images/weighingscale.png",
                            //       height: 100,
                            //       width: 100,
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Image.asset(
                            "assets/images/weighingscale.png",
                            height: 120,
                            width: 120,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalorieCalculator(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFDB4B), Color(0xFFFF943F)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 175,
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.local_fire_department, color: Colors.white,),
                                SizedBox(width: 5,),
                                Text(
                                  "Calorie Calculator",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFFFFF),
                                    fontFamily: "SegoeUIBold"
                                  ),
                                ),
                              ],
                            ),
                            Text("Calculate and track your calories precisely",
                                style: TextStyle(color: Color(0xFFFFFFFF), fontFamily: "SegoeUIBold")),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Image.asset(
                            "assets/images/flame.png",
                            height: 105,
                            width: 105,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  final User? user = await UserDatabase.instance.getUserByUsername(_username);

                  if (user != null) {
                    if (user.watergoal == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WaterIntakeFormPage(user: user),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WaterIntakePage(),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF61A9FF), Color(0xFF006CC2)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 175,
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.water_drop, color: Colors.white,),
                                SizedBox(width: 5,),
                                Text(
                                  "Daily Water Intake",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFFFFF),
                                      fontFamily: "SegoeUIBold"
                                  ),
                                ),
                              ],
                            ),
                            Text("Track how much water you drank in a day",
                                style: TextStyle(color: Color(0xFFFFFFFF), fontFamily: "SegoeUIBold")),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Image.asset(
                            "assets/images/water.png",
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Color(0xFFf9f9f8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0 ? Color(0xFF5c7aff) : Color(0xFF002766),
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
                //Navigator.pushReplacementNamed(context, "/diary");
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => DiaryPage(),
                  transitionDuration: Duration(milliseconds: 0),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                ));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.receipt_long,
                color: _currentIndex == 1 ? Color(0xFF5c7aff) : Color(0xFF002766),
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
                //Navigator.pushReplacementNamed(context, Routes.search);
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => RecipePage(),
                  transitionDuration: Duration(milliseconds: 0),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                ));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.health_and_safety,
                color: _currentIndex == 2 ? Color(0xFF5c7aff) : Color(0xFF002766),
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  _currentIndex = 2;
                });
                //Navigator.pushReplacementNamed(context, Routes.favorites);
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => HealthHubPage(),
                  transitionDuration: Duration(milliseconds: 0),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                ));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.map,
                color: _currentIndex == 3 ? Color(0xFF5c7aff) : Color(0xFF002766),
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  _currentIndex = 3;
                });
                //Navigator.pushNamed(context, Routes.addNote).then((_) => _refreshNotes());
                //Navigator.pushReplacementNamed(context, '/user_profile');
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          LocatorPage(),
                      transitionDuration: Duration(milliseconds: 0),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
