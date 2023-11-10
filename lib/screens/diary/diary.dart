import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodsnap/screens/healthhub/BMICalculator.dart';
import 'package:foodsnap/screens/healthhub/CalorieCalculator.dart';
import 'package:foodsnap/screens/healthhub/calorie_input_page.dart';
import 'package:foodsnap/screens/healthhub/healthhub.dart';
import 'package:foodsnap/screens/locator/locator.dart';
import 'package:foodsnap/screens/profile/user_profile.dart';
import 'package:foodsnap/screens/recipes/recipes.dart';
import 'package:foodsnap/services.dart';
import 'package:intl/intl.dart';
import 'package:foodsnap/db/diary_database.dart';
import 'package:foodsnap/models/diary.dart';
import 'package:foodsnap/screens/diary/add_diary_page.dart';
import 'package:foodsnap/screens/diary/edit_diary_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodsnap/models/user.dart';
import 'package:foodsnap/db/user_database.dart';
import 'dart:io';

class DiaryPage extends StatefulWidget {
  final String? imagePath;

  const DiaryPage({Key? key, this.imagePath})
      : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  User? loggedInUser;
  int _currentIndex = 0;
  late Future<List<Diary>> _diaryFuture = Future.value([]);
  String _username = "";
  String? _currentCategory;
  int _totalCaloriesToday = 0;
  double _maintainWeightCalories = 0.0;

  @override
  void initState() {
    super.initState();

    _loadUsername().then((_) {
      _refreshDiary();
      _fetchUserDetails();
    });
  }

  Future<void> _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');

