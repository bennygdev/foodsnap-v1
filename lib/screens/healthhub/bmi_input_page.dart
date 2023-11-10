import 'package:flutter/material.dart';
import 'package:foodsnap/screens/healthhub/BMICalculator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HeightInputPage extends StatefulWidget {
  @override
  _HeightInputPageState createState() => _HeightInputPageState();
}

class _HeightInputPageState extends State<HeightInputPage> {
  TextEditingController _heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        // title: Text(
        //   'Enter height',
        //   style: TextStyle(
        //     color: Colors.black,
        //   ),
        // ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/measuringheight.png",
                height: 200,
                width: 250,
              ),
              Text(
                "Enter height",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "SegoeUIBold"
                ),
              ),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Height (cm)'),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Spacer(),
                  SizedBox(
                    height: 50,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeightInputPage(
                              height: int.tryParse(_heightController.text) ?? 0,
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
                        'Next',
                        style: TextStyle(
                          fontFamily: "SegoeUIBold",
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeightInputPage extends StatefulWidget {
  final int height;

  WeightInputPage({required this.height});

  @override
  _WeightInputPageState createState() => _WeightInputPageState();
}

class _WeightInputPageState extends State<WeightInputPage> {
  TextEditingController _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Enter Weight'),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Text('Height: ${widget.height} cm'),
              Image.asset(
                "assets/images/weighingscale2.png",
                height: 175,
                width: 225,
              ),
              Text(
                "Enter weight",
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: "SegoeUIBold"
                ),
              ),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Weight (kg)'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HeightInputPage(),
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
                        'Back',
                        style: TextStyle(
                          fontFamily: "SegoeUIBold",
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {
                        int height = widget.height;
                        int weight = int.tryParse(_weightController.text) ?? 0;
                        double bmi = weight / ((height / 100.0) * (height / 100.0));

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BMIResultPage(bmi: bmi),
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
                        'Calculate BMI',
                        style: TextStyle(
                          fontFamily: "SegoeUIBold",
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class BMIResultPage extends StatelessWidget {
  final double bmi;

  BMIResultPage({required this.bmi});

  String getBmiCategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Healthy Weight';
    } else if (bmi >= 25.0 && bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  String getBmiDescription(double bmi) {
    if (bmi < 18.5) {
      return 'You are underweight. Consider consulting with a healthcare provider for guidance.';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'You are in the healthy weight range. Keep up the good work!';
    } else if (bmi >= 25.0 && bmi < 29.9) {
      return 'You are overweight. Consider adopting a healthier lifestyle.';
    } else {
      return 'You are obese. It\'s important to seek medical advice for weight management.';
    }
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Underweight':
        return Colors.blue;
      case 'Healthy Weight':
        return Colors.green;
      case 'Overweight':
        return Colors.orange;
      case 'Obese':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getBmiPoints(String category) {
    switch (category) {
      case 'Underweight':
        return 'Tip: Eat a balanced diet with more calories, consult a dietitian. Underweight can weaken the immune system.';
      case 'Healthy Weight':
        return 'Tip: Maintain a healthy lifestyle with regular exercise. Being in a healthy weight range reduces the risk of chronic diseases.';
      case 'Overweight':
        return 'Tip: Adopt a balanced diet and increase physical activity. Overweight increases the risk of heart disease and diabetes.';
      case 'Obese':
        return 'Tip: Seek medical advice for weight management. Obesity is a major risk factor for various health problems.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    String category = getBmiCategory(bmi);
    String description = getBmiDescription(bmi);
    Color categoryColor = getCategoryColor(category);
    String points = getBmiPoints(category);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 400,
                  height: 250,
                  decoration: BoxDecoration(
                    //color: Color(0xFFE3E3E3),
                    color: Colors.transparent,
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
                          thickness: 20,
                          cornerStyle: CornerStyle.bothFlat,
                          color: Colors.transparent,
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
                            value: bmi,
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
                                Text(
                                  '${bmi.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: "SegoeUIBold"
                                  ),
                                ),
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
              // Text(
              //   'Your BMI: ${bmi.toStringAsFixed(2)}',
              //   style: TextStyle(
              //     fontSize: 28,
              //     fontFamily: "SegoeUIBold"
              //   ),
              // ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: categoryColor,
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category: $category',
                      style: TextStyle(fontSize: 22, color: Colors.white, fontFamily: "MontserratBold"),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Description: $description',
                      style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: "SegoeUIBold"),
                    ),
                    SizedBox(height: 20),
                    // Text(
                    //   'Points:',
                    //   style: TextStyle(fontSize: 18, color: Colors.white),
                    // ),
                    Text(
                      points,
                      style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: "SegoeUIBold"),
                    ),
                  ],
                ),
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
                      backgroundColor: Color(0xFFE31837),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17)
                      )
                  ),
                  child: Text(
                    'Back to Calculator',
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
