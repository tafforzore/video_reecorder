import 'dart:async';
import 'dart:io';
import 'package:audioplayer/components/vlc_glass_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class PlayerController extends GetxController {
  // MediaKit
  late Player _player;
  late VideoController _videoController;

  // États observables
  RxBool isPlaying = false.obs;
  RxBool isBuffering = false.obs;
  RxBool isMuted = false.obs;
  RxBool showControls = true.obs;
  RxBool showInfo = false.obs;

  RxDouble currentPosition = 0.0.obs;
  RxDouble totalDuration = 0.0.obs;
  RxDouble progressValue = 0.0.obs;
  RxDouble playbackSpeed = 1.0.obs;

  RxString currentFile = 'Media Player Futuriste'.obs;
  RxString videoResolution = 'HD'.obs;

  Timer? _controlsTimer;
  Timer? _positionTimer;

  @override
  void onInit() {
    super.onInit();
    // Initialiser MediaKit
    MediaKit.ensureInitialized();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      print('Initialisation de MediaKit...');

      // Créer le player MediaKit
      _player = Player();

      // Créer le contrôleur vidéo
      _videoController = VideoController(_player);

      // Configurer les écouteurs
      _setupEventListeners();

      // Charger une vidéo par défaut
      await _loadDefaultVideo();

      print('MediaKit initialisé avec succès');

    } catch (e) {
      print('Erreur lors de l\'initialisation: $e');
      Get.snackbar(
        'Erreur',
        'Impossible d\'initialiser le lecteur: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _loadDefaultVideo() async {
    try {
      // Utiliser une vidéo de test en ligne
      final defaultVideoUrl = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

      await _player.open(
        Media(defaultVideoUrl),
        play: false,
      );

      currentFile.value = 'BigBuckBunny.mp4';

      // Attendre un peu pour la durée
      await Future.delayed(const Duration(milliseconds: 500));

      // Démarrer la lecture
      await _player.play();
      isPlaying.value = true;

      // Démarrer le timer de position
      _startPositionTimer();

    } catch (e) {
      print('Erreur chargement vidéo par défaut: $e');
    }
  }

  void _setupEventListeners() {
    // Écouter les événements du player
    _player.streams.position.listen((duration) {
      currentPosition.value = duration.inMilliseconds.toDouble();
      if (totalDuration.value > 0) {
        progressValue.value = (currentPosition.value / totalDuration.value) * 100;
      }
    });

    _player.streams.duration.listen((duration) {
      totalDuration.value = duration.inMilliseconds.toDouble();
    });

    _player.streams.playing.listen((playing) {
      isPlaying.value = playing;
    });

    _player.streams.buffering.listen((buffering) {
      isBuffering.value = buffering;
    });

    _player.streams.volume.listen((volume) {
      isMuted.value = volume == 0;
    });

    _player.streams.completed.listen((completed) {
      if (completed) {
        isPlaying.value = false;
        currentPosition.value = 0;
        progressValue.value = 0;
      }
    });
  }

  void _startPositionTimer() {
    _positionTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (isPlaying.value) {
        // La position est mise à jour par le stream
        // On s'assure juste que l'UI est à jour
        if (totalDuration.value > 0 && currentPosition.value > 0) {
          progressValue.value = (currentPosition.value / totalDuration.value) * 100;
        }
      }
    });
  }

  Future<void> pickVideoFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        allowedExtensions: ['mp4', 'avi', 'mkv', 'mov', 'wmv', 'flv', 'webm'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        await _playVideoFile(File(file.path!));
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de sélectionner le fichier: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _playVideoFile(File file) async {
    try {
      // Afficher un indicateur de chargement
      Get.dialog(
        Center(
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
                  'Chargement de la vidéo...',
                  style: TextStyle(
                    color: Colors.blue.shade300,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Charger la vidéo
      await _player.open(
        Media(file.path),
        play: true,
      );

      // Mettre à jour le nom du fichier
      currentFile.value = file.path.split(Platform.pathSeparator).last;

      // Attendre un peu
      await Future.delayed(const Duration(milliseconds: 500));

      // Fermer l'indicateur de chargement
      Get.back();

      _resetControlsTimer();

      // Afficher un message de succès
      Get.snackbar(
        'Succès',
        'Vidéo chargée avec succès',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

    } catch (e) {
      Get.back();
      Get.snackbar(
        'Erreur',
        'Impossible de lire la vidéo: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _playNetworkVideo(String url, String fileName) async {
    try {
      Get.dialog(
        Center(
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
                  'Chargement de la vidéo...',
                  style: TextStyle(
                    color: Colors.blue.shade300,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Charger la vidéo réseau
      await _player.open(
        Media(url),
        play: true,
      );

      // Mettre à jour le nom du fichier
      currentFile.value = fileName;

      // Fermer l'indicateur de chargement
      Get.back();

      _resetControlsTimer();

      Get.snackbar(
        'Succès',
        'Vidéo chargée avec succès',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

    } catch (e) {
      Get.back();
      Get.snackbar(
        'Erreur',
        'Impossible de lire la vidéo: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> togglePlayPause() async {
    try {
      if (isPlaying.value) {
        await _player.pause();
      } else {
        await _player.play();
      }
      _resetControlsTimer();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de changer l\'état de lecture: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> forward10Seconds() async {
    try {
      final position = _player.state.position;
      final duration = _player.state.duration ?? Duration.zero;

      final newPosition = position + const Duration(seconds: 10);

      await _player.seek(
        newPosition > duration ? duration : newPosition,
      );

      _resetControlsTimer();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible d\'avancer: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  Future<void> rewind10Seconds() async {
    try {
      final position = _player.state.position;
      final newPosition = position - const Duration(seconds: 10);

      await _player.seek(
        newPosition < Duration.zero ? Duration.zero : newPosition,
      );

      _resetControlsTimer();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de reculer: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  Future<void> seekTo(double value) async {
    try {
      if (totalDuration.value == 0) return;

      final positionInMs = (value / 100) * totalDuration.value;
      await _player.seek(Duration(milliseconds: positionInMs.toInt()));
      _resetControlsTimer();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de se déplacer: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> toggleMute() async {
    try {
      final volume = _player.state.volume;

      if (volume > 0) {
        await _player.setVolume(0);
        isMuted.value = true;
      } else {
        await _player.setVolume(100);
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


  void showPlaybackSpeedDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(40),
        child: VlcGlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Vitesse de lecture',
                style: TextStyle(
                  color: Colors.blue.shade300,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(5, (index) {
                  final speed = 0.5 + index * 0.25;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: playbackSpeed.value == speed
                          ? LinearGradient(
                        colors: [
                          Colors.blue.shade400,
                          Colors.blue.shade700,
                        ],
                      )
                          : LinearGradient(
                        colors: [
                          Colors.blue.shade800.withOpacity(0.3),
                          Colors.blue.shade400.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.blue.shade300.withOpacity(
                          playbackSpeed.value == speed ? 0.8 : 0.2,
                        ),
                        width: 1,
                      ),
                      boxShadow: playbackSpeed.value == speed
                          ? [
                        BoxShadow(
                          color: Colors.blue.shade400.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                          : null,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _changePlaybackSpeed(speed);
                        Get.back();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${speed}x',
                            style: TextStyle(
                              color: playbackSpeed.value == speed
                                  ? Colors.white
                                  : Colors.blue.shade300,
                              fontSize: 16,
                              fontWeight: playbackSpeed.value == speed
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          if (playbackSpeed.value == speed) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: Text(
                  'Fermer',
                  style: TextStyle(
                    color: Colors.blue.shade300,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changePlaybackSpeed(double speed) async {
    try {
      playbackSpeed.value = speed;
      await _player.setRate(speed);
      _resetControlsTimer();

      Get.snackbar(
        'Vitesse modifiée',
        'Vitesse de lecture réglée à ${speed}x',
        backgroundColor: Colors.blue.shade800,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de changer la vitesse: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _resetControlsTimer() {
    showControls.value = true;
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      showControls.value = false;
    });
  }

  void toggleInfo() {
    showInfo.value = !showInfo.value;
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

  // Getter pour accéder au contrôleur vidéo
  VideoController get videoController => _videoController;

  @override
  void onClose() {
    _controlsTimer?.cancel();
    _positionTimer?.cancel();
    _player.dispose();
    super.onClose();
  }
}