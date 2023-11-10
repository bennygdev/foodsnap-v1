import 'package:flutter/material.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:foodsnap/models/user.dart';
import 'package:foodsnap/screens/profile_gathering/height_input_page.dart';

class WeightInputFormPage extends StatefulWidget {
  final User user;

  WeightInputFormPage({required this.user});

  @override
  _WeightInputFormPageState createState() => _WeightInputFormPageState();
}

class _WeightInputFormPageState extends State<WeightInputFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();

    weightController.text = widget.user.weight?.toString() ?? '';
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final int? weight = int.tryParse(weightController.text);

      if (weight != null) {
        final updatedUser = widget.user.copy(
          weight: weight,
        );

        await UserDatabase.instance.updateUser(updatedUser);

        //Navigator.pushReplacementNamed(context, '/diary');
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => HeightInputFormPage(user: updatedUser)
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
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/weighingscale.png",
                    height: 300,
                    width: 300,
                  ),
                ),
                Center(
                  child: Text(
                    'Enter your weight',
                    style: TextStyle(
                      fontFamily: "SegoeUIBold",
                      fontSize: 30,
                    ),
                  ),
                ),
                TextFormField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Weight must be a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                //ElevatedButton(onPressed: _submitForm, child: Text('Submit')),
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
      ),
    );
  }
}
