import 'package:example/upload_animation.dart';
import 'package:flutter/material.dart';

void main() {
  
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Upload Animation Example'),
      ),
      body: const Center(
        child: UploadAnimation(
          active: true,
          speed: 0.5,
          bubbleCount: 10,
          color: Colors.blue,
          child: Icon(Icons.arrow_circle_right, size: 150.0, fill: 1.0
          ),
        ),
      ),
    ),
  ));
}