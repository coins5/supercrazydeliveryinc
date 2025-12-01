import 'package:flutter/material.dart';
import 'dart:math' as math;

class FireBorder extends StatefulWidget {
  final Widget child;
  final bool isActive;
  final BorderRadius borderRadius;

  const FireBorder({
    super.key,
    required this.child,
    this.isActive = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  State<FireBorder> createState() => _FireBorderState();
}

class _FireBorderState extends State<FireBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) return widget.child;

    return CustomPaint(
      painter: _FirePainter(
        animationValue: _controller,
        borderRadius: widget.borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0), // Space for flames
        child: widget.child,
      ),
    );
  }
}

class _FirePainter extends CustomPainter {
  final Animation<double> animationValue;
  final BorderRadius borderRadius;

  _FirePainter({required this.animationValue, required this.borderRadius})
    : super(repaint: animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // Inner rect for the content (approximate based on padding)
    // final innerRect = rect.deflate(4.0);
    // final rrect = borderRadius.toRRect(innerRect);

    // final paint = Paint()..style = PaintingStyle.fill;

    // We will draw flames extending OUTWARDS from the rrect.
    // To do this effectively, we can iterate around the perimeter.
    // Or simpler: Draw multiple layers of "blobs" or "waves" behind the content.

    // Let's try a multi-layered wave approach.
    // Layer 1: Red (Outer, Slow)
    _drawFlameLayer(
      canvas,
      rect,
      Colors.red,
      offset: 0,
      amplitude: 6.0,
      frequency: 2.0,
      speed: 1.0,
    );

    // Layer 2: Orange (Middle, Medium)
    _drawFlameLayer(
      canvas,
      rect,
      Colors.orange,
      offset: 1.5,
      amplitude: 5.0,
      frequency: 3.0,
      speed: 1.5,
    );

    // Layer 3: Yellow (Inner, Fast)
    _drawFlameLayer(
      canvas,
      rect,
      Colors.yellow,
      offset: 3.0,
      amplitude: 3.0,
      frequency: 5.0,
      speed: 2.5,
    );
  }

  void _drawFlameLayer(
    Canvas canvas,
    Rect rect,
    Color color, {
    required double offset,
    required double amplitude,
    required double frequency,
    required double speed,
  }) {
    final path = Path();
    final center = rect.center;
    // We want to draw a shape that is roughly the rect but with wavy edges.
    // Since it's a rounded rect, let's sample points around it.

    // Number of points to sample
    const int steps = 100;
    final double time = animationValue.value * 2 * math.pi * speed;

    // We can trace the RRect.
    // Or simpler: Just trace a slightly larger RRect and perturb the points.
    // Let's trace a circle/oval for simplicity? No, button is rectangular.

    // Let's walk the perimeter of the rounded rect.
    // Top edge
    for (int i = 0; i <= steps; i++) {
      // double t = i / steps;
      // Map t to perimeter position
      // This is complex to get perfect RRect mapping.
      // Let's use a simplified approach: Polar coordinates from center?
      // Rectangular buttons are not good for polar.

      // Approach: Perturb the RRect boundary directly.
      // We can't easily "get point at t" on RRect without logic.
      // Let's just draw a shape that encompasses the rect.
    }

    // ALTERNATIVE: Draw many small circles (particles) along the edge? Expensive.
    // ALTERNATIVE: Use a shader? Too complex for this tool.

    // BEST APPROACH for "Jagged Fire":
    // Draw the RRect but inflate it by a variable amount based on noise/sine.
    // Since we can't easily inflate "per vertex", let's construct a Path manually.

    List<Offset> points = [];
    double w = rect.width;
    double h = rect.height;
    double r = borderRadius.topLeft.x; // Assume uniform

    // Top Edge
    for (double x = r; x <= w - r; x += w / 20) {
      points.add(Offset(x, 0));
    }
    // Right Edge
    for (double y = r; y <= h - r; y += h / 10) {
      points.add(Offset(w, y));
    }
    // Bottom Edge
    for (double x = w - r; x >= r; x -= w / 20) {
      points.add(Offset(x, h));
    }
    // Left Edge
    for (double y = h - r; y >= r; y -= h / 10) {
      points.add(Offset(0, y));
    }

    // Now connect them with perturbations
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      // Calculate normal vector (roughly pointing out from center)
      double dx = p.dx - center.dx;
      double dy = p.dy - center.dy;
      double angle = math.atan2(dy, dx);

      // Noise function based on angle and time
      double noise =
          math.sin(angle * frequency + time) +
          0.5 * math.sin(angle * frequency * 2.3 - time * 1.5);

      // Make flames go UP more (negative Y)
      double upBias = (math.sin(angle) < -0.5) ? 1.5 : 1.0;

      double dist = amplitude * (1 + 0.5 * noise) * upBias;

      // Add perturbation
      double nx = p.dx + math.cos(angle) * dist;
      double ny = p.dy + math.sin(angle) * dist;

      // Close the corners smoothly?
      // Just lineTo for now.
      path.lineTo(nx, ny);
    }
    path.close();

    canvas.drawPath(path, Paint()..color = color.withValues(alpha: 0.7));
  }

  @override
  bool shouldRepaint(covariant _FirePainter oldDelegate) => true;
}
