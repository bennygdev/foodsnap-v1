import 'package:flutter/material.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:foodsnap/models/user.dart';

class EditWaterGoalPage extends StatefulWidget {
  final User user;

  EditWaterGoalPage({required this.user});

  @override
  _EditWaterGoalPageState createState() => _EditWaterGoalPageState();
}

class _EditWaterGoalPageState extends State<EditWaterGoalPage> {
  final _formKey = GlobalKey<FormState>();
  String? _newWaterGoal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Water Goal',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
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
                    "assets/images/watergoal.png",
                    height: 300,
                    width: 300,
                  ),
                ),
                Center(
                  child: Text(
                    'Edit water goal',
                    style: TextStyle(
                      fontFamily: "SegoeUIBold",
                      fontSize: 30,
                    ),
                  ),
                ),
                TextFormField(
                  initialValue: widget.user.watergoal.toString(),
                  decoration: InputDecoration(labelText: 'Water Goal'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Water Goal is required';
                    }
                    return null;
                  },
                  onSaved: (value) => _newWaterGoal = value,
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 180,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        User updatedUser = widget.user.copy(
                          watergoal: int.tryParse(_newWaterGoal ?? '') ?? widget.user.watergoal,
                        );

                        await UserDatabase.instance.updateUser(updatedUser);

                        Navigator.pop(context, updatedUser);
                      }
                    },
                    child: Text(
                      "Save Changes",
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
          ),
        ),
      ),
    );
  }
}
