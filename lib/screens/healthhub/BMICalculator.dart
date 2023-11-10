import 'package:flutter/material.dart';
import 'package:foodsnap/models/user.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:foodsnap/screens/healthhub/bmi_input_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BMICalculator extends StatefulWidget {

  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');

    if (storedUsername != null) {
      User? user = await UserDatabase.instance.getUserByUsername(storedUsername);
      setState(() {
        loggedInUser = user;
      });
    }
  }

  double calculateBMI(int? weight, int? height) {
    // Default values if weight or height is null
    double weightValue = weight?.toDouble() ?? 0.0;
    double heightValue = height?.toDouble() ?? 0.0;

    // Ensure height is in meters
    double heightInMeters = heightValue / 100.0;

    // Calculate BMI
    double bmi = weightValue / (heightInMeters * heightInMeters);

    return bmi;
  }

  String _getBMIStatus(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      return 'Healthy';
    } else if (bmi >= 25.0 && bmi <= 29.9) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  Widget _buildBMIStatusContent(double bmi) {
    String status = _getBMIStatus(bmi);
    String quote = '';
    String factors = '';

    if (status == 'Underweight') {
      quote = 'Your health is important. Ensure you get proper nutrition.';
      factors = 'Factors:\n- Insufficient calorie intake\n- Lack of nutrients\n- Potential health risks';
    } else if (status == 'Healthy') {
      quote = 'You are in a healthy BMI range. Keep up the good work!';
      factors = 'Factors:\n- Balanced diet\n- Lower risk of chronic diseases';
    } else if (status == 'Overweight') {
      quote = 'Consider maintaining a healthy weight for better health.';
      factors = 'Factors:\n- Excess calorie intake\n- Sedentary lifestyle\n- Increased risk of health issues';
    } else if (status == 'Obese') {
      quote = 'Obesity may lead to health problems. Consult a healthcare professional.';
      factors = 'Factors:\n- Severe excess weight\n- Increased risk of chronic diseases\n- Health concerns';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('You are $status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF), fontFamily: "MontserratBold")),
        SizedBox(height: 10),
        Text('$quote', style: TextStyle(fontSize: 15, color: Color(0xFFFFFFFF), fontFamily: "SegoeUIBold")),
        SizedBox(height: 10),
        Text('$factors', style: TextStyle(fontSize: 15, color: Color(0xFFFFFFFF), fontFamily: "SegoeUIBold")),
      ],
    );
  }

  Color _getBMIStatusColor(double bmi) {
    String status = _getBMIStatus(bmi);

    if (status == 'Underweight') {
      return Colors.lightBlue;
    } else if (status == 'Healthy') {
      return Colors.green;
    } else if (status == 'Overweight') {
      return Colors.orange;
    } else if (status == 'Obese') {
      return Colors.red;
    }

    // Default color (if status is unknown)
    return Colors.grey;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("BMI", style: TextStyle(color: Colors.black)),
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
              Text(
                "BMI Calculator",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "SegoeUIBold",
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Container(
                  width: 400,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Color(0xFFE3E3E3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: 40,
                        showLabels: false,
                        showTicks: false,
                        axisLineStyle: AxisLineStyle(
                          thickness: 20, // Adjust the thickness
                          cornerStyle: CornerStyle.bothFlat,
                          color: Colors.transparent, // Set color to transparent
                        ),
                        ranges: <GaugeRange>[
                          GaugeRange(
                            startValue: 0,
                            endValue: 18.5,
                            startWidth: 20,
                            endWidth: 20,
                            color: Colors.blue,
                            gradient: const SweepGradient(
                              colors: <Color>[Colors.blue, Colors.green],
                              stops: <double>[0.0, 1.0],
                            ),
                          ),
                          GaugeRange(
                            startValue: 18.5,
                            endValue: 24.9,
                            startWidth: 20,
                            endWidth: 20,
                            color: Colors.green,
                            gradient: const SweepGradient(
                              colors: <Color>[Colors.green, Colors.orange],
                              stops: <double>[0.0, 1.0],
                            ),
                          ),
                          GaugeRange(
                            startValue: 25.0,
                            endValue: 29.9,
                            startWidth: 20,
                            endWidth: 20,
                            color: Colors.orange,
                            gradient: const SweepGradient(
                              colors: <Color>[Colors.orange, Colors.red],
                              stops: <double>[0.0, 1.0],
                            ),
                          ),
                          GaugeRange(
                            startValue: 30.0,
                            endValue: 40,
                            startWidth: 20,
                            endWidth: 20,
                            color: Colors.red,
                            gradient: const SweepGradient(
                              colors: <Color>[Colors.red, Colors.red],
                              stops: <double>[0.0, 1.0],
                            ),
                          ),
                        ],
                        pointers: <GaugePointer>[
                          NeedlePointer(
                            value: loggedInUser != null ? calculateBMI(loggedInUser!.weight, loggedInUser!.height) : 0, // Adjust the initial value here
                            enableAnimation: true,
                            animationType: AnimationType.easeOutBack,
                            animationDuration: 1200,
                            needleLength: 0.5,
                          ),
                        ],
                        startAngle: 180,
                        endAngle: 0,
                        annotations: [
                          GaugeAnnotation(
                            widget: Column(
                              children: [
                                Text(
                                  "Your BMI:",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "SegoeUIBold"
                                  ),
                                ),
                                if (loggedInUser != null) ...[
                                  Text(
                                    '${calculateBMI(loggedInUser!.weight, loggedInUser!.height).toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "SegoeUIBold"
                                    ),
                                  ),
                                  Text(
                                    _getBMIStatus(calculateBMI(loggedInUser!.weight, loggedInUser!.height)),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "SegoeUIBold"
                                    ),
                                  ),
                                ],
                                SizedBox(height: 13),
                              ],
                            ),
                            positionFactor: 1.4,
                            angle: 90,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              if (loggedInUser != null) ...[
                Container(
                  decoration: BoxDecoration(
                    color: _getBMIStatusColor(calculateBMI(loggedInUser!.weight, loggedInUser!.height)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 200,
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: _buildBMIStatusContent(calculateBMI(loggedInUser!.weight, loggedInUser!.height)),
                  ),
                ),

              ],
              SizedBox(height: 30),
              Container(
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
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Calculate your own BMI?",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 20,
                          fontFamily: "MontserratBold",
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Think that it was inaccurate or you want to calculate your own? Tap on the button below.",
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
                                builder: (context) => HeightInputPage()
                            ));
                          },
                          child: Text(
                            "Manually calculate BMI",
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
              ),
              SizedBox(height: 30),
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
              ] else ...[
                Text('Loading user details...'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}