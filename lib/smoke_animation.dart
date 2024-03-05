import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

  class AnimateBubles extends StatefulWidget {
    final bool active;
    final int emitDuration;
    final int bubbleCount;
    final Color color;
    final double radius;
    final Widget child;

    const AnimateBubles({
      required this.active,
      this.emitDuration = 300,
      this.bubbleCount = 1,
      this.color = Colors.blue,
      this.radius = 4.0,
      required this.child,
      super.key
    });

    @override
    State<AnimateBubles> createState() => _AnimateBublesState();
  }

  class _AnimateBublesState extends State<AnimateBubles> {
    final widgetKey = GlobalKey();
    final newtonKey = GlobalKey<NewtonState>();
    final List<Effect> _activeEffects = [];
    EffectConfiguration _effectConfiguration = const EffectConfiguration(
      minDuration: 4000,
      maxDuration: 7000,
      minFadeOutThreshold: 0.6,
      maxFadeOutThreshold: 0.8,
    );
    late Effect _effect;
    late double _canvasHeight;
    Size? _canvasSize;

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback(reSizeCanvas);
    }

    void reSizeCanvas(Duration updateTime) {
      var context = widgetKey.currentContext;
      if (context != null && context.size != null) {
        _canvasSize = context.size;
        _canvasHeight = _canvasSize!.height + _canvasSize!.height/2;
        _effectConfiguration = _effectConfiguration.copyWith(
          origin: Offset(_canvasSize!.width/2, _canvasSize!.height),
          emitDuration: widget.emitDuration,
          particlesPerEmit: widget.bubbleCount,
          maxDistance: _canvasSize!.height,
          minBeginScale: widget.radius,
          maxBeginScale: widget.radius,
          minEndScale: widget.radius,
          maxEndScale: widget.radius,
        );
        _effect = SmokeEffect(
          particleConfiguration: ParticleConfiguration(
            shape: CircleShape(),
            size: Size(widget.radius, widget.radius),
            color: SingleParticleColor(color: widget.color),
          ),
          smokeWidth: _canvasSize!.width - 20 - widget.radius * 2,
          effectConfiguration: _effectConfiguration,
        );
        setState(() {
          if (widget.active == true ) {
            _activeEffects.add(_effect);
            _activeEffects[_activeEffects.length-1].start(); 
          }
        });
      }
    }

    @override
    void didUpdateWidget(covariant AnimateBubles oldWidget) {
      super.didUpdateWidget(oldWidget);
      if (widget.active != oldWidget.active) {
        setState(() {
          if (widget.active == true) {
            _activeEffects[_activeEffects.length-1] = _effect;
            _activeEffects[_activeEffects.length-1].start();
          }
          else {
            _activeEffects[_activeEffects.length-1].stop();
          }
        });
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
                        activeEffects: _activeEffects,
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
