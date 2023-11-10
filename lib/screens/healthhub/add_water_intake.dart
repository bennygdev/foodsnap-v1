import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:foodsnap/db/waterintake_database.dart';
import 'package:foodsnap/models/waterintake.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddWaterIntakePage extends StatefulWidget {
  const AddWaterIntakePage({Key? key}) : super(key: key);

  @override
  State<AddWaterIntakePage> createState() => _AddWaterIntakePageState();
}

class _AddWaterIntakePageState extends State<AddWaterIntakePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _waterAmountController;

  Future<String?> _loadUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    return storedUsername;
  }

  @override
  void initState() {
    super.initState();
    _waterAmountController = TextEditingController();
  }

  @override
  void dispose() {
    _waterAmountController.dispose();
    super.dispose();
  }

  Future<void> _saveWaterIntake() async {
    if (_formKey.currentState!.validate()) {
      final wateramount = int.parse(_waterAmountController.text);
      final createdTime = DateTime.now();

      final String? username = await _loadUsername();
      final waterintake = WaterIntake(
        waterAmount: wateramount,
        createdTime: createdTime,
        editedTime: createdTime,
        user: username,
      );

      await WaterIntakeDatabase.instance.create(waterintake);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Color(0xFFf9f9f8),
        title: const Text(
            'Add Water Intake',
            style: TextStyle(
              color: Colors.black,
            )
        ),
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: _saveWaterIntake,
            child: const Text(
              'Add',
              style: TextStyle(
                  color: Colors.black
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
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
                        'Add Water Intake',
                        style: TextStyle(
                          fontFamily: "SegoeUIBold",
                          fontSize: 30,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _waterAmountController,
                      decoration: const InputDecoration(
                        hintText: 'Water Amount (ml)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter water amount';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Water amount must be a valid number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
