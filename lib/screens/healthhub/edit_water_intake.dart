import 'package:flutter/material.dart';
import 'dart:io';
import 'package:foodsnap/models/waterintake.dart';

class EditWaterIntakePage extends StatefulWidget {
  final WaterIntake waterintake;

  const EditWaterIntakePage({required this.waterintake, Key? key}) : super(key: key);

  @override
  State<EditWaterIntakePage> createState() => _EditWaterIntakePageState();
}

class _EditWaterIntakePageState extends State<EditWaterIntakePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _waterAmountController;

  @override
  void initState() {
    super.initState();
    _waterAmountController = TextEditingController(text: widget.waterintake.waterAmount.toString());
  }

  @override
  void dispose() {
    _waterAmountController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedWaterAmount = int.parse(_waterAmountController.text);

      final updatedWaterIntake = WaterIntake(
        id: widget.waterintake.id,
        waterAmount: updatedWaterAmount,
        createdTime: widget.waterintake.createdTime,
        editedTime: DateTime.now(),
        user: widget.waterintake.user,
      );

      Navigator.pop(context, updatedWaterIntake);

      return;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Editing water intake",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Color(0xFFf9f9f8),
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                        'Edit water intake',
                        style: TextStyle(
                          fontFamily: "SegoeUIBold",
                          fontSize: 30,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _waterAmountController,
                      decoration: const InputDecoration(
                        hintText: 'Water Amount',
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