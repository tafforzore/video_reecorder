import 'package:flutter/material.dart';

class CyberActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final Color glowColor;

  const CyberActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.tooltip,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              glowColor.withOpacity(0.3),
              Colors.transparent,
            ],
            stops: const [0.1, 1.0],
            radius: 1.5,
          ),
        ),
        child: IconButton(
          onPressed: onTap,
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  glowColor.withOpacity(0.8),
                  glowColor.withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                color: glowColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class VlcCyberAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final List<CyberActionButton> actions;
  final VoidCallback? onMenuTap;
  final VoidCallback onPressedButton;
  final String textOnPressed;

  const VlcCyberAppBar({
    super.key,
    required this.title,
    required this.onPressedButton,
    required this.textOnPressed,
    this.subtitle = '',
    this.actions = const [],
    this.onMenuTap,
  });

  /// 🔥 Hauteur réaliste
  @override
  Size get preferredSize => const Size.fromHeight(128);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0A0A1A),
              const Color(0xFF151530).withOpacity(0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border(
            bottom: BorderSide(
              color: Colors.cyanAccent.withOpacity(0.2),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 🔥 IMPORTANT
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔝 BARRE SUPÉRIEURE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (onMenuTap != null)
                      GestureDetector(
                        onTap: onMenuTap,
                        child: _menuButton(),
                      )
                    else
                      const SizedBox(width: 40),

                    Row(children: actions),
                  ],
                ),

                const SizedBox(height: 12),

                /// 🏷️ TITRE
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _vlcIcon(),
                    const SizedBox(width: 12),

                    /// 🔥 TEXTE FLEXIBLE
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                              height: 1.1,
                              shadows: [
                                Shadow(
                                  color: Colors.cyanAccent.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          TextButton(onPressed: onPressedButton, child: Text(textOnPressed)),
                          if (subtitle.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.blueGrey.shade300,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),
                    _clockWidget(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// --- Widgets séparés (lisibilité & stabilité) ---

  Widget _menuButton() => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        colors: [
          Colors.cyanAccent.withOpacity(0.2),
          Colors.blueAccent.withOpacity(0.2),
        ],
      ),
      border: Border.all(
        color: Colors.cyanAccent.withOpacity(0.3),
      ),
    ),
    child: const Icon(
      Icons.menu,
      color: Colors.cyanAccent,
      size: 20,
    ),
  );

  Widget _vlcIcon() => Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Colors.orangeAccent, Colors.redAccent],
      ),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.orangeAccent.withOpacity(0.4),
          blurRadius: 8,
        ),
      ],
    ),
    child: const Icon(
      Icons.play_arrow,
      color: Colors.black,
      size: 18,
    ),
  );

  Widget _clockWidget() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.cyanAccent.withOpacity(0.1),
          Colors.blueAccent.withOpacity(0.1),
        ],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Colors.cyanAccent.withOpacity(0.2),
      ),
    ),
    child: StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        return Text(
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: 'Digital',
            letterSpacing: 1.5,
          ),
        );
      },
    ),
  );
}
