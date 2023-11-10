import 'package:flutter/material.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:foodsnap/models/user.dart';
import 'package:foodsnap/screens/profile_gathering/gender_input_page.dart';

class AgeInputFormPage extends StatefulWidget {
  final User user;

  AgeInputFormPage({required this.user});

  @override
  _AgeInputFormPageState createState() => _AgeInputFormPageState();
}

class _AgeInputFormPageState extends State<AgeInputFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ageController.text = widget.user.age?.toString() ?? '';
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final int? age = int.tryParse(ageController.text);

      if (age != null) {
        final updatedUser = widget.user.copy(
          age: age,
        );

        await UserDatabase.instance.updateUser(updatedUser);

        //Navigator.pushReplacementNamed(context, '/diary');
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => GenderInputFormPage(user: updatedUser)
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
                    "assets/images/age.png",
                    height: 300,
                    width: 300,
                  ),
                ),
                Center(
                  child: Text(
                    'Enter your age',
                    style: TextStyle(
                      fontFamily: "SegoeUIBold",
                      fontSize: 30,
                    ),
                  ),
                ),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
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
