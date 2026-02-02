// media_library_controller.dart
import 'dart:async';
import 'dart:io';
import 'package:audioplayer/infrastructure/dal/services/player_manager.dart';
import 'package:audioplayer/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path/path.dart' as p;
import 'package:window_manager/window_manager.dart';

import '../../../components/MiniVideoPlayer.dart';

class MediaLibraryController extends GetxController {
  // Référence au PlayerManager
  final PlayerManager _playerManager = PlayerManager.instance;

  // États observables
  RxBool isPlaying = false.obs;
  RxBool isBuffering = false.obs;
  RxBool isMuted = false.obs;
  RxBool showControls = true.obs;
  RxBool isFullscreen = false.obs;
  RxBool isLoading = false.obs;

  RxDouble currentPosition = 0.0.obs;
  RxDouble totalDuration = 0.0.obs;
  RxDouble progressValue = 0.0.obs;
  RxDouble playbackSpeed = 1.0.obs;

  // Bibliothèque
  RxList<Map<String, dynamic>> mediaList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredMedia = <Map<String, dynamic>>[].obs;
  Rx<Map<String, dynamic>?> currentMedia = Rx<Map<String, dynamic>?>(null);
  RxString currentFilter = 'all'.obs;

  // Stats
  RxInt videoCount = 0.obs;
  RxInt audioCount = 0.obs;
  RxString totalDurationFormatted = '00:00'.obs;

  Timer? _controlsTimer;
  Timer? _positionTimer;

  @override
  void onInit() {
    super.onInit();
    // Get.put(PlayerManager());
    // Écouter les changements du PlayerManager
    ever(_playerManager.isPlaying, (playing) {
      isPlaying.value = playing;
    });

    ever(_playerManager.currentPosition, (position) {
      currentPosition.value = position;
      if (totalDuration.value > 0) {
        progressValue.value = (currentPosition.value / totalDuration.value) * 100;
      }
    });

    _loadMediaLibrary();
  }

  Future<void> _loadMediaLibrary() async {
    isLoading.value = true;

    // Simuler le chargement (dans une vraie app, lire depuis la base de données)
    await Future.delayed(const Duration(seconds: 1));

    // Exemple de données
    mediaList.assignAll([
      {
        'id': '1',
        'title': 'Big Buck Bunny',
        'path': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        'type': 'video',
        'duration': '09:56',
        'resolution': '1920x1080',
        'size': '25.4 MB',
        'videoCodec': 'H.264',
        'audioCodec': 'AAC',
        'frameRate': '60 fps',
        'bitrate': '3.5 Mbps',
      },
      {
        'id': '2',
        'title': 'Elephants Dream',
        'path': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        'type': 'video',
        'duration': '10:53',
        'resolution': '1280x720',
        'size': '18.2 MB',
        'videoCodec': 'H.264',
        'audioCodec': 'AAC',
        'frameRate': '30 fps',
        'bitrate': '2.2 Mbps',
      },
      {
        'id': '3',
        'title': 'Sample Music',
        'path': 'assets/audio/sample.mp3',
        'type': 'audio',
        'duration': '03:45',
        'artist': 'Artist Name',
        'album': 'Album Name',
        'size': '8.7 MB',
        'audioCodec': 'MP3',
        'bitrate': '320 kbps',
      },
    ]);

    _updateStats();
    filterMedia(currentFilter.value);
    isLoading.value = false;
  }

  void _updateStats() {
    videoCount.value = mediaList.where((media) => media['type'] == 'video').length;
    audioCount.value = mediaList.where((media) => media['type'] == 'audio').length;

    // Calculer la durée totale (simplifié)
    int totalSeconds = 0;
    for (var media in mediaList) {
      if (media['duration'] != null) {
        var parts = media['duration'].split(':');
        if (parts.length == 2) {
          totalSeconds += int.parse(parts[0]) * 60 + int.parse(parts[1]);
        }
      }
    }

    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    totalDurationFormatted.value = '$hours:$minutes';
  }

