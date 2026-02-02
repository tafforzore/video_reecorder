import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class VlcFileCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String fileType; // 'video' ou 'audio'
  final String? duration;
  final String? resolution;
  final String? fileSize;
  final Widget? thumbnail; // Widget personnalisé pour la vignette
  final String? thumbnailPath; // Chemin vers une image pour la vignette
  final int index; // Numéro d'index dans la liste
  final bool isPlaying; // Si ce média est en cours de lecture
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final VoidCallback onInfoTap;
  final VoidCallback? onPlayTap; // Action spécifique pour le bouton play

  const VlcFileCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fileType,
    this.duration,
    this.resolution,
    this.fileSize,
    this.thumbnail,
    this.thumbnailPath,
    this.index = 0,
    this.isPlaying = false,
    required this.onTap,
    required this.onDoubleTap,
    required this.onInfoTap,
    this.onPlayTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isPlaying
              ? Colors.cyanAccent.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isPlaying
                ? Colors.cyanAccent.withOpacity(0.3)
                : Colors.blueGrey.shade800.withOpacity(0.5),
            width: isPlaying ? 1 : 0.5,
          ),
          boxShadow: [
            if (isPlaying)
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 60, // Hauteur fixe comme dans VLC
            child: Row(
              children: [
                // Numéro d'index
                Container(
                  width: 40,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueGrey.shade900,
                        Colors.blueGrey.shade800,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      index.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: Colors.blueGrey.shade400,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Digital',
                      ),
                    ),
                  ),
                ),

                // Thumbnail
                _buildThumbnail(),

                // Informations du fichier
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Titre
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: isPlaying ? Colors.cyanAccent : Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                              ),
                            ),

                            if (isPlaying)
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                  color: Colors.cyanAccent,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.cyanAccent.withOpacity(0.5),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),

                        // Sous-titre et infos
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: Colors.blueGrey.shade400,
                                fontSize: 11,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),

                            const SizedBox(width: 12),

                            // Infos en ligne
                            if (duration != null)
                              _buildInlineInfo(
                                Icons.timer,
                                duration!,
                                Colors.blueGrey.shade400,
                              ),

                            if (resolution != null && fileType == 'video')
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: _buildInlineInfo(
                                  Icons.hd,
                                  resolution!,
                                  Colors.greenAccent,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Durée et boutons d'action
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                      // Durée
                      if (duration != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade900.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            duration!,
                            style: TextStyle(
                              color: Colors.blueGrey.shade300,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      const SizedBox(width: 8),

                      // Bouton Play rapide
                      GestureDetector(
                        onTap: onPlayTap ?? onTap,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.cyanAccent.withOpacity(0.8),
                                Colors.blueAccent.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyanAccent.withOpacity(0.3),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ),

                      const SizedBox(width: 4),

                      // Bouton Info
                      IconButton(
                        onPressed: onInfoTap,
                        icon: Icon(
                          Icons.info_outline,
                          color: Colors.blueGrey.shade500,
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
            ),
          ]),
        ),
      ),
    ));
  }

  Widget _buildThumbnail() {
    // Widget personnalisé fourni
    if (thumbnail != null) {
      return SizedBox(
        width: 100,
        height: 60,
        child: thumbnail,
      );
    }

    // Image depuis chemin
    if (thumbnailPath != null) {
      return SizedBox(
        width: 100,
        height: 60,
        child: ClipRRect(
          child: Image.asset(
            thumbnailPath!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildDefaultThumbnail(),
          ),
        ),
      );
    }

    // Thumbnail par défaut
    return _buildDefaultThumbnail();
  }

  Widget _buildDefaultThumbnail() {
    return SizedBox(
      width: 100,
      height: 60,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Fond avec dégradé
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: fileType == 'video'
                    ? [
                  Colors.blueAccent.withOpacity(0.3),
                  Colors.cyanAccent.withOpacity(0.3),
                ]
                    : [
                  Colors.purpleAccent.withOpacity(0.3),
                  Colors.pinkAccent.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Icône au centre
          Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                fileType == 'video' ? Icons.videocam : Icons.music_note,
                color: Colors.white.withOpacity(0.7),
                size: 18,
              ),
            ),
          ),

          // Overlay pour les fichiers audio avec visualiseur
          if (fileType == 'audio')
            Positioned.fill(
              child: CustomPaint(
                painter: _AudioWavePainter(),
              ),
            ),

          // Overlay pour les fichiers vidéo
          if (fileType == 'video')
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Icon(
                  Icons.play_circle_filled,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInlineInfo(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 10,
          color: color,
        ),
        const SizedBox(width: 2),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Peintre pour l'effet d'onde audio dans la vignette
class _AudioWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path();
    final waveHeight = size.height * 0.3;
    final waveCount = 5;

    for (int i = 0; i <= waveCount; i++) {
      final x = size.width * i / waveCount;
      final y = size.height / 2 + sin(x * 0.05) * waveHeight;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Variante du FileCard avec plus de détails (pour les listes de type "détails")
class VlcFileDetailCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String fileType;
  final String duration;
  final String resolution;
  final String fileSize;
  final String bitrate;
  final String codec;
  final Widget? thumbnail;
  final bool isSelected;
  final VoidCallback onTap;

  const VlcFileDetailCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fileType,
    required this.duration,
    required this.resolution,
    required this.fileSize,
    required this.bitrate,
    required this.codec,
    this.thumbnail,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.cyanAccent.withOpacity(0.05) : null,
        border: Border(
          bottom: BorderSide(
            color: Colors.blueGrey.shade800.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          hoverColor: Colors.cyanAccent.withOpacity(0.02),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Thumbnail réduite
                Container(
                  width: 60,
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: fileType == 'video'
                          ? [Colors.blueGrey.shade800, Colors.blueGrey.shade900]
                          : [Colors.purple.shade900, Colors.purple.shade800],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: thumbnail ??
                      Center(
                        child: Icon(
                          fileType == 'video' ? Icons.videocam : Icons.music_note,
                          color: Colors.blueGrey.shade400,
                          size: 20,
                        ),
                      ),
                ),

                const SizedBox(width: 12),

                // Titre et infos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.blueGrey.shade400,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Métadonnées
                SizedBox(
                  width: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetaItem('Durée', duration),
                      if (fileType == 'video')
                        _buildMetaItem('Résolution', resolution),
                      _buildMetaItem('Taille', fileSize),
                      if (bitrate.isNotEmpty)
                        _buildMetaItem('Bitrate', bitrate),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.blueGrey.shade500,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.blueGrey.shade300,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}