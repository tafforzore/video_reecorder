import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? icon;
  final Widget? label;
  final String? text;
  final IconData? iconData;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? glowColor;
  final Color? borderColor;
  final double? elevation;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? padding;
  final bool isExtended;
  final bool isLoading;
  final double? width;
  final double? height;
  final List<Color>? gradientColors;
  final bool withGlowEffect;
  final double glowRadius;

  const ActionButtons({
    super.key,
    required this.onPressed,
    this.icon,
    this.label,
    this.text,
    this.iconData,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.glowColor,
    this.borderColor,
    this.elevation,
    this.shape,
    this.padding,
    this.isExtended = false,
    this.isLoading = false,
    this.width,
    this.height,
    this.gradientColors,
    this.withGlowEffect = true,
    this.glowRadius = 10.0,
  });

  factory ActionButtons.cyber({
    Key? key,
    required VoidCallback onPressed,
    required String text,
    IconData? icon,
    Color? primaryColor = Colors.cyanAccent,
    bool isExtended = true,
    bool isLoading = false,
  }) {
    return ActionButtons(
      key: key,
      onPressed: onPressed,
      text: text,
      iconData: icon,
      isExtended: isExtended,
      isLoading: isLoading,
      glowColor: primaryColor,
      gradientColors: [
        primaryColor!.withOpacity(0.8),
        primaryColor.withOpacity(0.4),
      ],
      backgroundColor: Colors.transparent,
      textColor: primaryColor,
      iconColor: Colors.black,
      borderColor: primaryColor.withOpacity(0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryGlowColor = glowColor ?? Colors.cyanAccent;
    final primaryTextColor = textColor ?? Colors.cyanAccent;
    final primaryIconColor = iconColor ?? Colors.black;
    final primaryBorderColor = borderColor ?? Colors.cyanAccent.withOpacity(0.5);
    final primaryGradientColors = gradientColors ?? [
      Colors.cyanAccent.withOpacity(0.8),
      Colors.blueAccent.withOpacity(0.8),
    ];

    return Container(
      width: width,
      height: height,
      decoration: withGlowEffect
          ? BoxDecoration(
        borderRadius: shape is RoundedRectangleBorder
            ? (shape as RoundedRectangleBorder).borderRadius as BorderRadius?
            : BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: primaryGlowColor.withOpacity(0.3),
            blurRadius: glowRadius,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: primaryGlowColor.withOpacity(0.1),
            blurRadius: glowRadius * 2,
            spreadRadius: 4,
          ),
        ],
      )
          : null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: shape is RoundedRectangleBorder
              ? (shape as RoundedRectangleBorder).borderRadius as BorderRadius?
              : BorderRadius.circular(25),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: primaryGradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: shape is RoundedRectangleBorder
                  ? (shape as RoundedRectangleBorder).borderRadius as BorderRadius?
                  : BorderRadius.circular(25),
              border: Border.all(
                color: primaryBorderColor,
                width: 1,
              ),
            ),
            child: Container(
              padding: padding ??
                  EdgeInsets.symmetric(
                    horizontal: isExtended ? 24 : 16,
                    vertical: 12,
                  ),
              child: isLoading
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(primaryIconColor),
                ),
              )
                  : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildContent(primaryIconColor, primaryTextColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(Color iconColor, Color textColor) {
    final content = <Widget>[];

    if (isLoading) return content;

    // Icon
    if (icon != null) {
      content.add(icon!);
    } else if (iconData != null) {
      content.add(Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.2),
        ),
        child: Icon(
          iconData,
          color: iconColor,
          size: 20,
        ),
      ));
    }

    if (isExtended && (icon != null || iconData != null)) {
      content.add(const SizedBox(width: 12));
    }

    // Label/Text
    if (label != null) {
      content.add(label!);
    } else if (text != null && isExtended) {
      content.add(Text(
        text!.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ));
    }

    return content;
  }
}

// Variante Cyberpunk avec effet de scan lines
class CyberActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final bool isActive;
  final bool withScanEffect;

  const CyberActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color = Colors.cyanAccent,
    this.isActive = false,
    this.withScanEffect = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isActive
                ? [
              color.withOpacity(0.2),
              color.withOpacity(0.1),
            ]
                : [
              Colors.transparent,
              Colors.transparent,
            ],
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(isActive ? 0.3 : 0.1),
            width: 1,
          ),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon avec effet
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.8),
                    color.withOpacity(0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Effet de scan lines
                  if (withScanEffect && isActive)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  Icon(
                    icon,
                    color: Colors.black,
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Bouton d'action circulaire futuriste
class CyberCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final String? tooltip;
  final double size;
  final bool isActive;
  final bool withHoverEffect;

  const CyberCircleButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = Colors.cyanAccent,
    this.tooltip,
    this.size = 48,
    this.isActive = false,
    this.withHoverEffect = true,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withOpacity(isActive ? 0.3 : 0.1),
                  Colors.transparent,
                ],
                stops: const [0.1, 1.0],
                radius: 1.5,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Effet de lueur
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.8),
                        color.withOpacity(0.4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),

                // Icon
                Icon(
                  icon,
                  color: Colors.black,
                  size: size * 0.5,
                ),

                // Indicateur d'activité
                if (isActive)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Groupe de boutons d'action futuristes
class ActionButtonGroup extends StatelessWidget {
  final List<Widget> children;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsetsGeometry padding;

  const ActionButtonGroup({
    super.key,
    required this.children,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: direction == Axis.horizontal
          ? Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      )
          : Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
  }
}