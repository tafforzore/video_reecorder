import 'package:audioplayer/components/action_button.dart' hide CyberActionButton;
import 'package:audioplayer/components/vlc_file_card.dart';
import 'package:audioplayer/components/vlc_file_info_dialog.dart';
import 'package:audioplayer/components/vlc_fullscreen_player.dart';
import 'package:audioplayer/components/vlc_cyber_app_bar.dart';
import 'package:audioplayer/components/vlc_holographic_card.dart';
import 'package:audioplayer/components/vlc_sidebar_menu.dart';
import 'package:audioplayer/components/vlc_wave_visualizer.dart';
import 'package:audioplayer/presentation/media_library/controllers/media_library.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';

class MediaLibraryScreen extends GetView<MediaLibraryController> {
  const MediaLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Mode fullscreen
      if (controller.isFullscreen.value) {
        return VlcFullscreenPlayer(
          child: Video(
            controller: controller.videoController,
            controls: null,
            wakelock: false,
          ),
          isPlaying: controller.isPlaying.value,
          currentTime: controller.formatDuration(controller.currentPosition.value),
          totalTime: controller.formatDuration(controller.totalDuration.value),
          progressValue: controller.progressValue.value,
          onPlayPause: controller.togglePlayPause,
          onForward: controller.forward10Seconds,
          onRewind: controller.rewind10Seconds,
          onProgressChanged: controller.seekTo,
          onExitFullscreen: controller.toggleFullscreen,
          onToggleMute: controller.toggleMute,
          isMuted: controller.isMuted.value,
          onInfo: () => _showFileInfo(context, controller.currentMedia.value),
          fileName: controller.currentMedia.value?['title'],
          resolution: controller.currentMedia.value?['resolution'],
        );
      }

