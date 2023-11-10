import 'package:flutter/material.dart';
import 'package:foodsnap/screens/diary/diary.dart';
import 'package:foodsnap/screens/healthhub/BMICalculator.dart';
import 'package:foodsnap/screens/healthhub/CalorieCalculator.dart';
import 'package:foodsnap/screens/healthhub/healthhub.dart';
import 'package:foodsnap/screens/healthhub/waterIntake.dart';
import 'package:foodsnap/screens/recipes/recipes.dart';

class Services extends StatelessWidget {
  const Services({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Services",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "SegoeUIBold",
                color: Color(0xFF4B4B4B)
              )
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
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
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(150),
                          border: Border.all(color: Color(0xFF037bfc), width: 2)
                        ),
                        width: 50,
                        height: 50,
                        child: Icon(Icons.home, color: Color(0xFF037bfc), size: 30,),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Diary",
                      style: TextStyle(
                        color: Color(0xFF037bfc),
                        fontFamily: "SegoeUIBold"
                      )
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
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
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                            border: Border.all(color: Color(0xFF41f500), width: 2)
                        ),
                        width: 50,
                        height: 50,
                        child: Icon(Icons.receipt_long, color: Color(0xFF41f500), size: 30,),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                        "Recipes",
                        style: TextStyle(
                            color: Color(0xFF41f500),
                            fontFamily: "SegoeUIBold"
                        )
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
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
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                            border: Border.all(color: Color(0xFFf55a00), width: 2)
                        ),
                        width: 50,
                        height: 50,
                        child: Icon(Icons.health_and_safety, color: Color(0xFFf55a00), size: 30,),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                        "Health",
                        style: TextStyle(
                            color: Color(0xFFf55a00),
                            fontFamily: "SegoeUIBold"
                        )
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 17),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  BMICalculator(),
                              transitionDuration: Duration(milliseconds: 0),
                              transitionsBuilder:
                                  (context, animation, secondaryAnimation, child) {
                                return child;
                              },
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                            border: Border.all(color: Color(0xFF8f00f5), width: 2)
                        ),
                        width: 50,
                        height: 50,
                        child: Icon(Icons.line_weight, color: Color(0xFF8f00f5), size: 30,),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                        "BMI",
                        style: TextStyle(
                            color: Color(0xFF8f00f5),
                            fontFamily: "SegoeUIBold"
                        )
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                            border: Border.all(color: Color(0xFFf5bc00), width: 2)
                        ),
                        width: 50,
                        height: 50,
                        child: Icon(Icons.home, color: Color(0xFFf5bc00), size: 30,),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                        "Calorie",
                        style: TextStyle(
                            color: Color(0xFFf5bc00),
                            fontFamily: "SegoeUIBold"
                        )
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  WaterIntakePage(),
                              transitionDuration: Duration(milliseconds: 0),
                              transitionsBuilder:
                                  (context, animation, secondaryAnimation, child) {
                                return child;
                              },
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                            border: Border.all(color: Color(0xFF4feaff), width: 2)
                        ),
                        width: 50,
                        height: 50,
                        child: Icon(Icons.water_drop, color: Color(0xFF4feaff), size: 30,),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                        "Water",
                        style: TextStyle(
                            color: Color(0xFF4feaff),
                            fontFamily: "SegoeUIBold"
                        )
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
