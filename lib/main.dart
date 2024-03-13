import 'package:example/osm_element_marker.dart';
import 'package:example/upload_animation.dart';
import 'package:flutter/material.dart';

void main() {
  var primaryColor = const Color(0xFFEC7C72);
  runApp(MaterialApp(
    theme: ThemeData.light().copyWith(
        primaryColor: primaryColor,
        brightness: Brightness.light,
        dividerColor: Colors.white54,
        colorScheme: ColorScheme.light(primary: primaryColor),
      ),
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Upload Animation Example'),
      ),
      body: const Center(
        child: UploadAnimationDemo(),
      ),
    ),
  ));
}

class UploadAnimationDemo extends StatefulWidget {
  const UploadAnimationDemo({Key? key}) : super(key: key);

  @override
  State<UploadAnimationDemo> createState() => _UploadAnimationDemoState();
}

class _UploadAnimationDemoState extends State<UploadAnimationDemo> {
  bool _isActive = false;

  void toggleAnimation() {
    setState(() {
      _isActive = !_isActive;
    });
  }

  @override
  Widget build(BuildContext context) {  
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UploadAnimation(
          width: 150,
          padding: 12,
          active: _isActive,
          emitDuration: 200,
          color: const Color(0xFFEC7C72),
          child: const SizedBox(
            width: 150,
            height: 150,
            child: OsmElementMarker(
              icon: Icons.local_parking,
              backgroundColor: Color(0xFFEC7C72),
              label: 'Test',
            ),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: toggleAnimation,
          child: Text(_isActive ? 'Stop Animation' : 'Start Animation'),
        ),
      ],
    );
  }
}