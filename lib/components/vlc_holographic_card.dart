import 'package:flutter/material.dart';

class VlcHolographicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blurRadius;
  final List<Color>? gradientColors;
  final bool withGlow;
  final Color glowColor;
  final VoidCallback? onTap;
  final bool isInteractive;

  const VlcHolographicCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.blurRadius = 20,
    this.gradientColors,
    this.withGlow = true,
    this.glowColor = Colors.cyanAccent,
    this.onTap,
    this.isInteractive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ??
        const [
          Color(0x10FFFFFF),
          Color(0x05FFFFFF),
        ];

    return Container(
      margin: margin,
      child: Stack(
        clipBehavior: Clip.none, // glow externe autorisé
        children: [
          /// 🌟 GLOW EXTERNE (hors layout, sans overflow)
          if (withGlow)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withOpacity(0.08),
                        blurRadius: blurRadius,
                        spreadRadius: 0, // 🔥 PAS DE SPREAD
                      ),
                    ],
                  ),
                ),
              ),
            ),

          /// 🧱 CARTE PRINCIPALE (CLIPPÉE)
          ClipRRect(
            borderRadius:
            BorderRadius.circular(borderRadius + blurRadius),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(borderRadius),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: glowColor.withOpacity(0.15),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Stack(
                      clipBehavior: Clip.hardEdge, // 🔥 ANTI OVERFLOW
                      children: [
                        /// ✨ HOLOGRAPHIC SWEEP
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    glowColor.withOpacity(0.03),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// 🔲 BORDURE INTERNE
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(borderRadius),
                                border: Border.all(
                                  color: glowColor.withOpacity(0.1),
                                  width: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// 📦 CONTENU (CONTRAINT)
                        Padding(
                          padding:
                          padding ?? const EdgeInsets.all(16),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: constraints.maxWidth,
                                  maxHeight: constraints.maxHeight,
                                ),
                                child: child,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// 🖱️ CURSEUR INTERACTIF
          if (isInteractive && onTap != null)
            Positioned.fill(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );
  }
}

// Variante de carte pour les éléments de liste
class VlcHolographicListItem extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool isSelected;
  final VoidCallback? onTap;

  const VlcHolographicListItem({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VlcHolographicCard(
      padding: padding,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      borderRadius: 12,
      blurRadius: isSelected ? 30 : 10,
      withGlow: isSelected,
      glowColor: isSelected ? Colors.cyanAccent : Colors.blueGrey,
      gradientColors: isSelected
          ? [
        Colors.cyanAccent.withOpacity(0.15),
        Colors.blueAccent.withOpacity(0.08),
      ]
          : [
        const Color(0x08FFFFFF),
        const Color(0x04FFFFFF),
      ],
      onTap: onTap,
      isInteractive: onTap != null,
      child: child,
    );
  }
}