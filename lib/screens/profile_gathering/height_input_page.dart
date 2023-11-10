import 'package:flutter/material.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:foodsnap/models/user.dart';

class HeightInputFormPage extends StatefulWidget {
  final User user;

  HeightInputFormPage({required this.user});

  @override
  _HeightInputFormPageState createState() => _HeightInputFormPageState();
}

class _HeightInputFormPageState extends State<HeightInputFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    super.initState();

    heightController.text = widget.user.height?.toString() ?? '';
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final int? height = int.tryParse(heightController.text);

      if (height != null) {
        final updatedUser = widget.user.copy(
          height: height,
        );

        await UserDatabase.instance.updateUser(updatedUser);

        Navigator.pushReplacementNamed(context, '/diary');
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
                  "assets/images/measuringheight.png",
                  height: 300,
                  width: 300,
                ),
              ),
              Center(
                child: Text(
                  'Enter your height',
                  style: TextStyle(
                    fontFamily: "SegoeUIBold",
                    fontSize: 30,
                  ),
                ),
              ),
              TextFormField(
                controller: heightController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Height must be a valid number';
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
