import 'package:flutter/material.dart';
import 'package:foodsnap/models/user.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:foodsnap/db/diary_database.dart';
import 'package:foodsnap/models/diary.dart';
import 'package:foodsnap/screens/healthhub/bmi_input_page.dart';
import 'package:foodsnap/screens/healthhub/calorie_input_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CalorieCalculator extends StatefulWidget {

  @override
  _CalorieCalculatorState createState() => _CalorieCalculatorState();
}

class _CalorieCalculatorState extends State<CalorieCalculator> {
  User? loggedInUser;
  double selectedActivityFactor = 1.2;
  double maintainWeightCalories = 0.0;
  double mildWeightLossCalories = 0.0;
  double normalWeightLossCalories = 0.0;
  int _totalCaloriesToday = 0;
  String _username = "";
  int selectedCalorieTargetIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _fetchUserDetails();
    _retrieveTodayCalories();
  }

  Future<void> _loadUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    setState(() {
      _username =
          storedUsername ?? '';
    });
  }

  Future<void> _retrieveTodayCalories () async {
    final diaries = await DiaryDatabase.instance.readAllDiary();
    final filteredDiaries =
    diaries.where((diary) => diary.user == _username).toList();
    // Calculate total calories consumed today
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
      _totalCaloriesToday = totalCaloriesToday;
    });

    print(_totalCaloriesToday);
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

    double calorieNeeds = bmr * selectedActivityFactor;

    setState(() {
      // Update the calculated calorie needs
      maintainWeightCalories = calorieNeeds;
      mildWeightLossCalories = calorieNeeds - 500.0; // 500 calories deficit for mild weight loss
      normalWeightLossCalories = calorieNeeds - 1000.0; // 1000 calories deficit for normal weight loss
    });
  }

  String getActivityDescription(double activityFactor) {
    if (activityFactor == 1.2) {
      return 'Sedentary';
    } else if (activityFactor == 1.375) {
      return 'Mild Activity';
    } else if (activityFactor == 1.55) {
      return 'Normal Activity';
    } else {
      return 'Unknown';
    }
  }

  double _getSelectedCalorieTarget() {
    switch (selectedCalorieTargetIndex) {
      case 0:
        return normalWeightLossCalories;
      case 1:
        return mildWeightLossCalories;
      case 2:
        return maintainWeightCalories;
      default:
        return maintainWeightCalories; // Default to maintainWeightCalories
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("Calorie Calculator", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Calorie Calculator",
              //   style: TextStyle(
              //     fontSize: 20,
              //     fontFamily: "SegoeUIBold",
              //   ),
              // ),
              // SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF03FF10), Color(0xFF0FAD00)],
                    ),
                  borderRadius: BorderRadius.circular(20)
                ),
                width: 400,
                height: 155,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${maintainWeightCalories.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontFamily: "MontserratBold",
                              fontSize: 45,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                            child: Text(
                              "kcal",
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: "MontserratBold",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "To maintain weight",
                        style: TextStyle(
                          fontFamily: "SegoeUIBold",
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFB967), Color(0xFFFF7009)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 150,
                    width: 165,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${mildWeightLossCalories.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontFamily: "MontserratBold",
                                fontSize: 35,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                              child: Text(
                                "kcal",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: "MontserratBold",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Text(
                            "For mild weight loss",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "MontserratBold",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFD900), Color(0xFFFF6505)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 150,
                    width: 165,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${normalWeightLossCalories.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontFamily: "MontserratBold",
                                fontSize: 35,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                              child: Text(
                                "kcal",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: "MontserratBold",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Text(
                            "For normal weight loss",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "MontserratBold",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Choose activity",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "SegoeUIBold",
                      color: Color(0xFF707070)
                    ),
                  ),
                  Text(
                    'Activity: ${getActivityDescription(selectedActivityFactor)}',
                    style: TextStyle(
                      fontFamily: "SegoeUIBold",
                      fontSize: 15,
                      color: Color(0xFF707070)
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 110,
                    height: 80,
                    decoration: BoxDecoration(
                      color: selectedActivityFactor == 1.2 ? Color(0xFF006491) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: selectedActivityFactor == 1.2 ? Color(0xFF006491) : Color(0xFFC4C4C4), width: 1)
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedActivityFactor = 1.2;
                          calculateCalories(loggedInUser!);
                        });
                      },
                      child: Center(
                        child: Text(
                          'Sedentary',
                          style: TextStyle(color: selectedActivityFactor == 1.2 ? Colors.white : Colors.black, fontFamily: "SegoeUIBold"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 110,
                    height: 80,
                    decoration: BoxDecoration(
                        color: selectedActivityFactor == 1.375 ? Color(0xFF006491) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: selectedActivityFactor == 1.375 ? Color(0xFF006491) : Color(0xFFC4C4C4), width: 1)
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedActivityFactor = 1.375;
                          calculateCalories(loggedInUser!);
                        });
                      },
                      child: Center(
                        child: Text(
                          'Mild Activity',
                          style: TextStyle(color: selectedActivityFactor == 1.375 ? Colors.white : Colors.black, fontFamily: "SegoeUIBold"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 110,
                    height: 80,
                    decoration: BoxDecoration(
                        color: selectedActivityFactor == 1.55 ? Color(0xFF006491) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: selectedActivityFactor == 1.55 ? Color(0xFF006491) : Color(0xFFC4C4C4), width: 1)
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedActivityFactor = 1.55;
                          calculateCalories(loggedInUser!);
                        });
                      },
                      child: Center(
                        child: Text(
                          'Normal\nActivity',
                          style: TextStyle(color: selectedActivityFactor == 1.55 ? Colors.white : Colors.black, fontFamily: "SegoeUIBold"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                height: 210,
                width: 400,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE15910), Color(0xFFFF3B35)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's calorie count",
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: "SegoeUIBold",
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Spacer(),
                          Text(
                            '$_totalCaloriesToday/',
                            style: TextStyle(
                              fontFamily: "SegoeUIBold",
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            selectedCalorieTargetIndex == 0
                                ? normalWeightLossCalories.toStringAsFixed(0)
                                : selectedCalorieTargetIndex == 1
                                ? mildWeightLossCalories.toStringAsFixed(0)
                                : maintainWeightCalories.toStringAsFixed(0),
                            style: TextStyle(
                              fontFamily: "SegoeUIBold",
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 10,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: (_totalCaloriesToday / _getSelectedCalorieTarget()).clamp(0.0, 1.0),
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                // color: Colors.blue,
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Color(0xFF3B96FF), Color(0xFF1867FF)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        _totalCaloriesToday > _getSelectedCalorieTarget() ? "Oh no, you exceeded!" : "Getting there!",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "SegoeUIBold",
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ToggleButtons(
                            selectedColor: Colors.white,
                            fillColor: Color(0xFF006491),
                            borderRadius: BorderRadius.circular(10),
                            children: [
                              Container( // Use Container to customize the background color
                                color: selectedCalorieTargetIndex == 0 ? Color(0xFF006491) : Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Normal Weight \nLoss', textAlign: TextAlign.center, style: TextStyle(fontFamily: "SegoeUIBold")),
                                ),
                              ),
                              Container( // Use Container to customize the background color
                                color: selectedCalorieTargetIndex == 1 ? Color(0xFF006491) : Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Mild Weight\n Loss', textAlign: TextAlign.center, style: TextStyle(fontFamily: "SegoeUIBold")),
                                ),
                              ),
                              Container( // Use Container to customize the background color
                                color: selectedCalorieTargetIndex == 2 ? Color(0xFF006491) : Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Maintain\n Weight', textAlign: TextAlign.center, style: TextStyle(fontFamily: "SegoeUIBold")),
                                ),
                              ),
                            ],
                            isSelected: List.generate(3, (index) => index == selectedCalorieTargetIndex),
                            onPressed: (index) {
                              setState(() {
                                selectedCalorieTargetIndex = index;
                              });
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF3474EB), Color(0xFF004CD9)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 195,
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Calculate your own Calories?",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 20,
                          fontFamily: "MontserratBold",
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Thinking of calculating your calories for yourself or for someone else? Tap on the button below.",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontFamily: "SegoeUIBold",
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 22),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CalorieInputPage()
                          ));
                        },
                        child: Text(
                          "Manually calculate Calories",
                          style: TextStyle(
                            fontFamily: "MontserratBold",
                            color: Color(0xFF004CD9),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDBE8FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (loggedInUser != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFE3E3E3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 150,
                      width: 165,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Gender",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "MontserratBold",
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${loggedInUser!.gender}',
                                style: TextStyle(
                                  fontFamily: "MontserratBold",
                                  fontSize: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFE3E3E3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 150,
                      width: 165,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Age",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "MontserratBold",
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${loggedInUser!.age}',
                                style: TextStyle(
                                  fontFamily: "MontserratBold",
                                  fontSize: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFE3E3E3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 150,
                      width: 165,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Height",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "MontserratBold",
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${loggedInUser!.height}',
                                style: TextStyle(
                                  fontFamily: "MontserratBold",
                                  fontSize: 40,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                                child: Text(
                                  "cm",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: "MontserratBold",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFE3E3E3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 150,
                      width: 165,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Weight",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "MontserratBold",
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${loggedInUser!.weight}',
                                style: TextStyle(
                                  fontFamily: "MontserratBold",
                                  fontSize: 40,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                                child: Text(
                                  "kg",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: "MontserratBold",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}