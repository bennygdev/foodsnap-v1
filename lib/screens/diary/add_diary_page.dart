import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:foodsnap/db/diary_database.dart';
import 'package:foodsnap/models/diary.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:foodsnap/screens/fullImage_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddDiaryPage extends StatefulWidget {
  const AddDiaryPage({Key? key}) : super(key: key);

  @override
  State<AddDiaryPage> createState() => _AddDiaryPageState();
}

class _AddDiaryPageState extends State<AddDiaryPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _commentController;
  late TextEditingController _calorieController;
  File? _imageFile;

  Future<String?> _loadUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    return storedUsername;
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _commentController = TextEditingController();
    _calorieController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    _calorieController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final savedImage = await image.copy('${directory.path}/$fileName');
    return savedImage.path;
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  Future<void> _saveDiary() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final comment = _commentController.text;
      final calorie = int.parse(_calorieController.text);
      final createdTime = DateTime.now();
      String? imagePath;

      if (_imageFile != null) {
        imagePath = await _saveImage(_imageFile!);
      }

      final String? username = await _loadUsername();
      final diary = Diary(
        title: title,
        comment: comment,
        calorie: calorie,
        createdTime: createdTime,
        editedTime: createdTime,
        imagePath: imagePath,
        user: username,
      );

      await DiaryDatabase.instance.create(diary);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3A0094),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF3A0094),
        title: Text(
          "Add new entry",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "SegoeUIBold"
          ),
        ),
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: _saveDiary,
              icon: Icon(Icons.save)
          )
        ],
      ),
      body: Container(
        height: 1500,
        child: Stack(
          children: [
            Positioned(
              bottom: -50,
              right: -50,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFF5000C7),
                    borderRadius: BorderRadius.circular(1000)
                ),
                width: 300,
                height: 300,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: 'Title',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        _imageFile != null
                            ? Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return FullImageScreen(
                                    imageProvider: FileImage(_imageFile!),
                                  );
                                }));
                              },
                              child: Container(
                                height: 300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(_imageFile!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                              child: SizedBox(
                                height: 29,
                                width: 125,
                                child: TextButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Remove Image',
                                        style: TextStyle(
                                          color: Colors.grey[900],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: _removeImage,
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.white.withOpacity(0.9),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                            : Padding(
                          padding: const EdgeInsets.symmetric(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Add Image',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  )
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => _pickImage(ImageSource.camera),
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.camera_alt),
                                            SizedBox(height: 8),
                                            Text(
                                              'Take Photo',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => _pickImage(ImageSource.gallery),
                                      child: Container(
                                        height: 100, // Customize the container height as desired
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.image),
                                            SizedBox(height: 8),
                                            Text(
                                              'Choose from \nGallery',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _calorieController,
                                style: TextStyle(
                                    fontFamily: "SegoeUIBold"
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Calories (kcal)',
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.local_fire_department),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter calorie count';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Calories must be a valid number';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                              ),
                              TextFormField(
                                controller: _commentController,
                                decoration: const InputDecoration(
                                    hintText: 'Comment',
                                    border: InputBorder.none,
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Icon(Icons.comment),
                                    )
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a comment';
                                  }
                                  return null;
                                },
                                maxLines: null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
