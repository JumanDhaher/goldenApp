import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum GoldPlaceholderSize { small, medium, large }

class GoldPlaceholder extends StatelessWidget {
  final GoldPlaceholderSize size;
  final bool showAddLabel;
  final String? label;
  final Color? accentColor;

  const GoldPlaceholder({
    super.key,
    this.size = GoldPlaceholderSize.large,
    this.showAddLabel = false,
    this.label,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? AppColors.gold;

    switch (size) {
      case GoldPlaceholderSize.small:
        return _SmallPlaceholder(accent: accent);
      case GoldPlaceholderSize.medium:
        return _MediumPlaceholder(accent: accent, label: label);
      case GoldPlaceholderSize.large:
        return _LargePlaceholder(accent: accent, showAddLabel: showAddLabel, label: label);
    }
  }
}

// ─── Small: for cards (58×58) ───────────────────────────────────────────────
class _SmallPlaceholder extends StatelessWidget {
  final Color accent;
  const _SmallPlaceholder({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1800),
            const Color(0xFF0D0C00),
          ],
        ),
        border: Border.all(
          color: accent.withOpacity(0.35),
          width: 1,
        ),
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(28, 28),
          painter: _GemPainter(color: accent),
        ),
      ),
    );
  }
}

// ─── Medium: for add/edit image picker ──────────────────────────────────────
class _MediumPlaceholder extends StatelessWidget {
  final Color accent;
  final String? label;
  const _MediumPlaceholder({required this.accent, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.9,
          colors: [
            const Color(0xFF1C1900),
            const Color(0xFF0A0A00),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glowing ring with camera icon
          _GlowRing(
            accent: accent,
            size: 64,
            child: Icon(
              Icons.add_a_photo_rounded,
              color: accent,
              size: 26,
            ),
          ),
          const SizedBox(height: 12),
          if (label != null)
            Text(
              label!,
              style: TextStyle(
                color: accent.withOpacity(0.85),
                fontSize: 13,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Large: for detail screen ────────────────────────────────────────────────
class _LargePlaceholder extends StatelessWidget {
  final Color accent;
  final bool showAddLabel;
  final String? label;
  const _LargePlaceholder({
    required this.accent,
    required this.showAddLabel,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF111100),
            const Color(0xFF080800),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Subtle geometric pattern
          Positioned.fill(
            child: CustomPaint(painter: _HexPatternPainter(color: accent)),
          ),
          // Radial glow behind icon
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accent.withOpacity(0.12),
                    accent.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _GlowRing(
                  accent: accent,
                  size: 80,
                  ringWidth: 1.5,
                  child: CustomPaint(
                    size: const Size(38, 38),
                    painter: _GemPainter(color: accent),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 40,
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        accent.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                if (label != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    label!,
                    style: TextStyle(
                      color: accent.withOpacity(0.6),
                      fontSize: 13,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Glow ring wrapper ───────────────────────────────────────────────────────
class _GlowRing extends StatelessWidget {
  final Color accent;
  final double size;
  final double ringWidth;
  final Widget child;

  const _GlowRing({
    required this.accent,
    required this.size,
    this.ringWidth = 1.0,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: accent.withOpacity(0.4), width: ringWidth),
        color: accent.withOpacity(0.06),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}

// ─── Gem icon painter ────────────────────────────────────────────────────────
class _GemPainter extends CustomPainter {
  final Color color;
  const _GemPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    final paintFill = Paint()..style = PaintingStyle.fill;
    final paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = color;

    // Top crown
    final topY = h * 0.08;
    final midY = h * 0.38;
    final botY = h * 0.95;

    // Facet colors (lighter = top, darker = sides)
    final topColor = Color.lerp(color, Colors.white, 0.5)!;
    final leftColor = Color.lerp(color, Colors.black, 0.25)!;
    final rightColor = color;
    final centerColor = Color.lerp(color, Colors.white, 0.3)!;

    // Crown facets (top row)
    final crownPts = [
      Offset(cx * 0.2, midY),
      Offset(cx * 0.6, topY),
      Offset(cx, midY * 0.7),
      Offset(cx * 1.4, topY),
      Offset(cx * 1.8, midY),
    ];

    // Center top facet
    paintFill.color = topColor.withOpacity(0.9);
    canvas.drawPath(
      Path()
        ..moveTo(crownPts[0].dx, crownPts[0].dy)
        ..lineTo(crownPts[1].dx, crownPts[1].dy)
        ..lineTo(crownPts[2].dx, crownPts[2].dy)
        ..close(),
      paintFill,
    );
    paintFill.color = centerColor.withOpacity(0.9);
    canvas.drawPath(
      Path()
        ..moveTo(crownPts[1].dx, crownPts[1].dy)
        ..lineTo(crownPts[2].dx, crownPts[2].dy)
        ..lineTo(crownPts[3].dx, crownPts[3].dy)
        ..close(),
      paintFill,
    );
    paintFill.color = topColor.withOpacity(0.9);
    canvas.drawPath(
      Path()
        ..moveTo(crownPts[2].dx, crownPts[2].dy)
        ..lineTo(crownPts[3].dx, crownPts[3].dy)
        ..lineTo(crownPts[4].dx, crownPts[4].dy)
        ..close(),
      paintFill,
    );

    // Pavilion (bottom part)
    paintFill.color = leftColor.withOpacity(0.85);
    canvas.drawPath(
      Path()
        ..moveTo(crownPts[0].dx, crownPts[0].dy)
        ..lineTo(crownPts[2].dx, crownPts[2].dy)
        ..lineTo(cx, botY)
        ..close(),
      paintFill,
    );
    paintFill.color = rightColor.withOpacity(0.85);
    canvas.drawPath(
      Path()
        ..moveTo(crownPts[4].dx, crownPts[4].dy)
        ..lineTo(crownPts[2].dx, crownPts[2].dy)
        ..lineTo(cx, botY)
        ..close(),
      paintFill,
    );
    // Center pavilion
    paintFill.color = centerColor.withOpacity(0.7);
    canvas.drawPath(
      Path()
        ..moveTo(crownPts[0].dx, crownPts[0].dy)
        ..lineTo(crownPts[4].dx, crownPts[4].dy)
        ..lineTo(cx, botY)
        ..close(),
      paintFill,
    );

    // Outline
    final outline = Path()
      ..moveTo(crownPts[0].dx, crownPts[0].dy)
      ..lineTo(crownPts[1].dx, crownPts[1].dy)
      ..lineTo(crownPts[2].dx, crownPts[2].dy)
      ..lineTo(crownPts[3].dx, crownPts[3].dy)
      ..lineTo(crownPts[4].dx, crownPts[4].dy)
      ..lineTo(cx, botY)
      ..close();
    paintStroke.color = color.withOpacity(0.8);
    canvas.drawPath(outline, paintStroke);

    // Inner lines
    paintStroke.color = color.withOpacity(0.4);
    paintStroke.strokeWidth = 0.8;
    canvas.drawLine(crownPts[0], cx_offset(cx, botY), paintStroke);
    canvas.drawLine(crownPts[2], cx_offset(cx, botY), paintStroke);
    canvas.drawLine(crownPts[4], cx_offset(cx, botY), paintStroke);
    canvas.drawLine(crownPts[0], crownPts[4], paintStroke);
  }

  Offset cx_offset(double cx, double botY) => Offset(cx, botY);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Hex pattern background ──────────────────────────────────────────────────
class _HexPatternPainter extends CustomPainter {
  final Color color;
  const _HexPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const r = 28.0;
    final dx = r * math.sqrt(3);
    final dy = r * 1.5;

    int row = 0;
    for (double y = -r; y < size.height + r * 2; y += dy) {
      final offsetX = (row % 2 == 0) ? 0.0 : dx / 2;
      for (double x = -dx + offsetX; x < size.width + dx; x += dx) {
        _drawHex(canvas, Offset(x, y), r, paint);
      }
      row++;
    }
  }

  void _drawHex(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = math.pi / 180 * (60 * i - 30);
      final pt = Offset(
        center.dx + r * math.cos(angle),
        center.dy + r * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(pt.dx, pt.dy);
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