  void filterMedia(String type) {
    currentFilter.value = type;

    if (type == 'all') {
      filteredMedia.assignAll(mediaList);
    } else {
      filteredMedia.assignAll(
        mediaList.where((media) => media['type'] == type).toList(),
      );
    }
  }

  Future<void> playMedia(
      Map<String, dynamic> media, {
        bool fullscreen = false,
      }) async {
    try {
      currentMedia.value = media;

      if (fullscreen) {
        isFullscreen.value = true;
        await windowManager.setFullScreen(true);
      }

      await _playerManager.playInMainPlayer(
        media['path'],
        play: true,
      );

      _startPositionTimer();
      _resetControlsTimer();

    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de lire le média: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  void _playNext() {
    final currentIndex = filteredMedia.indexWhere(
          (media) => media['id'] == currentMedia.value?['id'],
    );

    if (currentIndex != -1 && currentIndex + 1 < filteredMedia.length) {
      playMedia(filteredMedia[currentIndex + 1]);
    }
  }

  void _startPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (isPlaying.value) {
        if (totalDuration.value > 0 && currentPosition.value > 0) {
          progressValue.value = (currentPosition.value / totalDuration.value) * 100;
        }
      }
    });
  }

  // Fonction pour créer un thumbnail qui partage le flux
  Widget createSharedVideoThumbnail({
    required String mediaUrl,
    required String mediaId,
    double width = 200,
    double height = 120,
    bool autoPlay = false,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
  }) {
    return _playerManager.createSharedMiniPlayer(
      mediaUrl: mediaUrl,
      playerId: mediaId,
      width: width,
      height: height,
      autoPlay: autoPlay,
      borderRadius: borderRadius,
      onTap: onTap ?? () {
        // Trouver le média correspondant et le jouer
        final media = mediaList.firstWhere(
              (m) => m['path'] == mediaUrl,
          orElse: () => {
            'id': mediaId,
            'title': 'Miniature',
            'path': mediaUrl,
            'type': 'video',
            'duration': '00:00',
          },
        );
        playMedia(media);
      },
      showControls: true,
    );
  }

  // Fonction pour créer un thumbnail cyberpunk partagé
  Widget createSharedCyberThumbnail({
    required String mediaUrl,
    required String mediaId,
    double width = 250,
    double height = 140,
    Color glowColor = Colors.cyanAccent,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Player partagé
          _playerManager.createSharedMiniPlayer(
            mediaUrl: mediaUrl,
            playerId: mediaId,
            width: width,
            height: height,
            autoPlay: false,
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              final media = mediaList.firstWhere(
                    (m) => m['path'] == mediaUrl,
                orElse: () => {
                  'id': mediaId,
                  'title': 'Miniature',
                  'path': mediaUrl,
                  'type': 'video',
                  'duration': '00:00',
                },
              );
              playMedia(media);
            },
          ),

          // Overlay cyberpunk
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: glowColor.withOpacity(0.3),
                  width: 1,
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    glowColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Bouton plein écran
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                final media = mediaList.firstWhere(
                      (m) => m['path'] == mediaUrl,
                  orElse: () => {
                    'id': mediaId,
                    'title': 'Miniature',
                    'path': mediaUrl,
                    'type': 'video',
                    'duration': '00:00',
                  },
                );
                playMedia(media, fullscreen: true);
              },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: glowColor,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.fullscreen,
                  color: glowColor,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Les autres méthodes restent les mêmes...
  Future<void> pickMediaFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.media,
        allowedExtensions: ['mp4', 'avi', 'mkv', 'mov', 'mp3', 'wav', 'flac'],
      );

      if (result != null) {
        for (var file in result.files) {
          if (file.path != null) {
            await _addMediaToLibrary(File(file.path!));
          }
        }

        _updateStats();
        filterMedia(currentFilter.value);

        Get.snackbar(
          'Succès',
          '${result.files.length} média(s) ajouté(s)',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible d\'ajouter les médias: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _addMediaToLibrary(File file) async {
    final extension = p.extension(file.path).toLowerCase();
    final isVideo = ['.mp4', '.avi', '.mkv', '.mov', '.wmv'].contains(extension);
    final isAudio = ['.mp3', '.wav', '.flac', '.aac'].contains(extension);

    if (!isVideo && !isAudio) return;

    final media = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': p.basename(file.path),
      'path': file.path,
      'type': isVideo ? 'video' : 'audio',
      'duration': '00:00', // À extraire du fichier
      'size': '${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(1)} MB',
      'resolution': isVideo ? '1920x1080' : null,
      'videoCodec': isVideo ? 'H.264' : null,
      'audioCodec': isAudio ? 'MP3' : 'AAC',
      'frameRate': isVideo ? '30 fps' : null,
      'bitrate': isVideo ? '2 Mbps' : '320 kbps',
    };

    mediaList.add(media);
  }

  Future<void> scanMediaFiles() async {
    isLoading.value = true;

    // Simuler le scan
    await Future.delayed(const Duration(seconds: 2));

    // Dans une vraie app, scanner le stockage
    _updateStats();
    filterMedia(currentFilter.value);

    isLoading.value = false;

    // Get.snackbar(
    //   'Scan terminé',
    //   'Bibliothèque mise à jour',
    //   backgroundColor: Colors.blue,
    //   colorText: Colors.white,
    // );
  }

  Future<void> togglePlayPause() async {
    try {
      await _playerManager.toggleMainPlayer();
      _resetControlsTimer();
    } catch (e) {
      print('Erreur: $e');
      //)
      // Get.snackbar(
      //   'Erreur',
      //   'Impossible de changer l\'état de lecture: $e',
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
  }

  Future<void> forward10Seconds() async {
    try {
      final player = _playerManager.mainPlayer;
      final position = player.state.position;
      final duration = player.state.duration ?? Duration.zero;
      final newPosition = position + const Duration(seconds: 10);

      await player.seek(
        newPosition > duration ? duration : newPosition,
      );
      _resetControlsTimer();
    } catch (e) {
      print('Erreur: $e');
      // Get.snackbar(
      //   'Erreur',
      //   'Impossible d\'avancer: $e',
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
  }

  Future<void> rewind10Seconds() async {
    try {
      final player = _playerManager.mainPlayer;
      final position = player.state.position;
      final newPosition = position - const Duration(seconds: 10);

      await player.seek(
        newPosition < Duration.zero ? Duration.zero : newPosition,
      );
      _resetControlsTimer();
    } catch (e) {
      print('Impossible de reculer: $e');
      // Get.snackbar(
      //   'Erreur',
      //   'Impossible de reculer: $e',
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
  }

  Future<void> seekTo(double value) async {
    try {
      if (totalDuration.value == 0) return;

      final positionInMs = (value / 100) * totalDuration.value;
      await _playerManager.mainPlayer.seek(Duration(milliseconds: positionInMs.toInt()));
      _resetControlsTimer();
    } catch (e) {
      print('Impossible de se deplacer: $e');
      // Get.snackbar(
      //   'Erreur',
      //   'Impossible de se déplacer: $e',
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
  }

  Future<void> toggleMute() async {
    try {
      final player = _playerManager.mainPlayer;
      final volume = player.state.volume;
      if (volume > 0) {
        await player.setVolume(0);
        isMuted.value = true;
      } else {
        await player.setVolume(100);
        isMuted.value = false;
      }
      _resetControlsTimer();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de changer le volume: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void toggleFullscreen() {
    isFullscreen.value = !isFullscreen.value;
  }

  void _resetControlsTimer() {
    showControls.value = true;
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      showControls.value = false;
    });
  }

  String formatDuration(double milliseconds) {
    final duration = Duration(milliseconds: milliseconds.toInt());
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
  }

  // Getter pour accéder au contrôleur vidéo principal
  VideoController get videoController => _playerManager.mainVideoController;

  @override
  void onClose() {
    _controlsTimer?.cancel();
    _positionTimer?.cancel();
    super.onClose();
  }
}