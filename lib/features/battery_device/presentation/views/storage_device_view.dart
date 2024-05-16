import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryDeviceView extends StatefulWidget {
  const BatteryDeviceView({super.key});

  @override
  State<BatteryDeviceView> createState() => _BatteryDeviceViewState();
}

class _BatteryDeviceViewState extends State<BatteryDeviceView>
    with SingleTickerProviderStateMixin {
  static const platform = MethodChannel('com.example.battery/battery');

  String _batteryLevel = 'Battery level: unknown.';
  double _batteryPercentage = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller);

    _getBatteryLevel();
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    double batteryPercentage;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = '$result';
      batteryPercentage = result / 100;
    } on PlatformException catch (e) {
      batteryLevel = "${e.message}";
      batteryPercentage = 0.0;
    }

    setState(() {
      _batteryLevel = batteryLevel;
      _batteryPercentage = batteryPercentage;
      _controller.forward(from: 0.0);
    });

    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        _controller.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battery Level'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 350,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: BatteryPainter(
                      _animation.value,
                      _batteryPercentage,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Battery level: $_batteryLevel%.",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class BatteryPainter extends CustomPainter {
  final double animationValue;
  final double fillPercentage;

  BatteryPainter(this.animationValue, this.fillPercentage);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final waveHeight = size.height * 0.02;
    final baseHeight = size.height * (1 - fillPercentage);

    final path = Path();
    path.moveTo(0, baseHeight);

    for (double x = 0; x <= size.width; x++) {
      //Logic to create a wave effect
      final y = baseHeight +
          waveHeight *
              sin(
                (x / size.width * 2 * pi) + animationValue,
              );
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
