import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullImageScreen extends StatelessWidget {
  final ImageProvider imageProvider;

  FullImageScreen({required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: PhotoView(
          imageProvider: imageProvider,
        ),
      ),
    );
  }
}