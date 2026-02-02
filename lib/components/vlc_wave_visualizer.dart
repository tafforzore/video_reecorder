import 'dart:math';
import 'package:flutter/material.dart';

class VlcWaveVisualizer extends StatefulWidget {
  final bool isPlaying;
  final Color color;
  final Color backgroundColor;
  final int barCount;
  final double height;
  final double width;
  final double maxBarHeight;
  final double minBarHeight;
  final Duration animationDuration;
  final Curve animationCurve;

  const VlcWaveVisualizer({
    super.key,
    required this.isPlaying,
    this.color = Colors.cyanAccent,
    this.backgroundColor = Colors.transparent,
    this.barCount = 12,
    this.height = 40,
    this.width = double.infinity,
    this.maxBarHeight = 0.9,
    this.minBarHeight = 0.1,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  State<VlcWaveVisualizer> createState() => _VlcWaveVisualizerState();
}

class _VlcWaveVisualizerState extends State<VlcWaveVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Random _random = Random();
  List<double> _barHeights = [];
  List<double> _targetHeights = [];

  @override
  void initState() {
    super.initState();

    // Initialiser les hauteurs des barres
    _barHeights = List.generate(widget.barCount,
            (index) => widget.minBarHeight + (widget.maxBarHeight - widget.minBarHeight) * _random.nextDouble());
    _targetHeights = List.from(_barHeights);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void didUpdateWidget(VlcWaveVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
        // Réduire les barres à la hauteur minimale
        _targetHeights = List.generate(
          widget.barCount,
              (index) => widget.minBarHeight,
        );
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateBarHeights() {
    if (widget.isPlaying) {
      // Générer de nouvelles hauteurs aléatoires pour l'animation
      _targetHeights = List.generate(
        widget.barCount,
            (index) {
          // Créer un motif plus organique
          double base = widget.minBarHeight +
              (widget.maxBarHeight - widget.minBarHeight) *
                  (0.5 + 0.5 * sin(index * 0.8 + _controller.value * 4 * pi));

          // Ajouter du bruit aléatoire
          double noise = 0.2 * (_random.nextDouble() - 0.5);

          return (base + noise).clamp(widget.minBarHeight, widget.maxBarHeight);
        },
      );
    }

    // Interpoler vers les hauteurs cibles
    _barHeights = List.generate(
      widget.barCount,
          (index) {
        double current = _barHeights[index];
        double target = _targetHeights[index];
        return current + (target - current) * 0.3;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        _updateBarHeights();

        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: CustomPaint(
            painter: _WaveVisualizerPainter(
              barHeights: _barHeights,
              color: widget.color,
              isPlaying: widget.isPlaying,
              controllerValue: _controller.value,
            ),
          ),
        );
      },
    );
  }
}

class _WaveVisualizerPainter extends CustomPainter {
  final List<double> barHeights;
  final Color color;
  final bool isPlaying;
  final double controllerValue;

  _WaveVisualizerPainter({
    required this.barHeights,
    required this.color,
    required this.isPlaying,
    required this.controllerValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final barWidth = size.width / barHeights.length;
    final spacing = barWidth * 0.3;
    final actualBarWidth = barWidth - spacing;

    // Effet de lueur derrière les barres
    if (isPlaying) {
      final glowPaint = Paint()
        ..color = color.withOpacity(0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      for (int i = 0; i < barHeights.length; i++) {
        final x = i * barWidth + spacing / 2;
        final height = barHeights[i] * size.height;
        final y = size.height - height;

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, actualBarWidth, height),
            Radius.circular(actualBarWidth / 4),
          ),
          glowPaint,
        );
      }
    }

    // Dessiner les barres
    for (int i = 0; i < barHeights.length; i++) {
      final x = i * barWidth + spacing / 2;
      final height = barHeights[i] * size.height;
      final y = size.height - height;

      // Effet de dégradé sur la barre
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            color.withOpacity(0.9),
            color.withOpacity(0.6),
            color.withOpacity(0.3),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(x, y, actualBarWidth, height));

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, actualBarWidth, height),
          Radius.circular(actualBarWidth / 4),
        ),
        gradientPaint,
      );

      // Bordure lumineuse
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, actualBarWidth, height),
          Radius.circular(actualBarWidth / 4),
        ),
        strokePaint,
      );

      // Effet de particules sur les barres hautes
      if (isPlaying && barHeights[i] > 0.7) {
        final particlePaint = Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.fill;

        final particleCount = 2;
        for (int j = 0; j < particleCount; j++) {
          final particleY = y + height * (j + 1) / (particleCount + 1);
          final particleX = x + actualBarWidth / 2;

          canvas.drawCircle(
            Offset(particleX, particleY),
            actualBarWidth / 8,
            particlePaint,
          );
        }
      }
    }

    // Effet de ligne d'onde en haut
    if (isPlaying) {
      final wavePaint = Paint()
        ..color = color.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..shader = LinearGradient(
          colors: [
            color.withOpacity(0.8),
            Colors.transparent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(Rect.fromLTRB(0, 0, size.width, 0));

      final path = Path();
      path.moveTo(0, size.height * (1 - barHeights[0]));

      for (int i = 1; i < barHeights.length; i++) {
        final x = i * barWidth + actualBarWidth / 2;
        final y = size.height * (1 - barHeights[i]);
        path.lineTo(x, y);
      }

      canvas.drawPath(path, wavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Variante circulaire du visualiseur
class VlcCircularWaveVisualizer extends StatelessWidget {
  final bool isPlaying;
  final Color color;
  final double size;
  final int barCount;

  const VlcCircularWaveVisualizer({
    super.key,
    required this.isPlaying,
    this.color = Colors.cyanAccent,
    this.size = 100,
    this.barCount = 32,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CircularWavePainter(
          isPlaying: isPlaying,
          color: color,
          barCount: barCount,
        ),
      ),
    );
  }
}

class _CircularWavePainter extends CustomPainter {
  final bool isPlaying;
  final Color color;
  final int barCount;

  _CircularWavePainter({
    required this.isPlaying,
    required this.color,
    required this.barCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;
    final barWidth = (2 * pi * radius) / barCount * 0.5;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final random = Random();

    for (int i = 0; i < barCount; i++) {
      final angle = 2 * pi * i / barCount;
      final height = isPlaying
          ? 5 + random.nextDouble() * 15
          : 2;

      final start = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      final end = Offset(
        center.dx + (radius + height) * cos(angle),
        center.dy + (radius + height) * sin(angle),
      );

      paint.strokeWidth = barWidth;
      paint.strokeCap = StrokeCap.round;

      canvas.drawLine(start, end, paint);
    }

    // Centre avec effet de lueur
    if (isPlaying) {
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withOpacity(0.3),
            Colors.transparent,
          ],
          stops: const [0.1, 0.8],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 0.5));

      canvas.drawCircle(center, radius * 0.3, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}