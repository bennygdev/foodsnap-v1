import 'package:flutter/material.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:foodsnap/models/user.dart';
import 'package:foodsnap/screens/profile_gathering/weight_input_page.dart';

class GenderInputFormPage extends StatefulWidget {
  final User user;

  GenderInputFormPage({required this.user});

  @override
  _GenderInputFormPageState createState() => _GenderInputFormPageState();
}

class _GenderInputFormPageState extends State<GenderInputFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedGender = '';
  final TextEditingController genderController = TextEditingController();

  @override
  void initState() {
    super.initState();

    genderController.text = widget.user.gender ?? '';
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {

      if (selectedGender.isNotEmpty) {
        final updatedUser = widget.user.copy(
          gender: selectedGender,
        );

        await UserDatabase.instance.updateUser(updatedUser);

        //Navigator.pushReplacementNamed(context, '/diary');
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => WeightInputFormPage(user: updatedUser)
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/gendersymbol.jpg",
                  height: 300,
                  width: 300,
                ),
              ),
              Center(
                child: Text(
                  'Enter your gender',
                  style: TextStyle(
                    fontFamily: "SegoeUIBold",
                    fontSize: 30,
                  ),
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGender = newValue ?? '';
                  });
                },
                items: <String>['', 'Male', 'Female'] // Dropdown options
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: value.isEmpty ? Text('Select a gender') : Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a gender';
                  }
                  return null;
                },
              ),
              //ElevatedButton(onPressed: _submitForm, child: Text('Submit')),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    width: 140,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Back",
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
    );
  }
}
