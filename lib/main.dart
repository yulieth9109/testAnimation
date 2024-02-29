import 'package:example/smoke_animation.dart';
import 'package:flutter/material.dart';

void main() {
  
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Upload Animation Example'),
      ),
      body: const Center(
        child: UploadAnimation(),
      ),
    ),
  ));
}

class UploadAnimation extends StatefulWidget {
  const UploadAnimation({Key? key}) : super(key: key);

  @override
  _UploadAnimationState createState() => _UploadAnimationState();
}

class _UploadAnimationState extends State<UploadAnimation> {
  bool _isActive = true;

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
        AnimateBubles(
          active: _isActive,
          speed: 0.5,
          bubbleCount: 1,
          color: Colors.blue,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {},
            icon: const Icon(Icons.arrow_circle_right, size: 150.0)
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