      // Mode bibliothèque futuriste
      return Scaffold(
        backgroundColor: const Color(0xFF0A0A1A),
        body: SafeArea(
          child: Row(
            children: [
              // Sidebar de navigation futuriste
              VlcSidebarMenu(
                sections: [
                  SidebarSection(
                    title: 'MÉDIAS',
                    items: [
                      SidebarItem(
                        icon: Icons.play_circle_filled,
                        label: 'Lecture Audio',
                        onTap: () => controller.filterMedia('audio'),
                      ),
                      SidebarItem(
                        icon: Icons.videocam,
                        label: 'Vidéo Sous-titres',
                        onTap: () => controller.filterMedia('video'),
                      ),
                    ],
                  ),
                  SidebarSection(
                    title: 'NAVIGATION',
                    items: [
                      SidebarItem(
                        icon: Icons.library_music,
                        label: 'Liste de lecture',
                        onTap: () {},
                        isActive: true,
                      ),
                      SidebarItem(
                        icon: Icons.video_library,
                        label: 'Médiathèque',
                        onTap: () {},
                      ),
                      SidebarItem(
                        icon: Icons.computer,
                        label: 'Mon ordinateur',
                        onTap: () {},
                        children: [
                          SidebarChildItem(icon: Icons.movie, label: 'Mes vidéos'),
                          SidebarChildItem(icon: Icons.music_note, label: 'Ma musique'),
                          SidebarChildItem(icon: Icons.image, label: 'Mes images'),
                        ],
                      ),
                      SidebarItem(
                        icon: Icons.usb,
                        label: 'Périphériques',
                        onTap: () {},
                        children: [
                          SidebarChildItem(icon: Icons.storage, label: 'Disques'),
                        ],
                      ),
                      SidebarItem(
                        icon: Icons.lan,
                        label: 'Réseau local',
                        onTap: () {},
                        children: [
                          SidebarChildItem(icon: Icons.search, label: 'Découverte réseau mDNS'),
                          SidebarChildItem(icon: Icons.stream, label: 'Flux réseau (SAP)'),
                          SidebarChildItem(icon: Icons.extension, label: 'Universal Plug\'n\'Play'),
                        ],
                      ),
                      SidebarItem(
                        icon: Icons.cloud,
                        label: 'Internet',
                        onTap: () {},
                        children: [
                          SidebarChildItem(icon: Icons.podcasts, label: 'Podcasts'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Contenu principal
              Expanded(
                child: Column(
                  children: [

                    // AppBar cybernétique
                    VlcCyberAppBar(
                      title: 'LECTEUR MULTIMÉDIA VLC',
                      subtitle: 'Version Futuriste',
                      onPressedButton: controller.pickMediaFiles,
                      textOnPressed: 'AJOUTER DES MÉDIAS',
                      actions: [
                        CyberActionButton(
                          icon: Icons.search,
                          onTap: () {},
                          tooltip: 'Rechercher',
                          glowColor: Colors.blueAccent,
                        ),
                        CyberActionButton(
                          icon: Icons.refresh,
                          onTap: controller.scanMediaFiles,
                          tooltip: 'Scanner',
                          glowColor: Colors.cyanAccent,
                        ),
                        CyberActionButton(
                          icon: Icons.tune,
                          onTap: () {},
                          tooltip: 'Paramètres',
                          glowColor: Colors.purpleAccent,
                        ),
                      ],
                    ),

                    // Stats holographiques
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: VlcHolographicCard(
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(16),
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //               children: [
                    //                 _buildStatCard(
                    //                   icon: Icons.videocam,
                    //                   value: controller.videoCount.toString(),
                    //                   label: 'VIDÉOS',
                    //                   gradient: const [
                    //                     Color(0xFF00E5FF),
                    //                     Color(0xFF2979FF),
                    //                   ],
                    //                 ),
                    //                 _buildDivider(),
                    //                 _buildStatCard(
                    //                   icon: Icons.music_note,
                    //                   value: controller.audioCount.toString(),
                    //                   label: 'MUSIQUES',
                    //                   gradient: const [
                    //                     Color(0xFFF50057),
                    //                     Color(0xFFFF4081),
                    //                   ],
                    //                 ),
                    //                 _buildDivider(),
                    //                 _buildStatCard(
                    //                   icon: Icons.timer,
                    //                   value: controller.totalDurationFormatted.value,
                    //                   label: 'DURÉE TOTALE',
                    //                   gradient: const [
                    //                     Color(0xFF76FF03),
                    //                     Color(0xFF00E676),
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // En-tête de la liste de lecture
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: VlcHolographicCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.list,
                                    color: Colors.cyanAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'LISTE DE LECTURE',
                                    style: TextStyle(
                                      color: Colors.cyanAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),// Pour les boutons d'action
                          ],
                        ),
                      ),
                    ),

                    // Liste des médias
                    Expanded(
                      child: controller.isLoading.value
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: Colors.cyanAccent,
                              strokeWidth: 2,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'SCAN DES MÉDIAS...',
                              style: TextStyle(
                                color: Colors.cyanAccent,
                                fontSize: 14,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      )
                          : controller.filteredMedia.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemCount: controller.filteredMedia.length,
                        itemBuilder: (context, index) {
                          final media = controller.filteredMedia[index];
                          return VlcFileCard(
                            title: media['title'] ?? 'Sans titre',
                            subtitle: media['artist'] ?? media['album'] ?? 'Inconnu',
                            fileType: media['type'] ?? 'unknown',
                            duration: media['duration'],
                            resolution: media['resolution'],
                            fileSize: media['size'],
                            index: index + 1,
                            isPlaying: controller.currentMedia.value?['path'] == media['path'],
                            onTap: () => controller.playMedia(media),
                            onDoubleTap: () => controller.playMedia(media, fullscreen: true),
                            onInfoTap: () => _showFileInfo(context, media),
                          );
                        },
                      ),
                    ),

                    // Lecteur holographique (si en lecture)
                    if (controller.isPlaying.value && controller.currentMedia.value != null)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        height: 160,
                        child: VlcHolographicCard(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Barre de progression
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      controller.formatDuration(controller.currentPosition.value),
                                      style: TextStyle(
                                        color: Colors.cyanAccent,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Expanded(
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                          trackHeight: 3,
                                          thumbShape: const RoundSliderThumbShape(
                                            enabledThumbRadius: 6,
                                            elevation: 4,
                                          ),
                                          overlayShape: SliderComponentShape.noOverlay,
                                          activeTrackColor: Colors.cyanAccent,
                                          inactiveTrackColor: Colors.blueGrey.shade800,
                                          thumbColor: Colors.cyanAccent,
                                        ),
                                        child: Slider(
                                          value: controller.progressValue.value.clamp(0.0, 1.0),
                                          onChanged: controller.seekTo,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      controller.formatDuration(controller.totalDuration.value),
                                      style: TextStyle(
                                        color: Colors.cyanAccent,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Contrôles et infos
                              Flexible(
                                fit: FlexFit.loose,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Miniature holographique
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: controller.currentMedia.value?['type'] == 'video'
                                              ? [Colors.blueAccent.withOpacity(0.8), Colors.cyanAccent.withOpacity(0.8)]
                                              : [Colors.purpleAccent.withOpacity(0.8), Colors.pinkAccent.withOpacity(0.8)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: controller.currentMedia.value?['type'] == 'video'
                                                ? Colors.blueAccent.withOpacity(0.4)
                                                : Colors.purpleAccent.withOpacity(0.4),
                                            blurRadius: 12,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // Visualiseur audio
                                          if (controller.currentMedia.value?['type'] == 'audio')
                                            VlcWaveVisualizer(
                                              isPlaying: controller.isPlaying.value,
                                              color: Colors.white.withOpacity(0.8),
                                              barCount: 12,
                                              height: 30,
                                            )
                                          else if (controller.currentMedia.value?['type'] == 'video')
                                            controller.createSharedVideoThumbnail(
                                              mediaUrl: controller.currentMedia.value?['path'],
                                              width: 320,
                                              height: 200,
                                              mediaId: controller.currentMedia.value?['id'],
                                            )
                                          else
                                            const Icon(
                                              Icons.graphic_eq,
                                              color: Colors.white,
                                              size: 32,
                                            ),

                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // Infos du média
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.currentMedia.value?['title'] ?? 'Sans titre',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            controller.currentMedia.value?['artist'] ??
                                                controller.currentMedia.value?['album'] ??
                                                'Inconnu',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.blueGrey.shade300,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // Contrôles
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildControlButton(
                                          icon: Icons.skip_previous,
                                          onTap: () {},
                                          glowColor: Colors.blueAccent,
                                        ),
                                        _buildControlButton(
                                          icon: Icons.replay_10,
                                          onTap: controller.rewind10Seconds,
                                          glowColor: Colors.cyanAccent,
                                        ),

                                        // Bouton Play/Pause central
                                        Container(
                                          width: 52,
                                          height: 52,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [Colors.cyanAccent.withOpacity(0.9), Colors.blueAccent.withOpacity(0.9)],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.cyanAccent.withOpacity(0.5),
                                                blurRadius: 12,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            onPressed: controller.togglePlayPause,
                                            icon: Icon(
                                              controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                                              color: Colors.black,
                                              size: 26,
                                            ),
                                          ),
                                        ),

                                        _buildControlButton(
                                          icon: Icons.forward_10,
                                          onTap: controller.forward10Seconds,
                                          glowColor: Colors.cyanAccent,
                                        ),
                                        _buildControlButton(
                                          icon: Icons.skip_next,
                                          onTap: () {},
                                          glowColor: Colors.blueAccent,
                                        ),

                                        const SizedBox(width: 12),

                                        _buildControlButton(
                                          icon: Icons.fullscreen,
                                          onTap: controller.toggleFullscreen,
                                          glowColor: Colors.purpleAccent,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Bouton d'ajout flottant futuriste
        // floatingActionButton: FloatingActionButton.
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hologramme d'affichage vide
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.cyanAccent.withOpacity(0.1),
                  Colors.transparent,
                ],
                stops: const [0.1, 1.0],
              ),
            ),
            child: Icon(
              Icons.video_library,
              size: 80,
              color: Colors.cyanAccent.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'LISTE DE LECTURE VIDE',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Déposer un fichier ici ou sélectionner une source depuis la gauche',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey.shade400,
              fontSize: 14,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: controller.pickMediaFiles,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: Colors.cyanAccent.withOpacity(0.5), width: 1),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 18,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyanAccent.withOpacity(0.8),
                        Colors.blueAccent.withOpacity(0.8),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'IMPORTER DES FICHIERS',
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required List<Color> gradient,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.black,
            size: 24,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontFamily: 'Digital',
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: gradient[1].withOpacity(0.7),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueGrey.shade800.withOpacity(0.5),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color glowColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: glowColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: glowColor,
          size: 20,
        ),
      ),
    );
  }

  void _showFileInfo(BuildContext context, Map<String, dynamic>? media) {
    if (media == null) return;

    showDialog(
      context: context,
      builder: (context) => VlcFileInfoDialog(
        fileName: media['title'] ?? 'Sans titre',
        filePath: media['path'] ?? 'Chemin inconnu',
        fileType: media['type'] ?? 'unknown',
        duration: media['duration'] ?? '00:00',
        resolution: media['resolution'] ?? 'Inconnue',
        fileSize: media['size'] ?? '0 MB',
        videoCodec: media['videoCodec'] ?? 'H.264',
        audioCodec: media['audioCodec'] ?? 'AAC',
        frameRate: media['frameRate'] ?? '30 fps',
        bitrate: media['bitrate'] ?? '2 Mbps',
      ),
    );
  }
}