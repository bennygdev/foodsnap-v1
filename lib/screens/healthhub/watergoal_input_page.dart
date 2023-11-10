import 'package:flutter/material.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:foodsnap/models/user.dart';
import 'package:foodsnap/screens/healthhub/waterIntake.dart';
import 'package:foodsnap/screens/profile_gathering/gender_input_page.dart';

class WaterIntakeFormPage extends StatefulWidget {
  final User user;

  WaterIntakeFormPage({required this.user});

  @override
  _WaterIntakeFormPageState createState() => _WaterIntakeFormPageState();
}

class _WaterIntakeFormPageState extends State<WaterIntakeFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController waterGoalController = TextEditingController();

  @override
  void initState() {
    super.initState();

    waterGoalController.text = widget.user.watergoal?.toString() ?? '';
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final int? watergoal = int.tryParse(waterGoalController.text);

      if (watergoal != null) {
        final updatedUser = widget.user.copy(
          watergoal: watergoal,
        );

        await UserDatabase.instance.updateUser(updatedUser);

        //Navigator.pushReplacementNamed(context, '/diary');
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => WaterIntakePage()
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/watergoal2.png",
                    height: 200,
                    width: 200,
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: Text(
                    'Enter your water goal',
                    style: TextStyle(
                      fontFamily: "SegoeUIBold",
                      fontSize: 30,
                    ),
                  ),
                ),
                TextFormField(
                  controller: waterGoalController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your watergoal';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Age must be a valid number';
                    }
                    return null;
                  },
                ),
                //ElevatedButton(onPressed: _submitForm, child: Text('Submit')),
                SizedBox(height: 20),
                Row(
                  children: [
                    Spacer(),
                    SizedBox(
                      height: 50,
                      width: 140,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          //backgroundColor: Color(0xFFF1F1F1),
                          backgroundColor: Color(0xFF006491),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17.0),
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
      ),
    );
  }
}
