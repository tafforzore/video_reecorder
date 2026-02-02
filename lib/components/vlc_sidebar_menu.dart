import 'package:flutter/material.dart';

class SidebarSection {
  final String title;
  final List<SidebarItem> items;

  SidebarSection({required this.title, required this.items});
}

class SidebarItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final List<SidebarChildItem>? children;
  final bool isActive;
  final Color? activeColor;

  SidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.children,
    this.isActive = false,
    this.activeColor,
  });
}

class SidebarChildItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  SidebarChildItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.isActive = false,
  });
}

class VlcSidebarMenu extends StatefulWidget {
  final List<SidebarSection> sections;
  final double width;
  final Color backgroundColor;
  final Color activeColor;

  const VlcSidebarMenu({
    super.key,
    required this.sections,
    this.width = 280,
    this.backgroundColor = const Color(0xFF0A0A1A),
    this.activeColor = Colors.cyanAccent,
  });

  @override
  State<VlcSidebarMenu> createState() => _VlcSidebarMenuState();
}

class _VlcSidebarMenuState extends State<VlcSidebarMenu> {
  final Map<String, bool> _expandedSections = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.backgroundColor,
            Color.lerp(widget.backgroundColor, Colors.black, 0.2)!,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          right: BorderSide(
            color: Colors.cyanAccent.withOpacity(0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo VLC futuriste
          _buildLogo(),

          // Effet de séparateur
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.cyanAccent.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Sections
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                ...widget.sections.expand((section) => [
                  _buildSectionTitle(section.title),
                  ...section.items.map((item) => _buildSidebarItem(item)),
                  const SizedBox(height: 10),
                ]),
              ],
            ),
          ),

          // Indicateur de statut en bas
          _buildStatusIndicator(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Logo icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orangeAccent.withOpacity(0.9),
                      Colors.redAccent.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_circle_fill,
                  color: Colors.black,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VLC',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                        height: 1,
                      ),
                    ),
                    Text(
                      'FUTURISTE',
                      style: TextStyle(
                        color: Colors.blueGrey.shade400,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Lecteur Multimédia',
            style: TextStyle(
              color: Colors.blueGrey.shade500,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Version Cyberpunk',
            style: TextStyle(
              color: Colors.purpleAccent,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.blueGrey.shade400,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 3,
        ),
      ),
    );
  }

  Widget _buildSidebarItem(SidebarItem item) {
    final isExpanded = _expandedSections[item.label] ?? false;
    final activeColor = item.activeColor ?? widget.activeColor;

    return Column(
      children: [
        // Item principal
        GestureDetector(
          onTap: () {
            item.onTap();
            if (item.children != null) {
              setState(() {
                _expandedSections[item.label] = !isExpanded;
              });
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            decoration: BoxDecoration(
              gradient: item.isActive
                  ? LinearGradient(
                colors: [
                  activeColor.withOpacity(0.2),
                  activeColor.withOpacity(0.1),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
                  : null,
              borderRadius: BorderRadius.circular(10),
              border: item.isActive
                  ? Border.all(
                color: activeColor.withOpacity(0.3),
                width: 1,
              )
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                // Icon avec effet
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: item.isActive
                        ? LinearGradient(
                      colors: [
                        activeColor.withOpacity(0.8),
                        activeColor.withOpacity(0.5),
                      ],
                    )
                        : LinearGradient(
                      colors: [
                        Colors.blueGrey.shade800,
                        Colors.blueGrey.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: item.isActive
                        ? [
                      BoxShadow(
                        color: activeColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                        : null,
                  ),
                  child: Icon(
                    item.icon,
                    color: item.isActive ? Colors.black : Colors.blueGrey.shade300,
                    size: 18,
                  ),
                ),

                const SizedBox(width: 12),

                // Label
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: item.isActive ? activeColor : Colors.blueGrey.shade300,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),

                // Indicateur d'enfants
                if (item.children != null)
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: item.isActive ? activeColor : Colors.blueGrey.shade400,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),

        // Enfants (si développé)
        if (item.children != null && isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 16, top: 4),
            child: Column(
              children: item.children!
                  .map(
                    (child) => GestureDetector(
                  onTap: child.onTap,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: child.isActive
                          ? activeColor.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: child.isActive
                          ? Border.all(
                        color: activeColor.withOpacity(0.2),
                        width: 1,
                      )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          child.icon,
                          color: child.isActive ? activeColor : Colors.blueGrey.shade500,
                          size: 16,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            child.label,
                            style: TextStyle(
                              color: child.isActive ? activeColor : Colors.blueGrey.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (child.isActive)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: activeColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: activeColor.withOpacity(0.5),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Barre de progression de connexion
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade800,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Stack(
              children: [
                Container(
                  width: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.greenAccent,
                        Colors.cyanAccent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STATUS: ONLINE',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}