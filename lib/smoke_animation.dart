import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

  class AnimateBubles extends StatefulWidget {
    final bool active;
    final double speed;
    final int bubbleCount;
    final Color color;
    final double radius;
    final Widget child;

    const AnimateBubles({
      required this.active,
      this.speed = 1.0,
      this.bubbleCount = 10,
      this.color = Colors.blue,
      this.radius = 8.0,
      required this.child,
        super.key
    });

    @override
    State<AnimateBubles> createState() => _AnimateBublesState();
  }

  class _AnimateBublesState extends State<AnimateBubles> {
    var widgetKey = GlobalKey();
    final newtonKey = GlobalKey<NewtonState>();
    EffectConfiguration _effectConfiguration =
      const EffectConfiguration(
        particlesPerEmit: 1,
        emitDuration: 300,
        maxDistance: 100,
        minAngle: 0,
        maxAngle: 0,
        minDuration: 4000,
        maxDuration: 7000,
        minFadeOutThreshold: 0.6,
        maxFadeOutThreshold: 0.8,
        minBeginScale: 3,
        maxBeginScale: 3,
        minEndScale: 3,
        maxEndScale: 3,
      );
    late Effect _effect;
    late double _canvasHeight;
    Size? _canvasSize;

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        var context = widgetKey.currentContext;
        if (context != null && context.size != null) {
          _canvasSize = context.size;
          _canvasHeight = _canvasSize!.height + _canvasSize!.height/2;
          _effectConfiguration = _effectConfiguration.copyWith(
            origin: Offset(_canvasSize!.width/2, _canvasSize!.height),
            maxDistance: _canvasSize!.height,
          );
          _effect = SmokeEffect(
            particleConfiguration: ParticleConfiguration(
                shape: CircleShape(),
                size: const Size(5, 5),
                color: SingleParticleColor(color: widget.color),
            ),
            smokeWidth: _canvasSize!.width - 20,
            effectConfiguration: _effectConfiguration,
          );
          setState(() {
            
            if (widget.active == true ) {
              _effect.start(); 
            }
          });
        }
      });
    }

    @override
    void didUpdateWidget(covariant AnimateBubles oldWidget) {
      super.didUpdateWidget(oldWidget);
      if (widget.active != oldWidget.active) {
        if (widget.active == true ) {
          _effect.start(); 
        }
        else {
          _effect.stop();
        }
      } 
    }

    @override
    Widget build(BuildContext context) {
      return Column(
        children: [
          Stack(
            key: widgetKey,
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              if (_canvasSize != null)
              ...[
                  SizedBox(
                    width: _canvasSize!.width, 
                    height: _canvasHeight, 
                    child: Center(
                      child: Newton(
                        key: newtonKey, 
                        activeEffects: [_effect],
                    ),
                  ),
                ),
              ],
              widget.child,
            ],
          ),
        ]
      );
    }
  }
