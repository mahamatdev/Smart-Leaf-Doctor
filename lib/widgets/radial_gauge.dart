import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Displays a radial confidence gauge showing model confidence.
/// Ranges from 0.0 to 1.0 (0–100%)
class RadialGauge extends StatelessWidget {
  final double confidence;

  const RadialGauge({super.key, required this.confidence});

  @override
  Widget build(BuildContext context) {
    final double percent = (confidence * 100).clamp(0, 100);
    final bool healthy = percent > 70;

    return Column(
      children: [
        SizedBox(
          width: 180,
          height: 180,
          child: CustomPaint(
            painter: _GaugePainter(
              percentage: percent,
              color: healthy ? Colors.green : Colors.orangeAccent,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${percent.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: healthy ? Colors.green.shade700 : Colors.orange.shade800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    healthy ? 'CONFIDENT'.toUpperCase() : 'UNCERTAIN'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 13,
                      color: healthy ? Colors.green.shade600 : Colors.orange.shade700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double percentage;
  final Color color;

  _GaugePainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 12.0;
    final radius = (size.width / 2) - strokeWidth;

    final center = Offset(size.width / 2, size.height / 2);
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final sweepAngle = 2 * math.pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      oldDelegate.percentage != percentage || oldDelegate.color != color;
}