    if (storedUsername != null) {
      User? user = await UserDatabase.instance.getUserByUsername(storedUsername);
      setState(() {
        loggedInUser = user;
        if (user != null) {
          calculateCalories(user);
        }
      });
    }
  }

  void calculateCalories(User user) {
    // Calculate BMR based on user's details
    double bmr;
    if (user.gender == 'Male') {
      if (user.weight != null && user.height != null && user.age != null) {
        bmr = 88.362 + (13.397 * user.weight!.toDouble()) + (4.799 * user.height!.toDouble()) - (5.677 * user.age!.toDouble());
      } else {
        return;
      }
    } else {
      if (user.weight != null && user.height != null && user.age != null) {
        bmr = 447.593 + (9.247 * user.weight!.toDouble()) + (3.098 * user.height!.toDouble()) - (4.330 * user.age!.toDouble());
      } else {
        // Handle null values gracefully or can set some default values or show an error message.
        return;
      }
    }

    double calorieNeeds = bmr * 1.2;

    setState(() {
      _maintainWeightCalories = calorieNeeds;
      print(_maintainWeightCalories);
    });
  }

  Future<void> _refreshDiary() async {
    final diaries = await DiaryDatabase.instance.readAllDiary();
    final filteredDiaries = diaries.where((diary) => diary.user == _username).toList();

    final today = DateTime.now();
    final todayDiaries = filteredDiaries.where((diary) {
      final createdDate = diary.createdTime;
      return createdDate.year == today.year &&
          createdDate.month == today.month &&
          createdDate.day == today.day;
    });

    final totalCaloriesToday = todayDiaries.fold<int>(0, (sum, diary) {
      return sum + diary.calorie;
    });

    setState(() {
      _diaryFuture = Future.value(filteredDiaries);
      _totalCaloriesToday = totalCaloriesToday;
    });
  }

  String categorizeDiary(Diary diary) {
    final currentDate = DateTime.now();
    final createdDate = diary.createdTime;

    if (currentDate.year == createdDate.year &&
        currentDate.month == createdDate.month &&
        currentDate.day == createdDate.day) {
      return 'Today';
    } else if (currentDate.isAfter(createdDate)) {
      final daysDifference = currentDate.difference(createdDate).inDays;

      if (daysDifference <= 7) {
        return 'Last 7 Days';
      } else if (daysDifference <= 30) {
        return 'Last 30 Days';
      }
    }

    return 'Older';
  }

  Future<void> _deleteDiary(Diary diary) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this diary?'),
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
      await DiaryDatabase.instance.delete(diary.id!);
      _refreshDiary();
    }
  }

  Future<void> _editDiary(Diary diary) async {
    final editedDiary = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDiaryPage(diary: diary),
      ),
    ) as Diary?;

    if (editedDiary != null) {
      await DiaryDatabase.instance.update(editedDiary);
      _refreshDiary();
    }
  }

  Future<void> _clearAllDiary() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Clear All'),
        content: const Text('Are you sure you want to clear all diaries?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DiaryDatabase.instance.deleteAllDiaryForUser(_username);
      _refreshDiary();
    }
  }

  Future<void> _loadUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    setState(() {
      _username = storedUsername ?? '';
    });
  }

  void _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'username', '');
    setState(() {
      _username = '';
    });
    Navigator.pushReplacementNamed(
        context, '/login');
  }

  Widget _buildImageWidget(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Image(
        image: AssetImage(imagePath),
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Diary',
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
        backgroundColor: Color(0xFF2B9DFF),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.grey[300],
            //   ),
            //   width: double.infinity,
            //   height: 60,
            // ),
            Container(
                decoration: BoxDecoration(
                  color: Color(0xFF3A0094),
                ),
                height: 150,
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, $_username!',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "SegoeUIBold",
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "View your entries and health",
                            style: TextStyle(
                              fontFamily: "SegoeUIBold",
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>
                                          CalorieCalculator(),
                                      transitionDuration: Duration(milliseconds: 0),
                                      transitionsBuilder:
                                          (context, animation, secondaryAnimation, child) {
                                        return child;
                                      },
                                    ));
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                child: CustomPaint(
                                  size: Size(25, 25),
                                  painter: CircleProgressBar(
                                    progress: (_totalCaloriesToday / _maintainWeightCalories),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${_totalCaloriesToday}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontFamily: "SegoeUIBold",
                                          ),
                                        ),
                                        Text(
                                          "kcal",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontFamily: "SegoeUIBold"
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your foodie entries',
                    style: TextStyle(
                      fontFamily: "SegoeUIBold",
                      fontSize: 20,
                    )
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/adddiary")
                          .then((_) => _refreshDiary());
                    },
                      child: Text(
                        "Add new",
                        style: TextStyle(
                          fontFamily: "MontserratBold",
                          color: Color(0xFF6800E8),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE2D2FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: FutureBuilder<List<Diary>>(
                future: _diaryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error loading diaries'),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return Center(
                      //child: Text('No diaries found'),
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          Image.asset(
                            // assetsPath.emptyDiary,
                            "assets/images/paperairplane.png",
                            height: 220,
                            width: 220,
                          ),
                          SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'No diaries here. ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Add new?',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.pushNamed(context, "/adddiary").then((_) => _refreshDiary()),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    );
                  } else {
                    final diaries = snapshot.data!;
                    final reversedDiaries = List.from(diaries.reversed);

                    return SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: reversedDiaries.length,
                        itemBuilder: (context, index) {
                          final diary = reversedDiaries[index];
                          final category = categorizeDiary(diary);
                          final createdDate = DateFormat('yyyy-MM-dd').format(diary.createdTime);
                          final editedDate = DateFormat('yyyy-MM-dd').format(diary.editedTime);

                          Widget _buildDiaryItem(Diary diary, String createdDate) {
                            return GestureDetector(
                              onTap: () {
                                _editDiary(diary);
                              },
                              onLongPress: () => _deleteDiary(diary),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    height:
                                    90,
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: Row(
                                        children: [
                                          if (diary.imagePath != null)
                                            ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                              child: SizedBox(
                                                height:
                                                80,
                                                width:
                                                110,
                                                child: _buildImageWidget(
                                                    diary.imagePath!),
                                              ),
                                            )
                                          else
                                            SizedBox(
                                              height: 80,
                                              width: 110,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                    Radius.circular(15.0),
                                                    bottomRight:
                                                    Radius.circular(15.0),
                                                    topLeft:
                                                    Radius.circular(15.0),
                                                    topRight:
                                                    Radius.circular(15.0),
                                                  ),
                                                  color: Color(0xFFEBEBE9),
                                                ),
                                                child: Icon(
                                                  Icons.description_outlined,
                                                  size: 30,
                                                  color: Color(0xFF959595),
                                                ),
                                              ),
                                            ),
                                          Expanded(
                                            child: ListTile(
                                              title: Text(
                                                diary.title,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  FittedBox(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: 10), // Add padding for some space around the text
                                                      height: 30,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(Icons.local_fire_department, size: 18, color: Color(0xFF707070)),
                                                          Text(
                                                            diary.calorie.toString() + " Calories",
                                                            style: TextStyle(
                                                              fontFamily: "SegoeUIBold",
                                                              color: Color(0xFF707070),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )

                                                  // Text(
                                                  //   createdDate,
                                                  //   overflow:
                                                  //   TextOverflow.ellipsis,
                                                  //   maxLines: 2,
                                                  // ),
                                                  //Text(diary.user.toString()),
                                                  // Text(
                                                  //   editedDate,
                                                  // ),
                                                ],
                                              ),
                                              onTap: () {
                                                _editDiary(diary);
                                              },
                                              //onLongPress: () => _deleteNote(note),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  if (index != diaries.length - 1)
                                    Row(
                                      children: [
                                        Spacer(),
                                        Container(
                                          margin:
                                          EdgeInsets.symmetric(horizontal: 16.0),
                                          color: Colors.grey.withOpacity(
                                              0.4), // Customize the line color
                                          height: 0.7,
                                          width: 215,
                                        ),
                                      ],
                                    ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            );
                          }

                          // Check if this is the first item of the category and add a header
                          if (index == 0 || category != _currentCategory) {
                            _currentCategory = category;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF707070)
                                    ),
                                  ),
                                ),
                                _buildDiaryItem(diary, createdDate),
                              ],
                            );
                          } else {
                            return _buildDiaryItem(diary, createdDate);
                          }
                        },
                      ),
                    );

                  }
                },
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _clearAllDiary();
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.delete,
                        size: 18,
                        color: Colors.red,
                      ),
                    ),
                    TextSpan(
                      text: ' Delete all diary',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          DiaryPage(),
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
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          RecipePage(),
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
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          HealthHubPage(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/adddiary")
              .then((_) => _refreshDiary());
        },
        child: Icon(Icons.add, color: Color(0xFFFFFFFF)),
        backgroundColor: Colors.black,
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
      ..color = Color(0xff5008b6)// Grey background color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw grey circle as background
    canvas.drawCircle(center, radius, paint);

    final progressPaint = Paint()
      ..color = Color(0xFFFFFFFF) // Blue progress color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

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