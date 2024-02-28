  import 'dart:async';
  import 'dart:math';
  import 'package:flutter/material.dart';

  class UploadAnimation extends StatefulWidget {
    final bool active;
    final double speed;
    final int bubbleCount;
    final Color color;
    final double radius;
    final Widget child;

    const UploadAnimation({
      required this.active,
      this.speed = 1.0,
      this.bubbleCount = 10,
      this.color = Colors.blue,
      this.radius = 8.0,
      required this.child,
        super.key
    });

    @override
    State<UploadAnimation> createState() => _UploadAnimationState();
  }

  class _UploadAnimationState extends State<UploadAnimation> {
    late Timer _timer;
    List<Bubble> _bubbles = [];
    List<List<double>> points = [];
    int currentPoint = 0;
    var widgetKey = GlobalKey();
    Size? canvasSize;
    late final diameter;


    @override
    void initState() {
      super.initState();
      diameter = widget.radius * 2;
      if (widget.active) {
        _timer = Timer.periodic(const Duration(milliseconds: 16), _updateBubbles);
      }
    }

    @override
    void didUpdateWidget(covariant UploadAnimation oldWidget) {
      super.didUpdateWidget(oldWidget);
      if (widget.active != oldWidget.active) {
        if (widget.active) {
          currentPoint = 0;
          points = [];
          _bubbles = [];
          _timer = Timer.periodic(const Duration(milliseconds: 16), _updateBubbles);
        }
      }
    }

    @override
    void dispose() {
      _timer.cancel();
      super.dispose();
    }

    void _updateBubbles(Timer timer) {
      var context = widgetKey.currentContext;
      if (context != null && context.size != null) {
        canvasSize = context.size;
        if (points.isEmpty) {
          points = generatePoints();
        }
        setState(() {
          _bubbles.removeWhere((bubble) => bubble.isDone);
          if (_bubbles.length < widget.bubbleCount && widget.active == true) {
            currentPoint = (currentPoint + 1) % points.length;
            final y = points[currentPoint][1].toInt();
            _bubbles.add(Bubble(
              speed: widget.speed,
              color: widget.color,
              radius: widget.radius,
              x: points[currentPoint][0],
              y: y + Random().nextInt(widget.radius.toInt()).toDouble(),
              finalY: points[currentPoint][2],
            ));
          }
          for (var bubble in _bubbles) {
            bubble.update();
          }

          if (widget.active == false) {
            _timer.cancel();
          }
        });
      }
    }

    List<List<double>> generatePoints() {
      List<List<double>> points = [];
      List<double> yPoints = [];
      double centerX = canvasSize!.width/2;
      double centerY = canvasSize!.height/2;
      double currentPosition = widget.radius;
      int currentPointY = 0;
      double initialY = centerY + diameter;
      initialY = initialY < canvasSize!.height ? initialY : canvasSize!.height;
      int rows = initialY~/(widget.radius * 4);

      for (int j = 0; j < rows; j++) {
        yPoints.add(initialY);
        initialY -= widget.radius * 4;
      }
      yPoints.sort();

      for (int i = 0; i < widget.bubbleCount; i++) {
        points.add([
          currentPosition,
          yPoints[currentPointY],
          getUpperBorderY(currentPosition, centerX, centerY, centerX)
        ]);
        currentPosition += widget.radius * 3;
        if ((currentPosition + (widget.radius)) > canvasSize!.width) {
          if (currentPointY >= yPoints.length -1) {
            break;
          }
          currentPosition = currentPointY.isOdd ? widget.radius : diameter;
          currentPointY++;
        }
      }
      return points;
    }

    double getUpperBorderY(double x, double centerX, double centerY, double radius) {
      double y = centerY - (sqrt(pow(radius, 2) - pow(x - centerX, 2)));
      return y;
    }

    @override
    Widget build(BuildContext context) {
      return CustomPaint(
        key: widgetKey,
        painter: BubblePainter(bubbles: _bubbles),
        child: widget.child,
      );
    }
  }

  class Bubble {
    final double radius;
    final double speed;
    double x;
    double y;
    double finalY;
    bool isDone = false;
    Color color;
    late final Color startColor;
    late final Color endColor;
    late final double colorTransition;
    

    Bubble({
      required this.color,
      required this.speed,
      required this.radius,
      required this.x,
      required this.y,
      this.finalY = 0,
    }){
      startColor = color.withOpacity(1.0);
      endColor = color.withOpacity(0.0);
      finalY = finalY - 70;
      colorTransition = calculateDifference(finalY, y) / 2;
    }

    void update() {
      y -= speed;

      if (y + radius <= finalY) { 
        isDone = true;
      } else if (y + radius > finalY) {
        final double position = (y + colorTransition) / (0 + colorTransition);
        color = Color.lerp(endColor, startColor, position)!;
      }
    }
  }

  double calculateDifference(double num1, double num2) {
    double minNum = num1 < num2 ? num1 : num2;
    double maxNum = num1 > num2 ? num1 : num2;
    return maxNum - minNum;
  }

  class BubblePainter extends CustomPainter {
    final List<Bubble> bubbles;

    BubblePainter({required this.bubbles});

    @override
    void paint(Canvas canvas, Size size) {
      final paint = Paint()..style = PaintingStyle.fill;
      
      for (var bubble in bubbles) {
        paint.color = bubble.color;
        canvas.drawCircle(Offset(bubble.x, bubble.y), bubble.radius, paint);
      }
    }

    @override
    bool shouldRepaint(BubblePainter oldDelegate) {
      return true;
    }
  }
