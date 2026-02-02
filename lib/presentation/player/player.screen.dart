import 'package:audioplayer/components/vlc_futuristic_app_bar.dart';
import 'package:audioplayer/components/vlc_futuristic_player.dart';
import 'package:audioplayer/components/vlc_glass_card.dart';
import 'package:audioplayer/presentation/player/controllers/player.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';



class PlayerScreen extends GetView<PlayerController> {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar futuriste
            VlcFuturisticAppBar(
              title: 'Media Player Futuriste',
              onBackPressed: () => Get.back(),
            ),

            Expanded(
              child: Obx(() {
                return Stack(
                  children: [
                    // Player avec MediaKit
                    VlcFuturisticPlayer(
                      child: _buildVideoPlayer(),
                      isPlaying: controller.isPlaying.value,
                      currentTime: controller.formatDuration(
                          controller.currentPosition.value),
                      totalTime: controller.formatDuration(
                          controller.totalDuration.value),
                      progressValue: controller.progressValue.value,
                      onPlayPause: controller.togglePlayPause,
                      onForward: controller.forward10Seconds,
                      onRewind: controller.rewind10Seconds,
                      onProgressChanged: controller.seekTo,
                    ),

                    // Overlay pour les contrôles supplémentaires
                    if (controller.showControls.value)
                      Positioned(
                        top: 20,
                        right: 20,
                        child: VlcGlassCard(
                          padding: const EdgeInsets.all(12),
                          borderRadius: 15,
                          child: Row(
                            children: [
                              // Volume
                              IconButton(
                                onPressed: controller.toggleMute,
                                icon: Icon(
                                  controller.isMuted.value
                                      ? Icons.volume_off
                                      : Icons.volume_up,
                                  color: Colors.blue.shade300,
                                ),
                              ),

                              const SizedBox(width: 10),

                              // Playback speed
                              VlcGlassCard(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                borderRadius: 10,
                                onTap: controller.showPlaybackSpeedDialog,
                                child: Text(
                                  '${controller.playbackSpeed.value}x',
                                  style: TextStyle(
                                    color: Colors.blue.shade300,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Indicateur de chargement
                    if (controller.isBuffering.value)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.7),
                          child: Center(
                            child: VlcGlassCard(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.blue.shade300,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Buffering...',
                                    style: TextStyle(
                                      color: Colors.blue.shade300,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),

            // Informations supplémentaires
            Obx(() {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: controller.showInfo.value ? 100 : 0,
                child: VlcGlassCard(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Informations de fichier
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.currentFile.value,
                            style: TextStyle(
                              color: Colors.blue.shade300,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${controller.formatDuration(controller.totalDuration.value)} • '
                                '${controller.videoResolution.value}',
                            style: TextStyle(
                              color: Colors.blue.shade300.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      // Bouton pour ouvrir un fichier
                      IconButton(
                        onPressed: controller.pickVideoFile,
                        icon: Icon(
                          Icons.folder_open,
                          color: Colors.blue.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),

      // Bouton flottant pour afficher/masquer les infos
      floatingActionButton: Obx(() {
        return FloatingActionButton(
          onPressed: controller.toggleInfo,
          backgroundColor: Colors.blue.shade800.withOpacity(0.8),
          child: Icon(
            controller.showInfo.value ? Icons.info_outline : Icons.info,
            color: Colors.blue.shade300,
          ),
        );
      }),
    );
  }

  Widget _buildVideoPlayer() {
    return SizedBox.expand(
      child: Video(
        controller: controller.videoController,
        controls: null,   // on utilise nos propres contrôles
        wakelock: false,
      ),
    );
  }



  Widget _buildPlaceholder() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_circle_filled_outlined,
              size: 100,
              color: Colors.blue.shade300.withOpacity(0.3),
            ),
            const SizedBox(height: 20),
            Text(
              'Media Player Futuriste',
              style: TextStyle(
                color: Colors.blue.shade300,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Sélectionnez une vidéo',
              style: TextStyle(
                color: Colors.blue.shade300.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: controller.pickVideoFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.video_library,
                    color: Colors.blue.shade300,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Ouvrir une vidéo',
                    style: TextStyle(
                      color: Colors.blue.shade300,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}