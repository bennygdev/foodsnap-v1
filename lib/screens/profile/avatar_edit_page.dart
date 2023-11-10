import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:foodsnap/models/user.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "dart:io";

class EditProfileImagePage extends StatefulWidget {
  final Function(File?) onImageSelected;

  EditProfileImagePage({required this.onImageSelected});

  @override
  _EditProfileImagePageState createState() => _EditProfileImagePageState();
}

class _EditProfileImagePageState extends State<EditProfileImagePage> {
  User? loggedInUser;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails(); // Fetch user details when page inits
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }


  Future<void> _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');

    if (storedUsername != null) {
      User? user = await UserDatabase.instance.getUserByUsername(storedUsername);
      setState(() {
        loggedInUser = user;

        // Check if the user has an existing profile image and load it
        if (loggedInUser?.urlAvatar != null) {
          _imageFile = File(loggedInUser!.urlAvatar!);
        }
      });
    }
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  void _saveImage() async {
    if (_imageFile != null) {
      // Update the urlAvatar field in the loggedInUser object
      loggedInUser = loggedInUser?.copy(urlAvatar: _imageFile!.path);

      // Save the updated user object to the database
      await UserDatabase.instance.updateUser(loggedInUser!);
    }

    widget.onImageSelected(_imageFile);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Edit Profile Image',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // if (_imageFile != null)
            //   Image.file(
            //     _imageFile!,
            //     width: 200.0,
            //     height: 200.0,
            //     fit: BoxFit.cover,
            //   ),
            Row(
              children: [
                Spacer(),
                SizedBox(
                  height: 40,
                  width: 140,
                  child: ElevatedButton(
                    onPressed: _saveImage,
                    child: Text(
                      "Save image",
                      style: TextStyle(
                        fontSize: 17,
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
            SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  _imageFile != null
                      ? CircleAvatar(
                    radius: 125,
                    backgroundImage: FileImage(_imageFile!),
                  )
                      : CircleAvatar(
                    radius: 125,
                    backgroundImage: AssetImage('assets/images/profilephoto.png'),
                  ),
                  SizedBox(height: 20.0),
                  SizedBox(
                    height: 40,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () => _removeImage(),
                      child: Text(
                        "Remove",
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        //backgroundColor: Color(0xFFF1F1F1),
                        backgroundColor: Color(0xFFE31837),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
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
                            height: 100,
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
                                  'Choose from Gallery',
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
            // ElevatedButton(
            //   onPressed: _saveImage,
            //   child: Text('Save Image'),
            // ),
          ],
        ),
      ),
    );
  }
}

