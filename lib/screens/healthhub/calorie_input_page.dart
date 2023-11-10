import 'package:flutter/material.dart';

class CalorieInputPage extends StatefulWidget {
  @override
  _CalorieInputPageState createState() => _CalorieInputPageState();
}

class _CalorieInputPageState extends State<CalorieInputPage> {
  String selectedActivity = 'Sedentary';
  int age = 18;
  String selectedGender = 'Male';
  double weight = 70.0;
  double height = 170.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculate your calories',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (Previous input fields)
            Text('Select Your Activity Level:'),
            DropdownButton<String>(
              value: selectedActivity,
              onChanged: (newValue) {
                setState(() {
                  selectedActivity = newValue!;
                });
              },
              items: <String>['Sedentary', 'Mild Activity', 'Normal Activity']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text('Enter Your Age:'),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  age = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Select Your Gender:'),
            DropdownButton<String>(
              value: selectedGender,
              onChanged: (newValue) {
                setState(() {
                  selectedGender = newValue!;
                });
              },
              items: <String>['Male', 'Female']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text('Enter Your Weight (kg):'),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  weight = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Enter Your Height (cm):'),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  height = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  // Calculate calories based on the input data
                  double bmr;
                  if (selectedGender == 'Male') {
                    bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
                  } else {
                    bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
                  }

                  // Define activity factors for different activity levels
                  double activityFactor;
                  if (selectedActivity == 'Sedentary') {
                    activityFactor = 1.2;
                  } else if (selectedActivity == 'Mild Activity') {
                    activityFactor = 1.375;
                  } else {
                    activityFactor = 1.55;
                  }

                  // Calculate calorie needs based on the selected activity factor
                  double calorieNeeds = bmr * activityFactor;
                  double maintainWeightCalories = calorieNeeds;
                  double mildWeightLossCalories = calorieNeeds - 500.0; // 500 calories deficit for mild weight loss
                  double normalWeightLossCalories = calorieNeeds - 1000.0; // 1000 calories deficit for normal weight loss

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalorieResultPage(
                        calorieNeeds,
                        maintainWeightCalories,
                        mildWeightLossCalories,
                        normalWeightLossCalories,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF006CC2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17)
                    )
                ),
                child: Text(
                  'Calculate',
                  style: TextStyle(
                    fontFamily: "SegoeUIBold",
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalorieResultPage extends StatelessWidget {
  final double calorieNeeds;
  final double maintainWeightCalories;
  final double mildWeightLossCalories;
  final double normalWeightLossCalories;

  CalorieResultPage(
      this.calorieNeeds,
      this.maintainWeightCalories,
      this.mildWeightLossCalories,
      this.normalWeightLossCalories,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Result',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Calorie Results',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "SegoeUIBold",
                ),
              ),
              SizedBox(height: 20),
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
                height: 150,
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
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF006CC2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17)
                      )
                  ),
                  child: Text(
                    'Back to calculator',
                    style: TextStyle(
                      fontFamily: "SegoeUIBold",
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CalorieInputPage(),
  ));
}
