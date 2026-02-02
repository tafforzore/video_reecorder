import 'dart:ui';

import 'package:flutter/material.dart';

class VlcGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final double blurRadius;
  final VoidCallback? onTap;

  const VlcGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.blurRadius = 10,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade800.withOpacity(0.3),
              Colors.blue.shade400.withOpacity(0.1),
            ],
          ),
          border: Border.all(
            color: Colors.blue.shade300.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade900.withOpacity(0.2),
              blurRadius: blurRadius,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: _createBlurFilter(),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  ImageFilter _createBlurFilter() {
    return ImageFilter.blur(
      sigmaX: blurRadius * 0.5,
      sigmaY: blurRadius * 0.5,
    );
  }
}