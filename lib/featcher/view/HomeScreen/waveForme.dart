import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WaveformProgress extends StatelessWidget {
  final double progress;

  const WaveformProgress({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: double.infinity,
      child: CustomPaint(
        painter: WavePainter(progress),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double progress;

  WavePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paintInactive = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2;

    final paintActive = Paint()
      ..color = Colors.deepPurple
      ..strokeWidth = 2;

    int barCount = 40;
    double barWidth = size.width / barCount;

    for (int i = 0; i < barCount; i++) {
      double x = i * barWidth;
      double barHeight = (i % 5 + 1) * 2.0;

      final paint =
      (i / barCount) < progress ? paintActive : paintInactive;

      canvas.drawLine(
        Offset(x, size.height / 2 - barHeight),
        Offset(x, size.height / 2 + barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}