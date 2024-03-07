import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

  class AnimateBubles extends StatefulWidget {
    final bool active;
    final int emitDuration;
    final int bubbleCount;
    final double distance;
    final Color color;
    final double radius;
    final Widget child;

    const AnimateBubles({
      required this.active,
      this.emitDuration = 300,
      this.bubbleCount = 1,
      this.distance = 50,
      this.color = Colors.blue,
      this.radius = 4.0,
      required this.child,
      super.key,
    });

    @override
    State<AnimateBubles> createState() => _AnimateBublesState();
  }

  class _AnimateBublesState extends State<AnimateBubles> {
    final _widgetKey = GlobalKey();
    final newtonKey = GlobalKey<NewtonState>();
    EffectConfiguration _effectConfiguration = const EffectConfiguration(
      minDuration: 4000,
      maxDuration: 7000,
      minFadeOutThreshold: 0.6,
      maxFadeOutThreshold: 0.8,
    );
    late Effect _effect;
    late Effect _finalEffect;
    Size? _canvasSize;

    @override
    void initState() {
      super.initState();
      //WidgetsBinding.instance.addPostFrameCallback(reSizeCanvas);
      Future.delayed(const Duration(milliseconds: (1000 ~/ 16)), () {
          reSizeCanvas();
      });
    }

    Future<ui.Image> _generateImage() async {
      final pictureRecorder = ui.PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      final painter = PillPainter(color: widget.color);
      painter.paint(canvas, const Size(50, 100));
      final picture = pictureRecorder.endRecording();
      final image = await picture.toImage(50, 100);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List imageData = byteData!.buffer.asUint8List();
      ui.Codec codec = await ui.instantiateImageCodec(imageData);
      ui.FrameInfo frameInfo = await codec.getNextFrame();
      return frameInfo.image;
    }

    void reSizeCanvas() {
      var context = _widgetKey.currentContext;
      if (context != null && context.size != null) {
        _canvasSize = context.size;
        _effectConfiguration = _effectConfiguration.copyWith(
          origin: Offset(_canvasSize!.width/2, _canvasSize!.height - widget.distance),
          emitDuration: widget.emitDuration,
          particlesPerEmit: widget.bubbleCount,
          maxDistance: _canvasSize!.height,
          minBeginScale: widget.radius,
          maxBeginScale: widget.radius,
          minEndScale: widget.radius,
          maxEndScale: widget.radius,
        );
        _generateImage().then((ui.Image image) {
          _effect = SmokeEffect(
            particleConfiguration: ParticleConfiguration(
              shape: ImageShape(image),
              size: Size(widget.radius, widget.radius),
              color: SingleParticleColor(color: widget.color),
            ),
            smokeWidth: _canvasSize!.width - 20 - widget.radius * 2,
            effectConfiguration: _effectConfiguration,
          );
          setState(() {
            if (widget.active == true ) {
              _finalEffect = _effect;
              newtonKey.currentState?.addEffect(_finalEffect);
              _finalEffect.start();
            }
          });
        });
      }
    }

    @override
    void didUpdateWidget(covariant AnimateBubles oldWidget) {
      super.didUpdateWidget(oldWidget);
      if (widget.active != oldWidget.active) {
        setState(() {
          if (widget.active == true) {
            _finalEffect = _effect;
            _finalEffect.start();
          }
          else {
            _finalEffect.stop();
          }
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Center(
        child: Newton(
          key: newtonKey, 
          child: Padding(
            key: _widgetKey,
            padding: EdgeInsets.only(top: widget.distance),
            child: widget.child
          ),
        ),
      );
    }
  }

  class PillPainter extends CustomPainter {
  final Color color;

  PillPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final radius = size.height / 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
