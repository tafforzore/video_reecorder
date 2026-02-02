// player_manager.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:window_manager/window_manager.dart';

class PlayerManager extends GetxController {
  static PlayerManager get instance => Get.find<PlayerManager>();

  late Player _mainPlayer;
  late VideoController _mainVideoController;

  // État global du player
  RxBool isPlaying = false.obs;
  RxDouble currentPosition = 0.0.obs;
  RxDouble totalDuration = 0.0.obs;
  Rx<Media?> currentMedia = Rx<Media?>(null);
  RxBool isFullscreen = false.obs;

  // Map des mini-players (pour les thumbnails)
  final Map<String, VideoController> _miniPlayers = {};
  final Map<String, Player> _miniPlayerInstances = {};

  @override
  void onInit() {
    super.onInit();
    MediaKit.ensureInitialized();
    _initializeMainPlayer();
  }


  Future<void> toggleFullscreen() async {
    final bool isFull = await windowManager.isFullScreen();

    await windowManager.setFullScreen(!isFull);

    isFullscreen.value = !isFull;
  }

  void _initializeMainPlayer() {
    _mainPlayer = Player();
    _mainVideoController = VideoController(_mainPlayer);

    // Écouter les événements du player principal
    _mainPlayer.streams.playing.listen((playing) {
      isPlaying.value = playing;
    });

    _mainPlayer.streams.position.listen((position) {
      currentPosition.value = position.inMilliseconds.toDouble();
    });

    _mainPlayer.streams.duration.listen((duration) {
      totalDuration.value = duration.inMilliseconds.toDouble();
    });
  }

  // Méthode pour créer un mini player qui partage le flux principal
  Widget createSharedMiniPlayer({
    required String mediaUrl,
    required String playerId,
    double width = 200,
    double height = 120,
    bool autoPlay = false,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    bool showControls = false,
  }) {
    return _SharedMiniPlayer(
      playerId: playerId,
      mediaUrl: mediaUrl,
      width: width,
      height: height,
      autoPlay: autoPlay,
      fit: fit,
      borderRadius: borderRadius,
      onTap: onTap,
      showControls: showControls,
    );
  }

  // Jouer un média dans le player principal
  Future<void> playInMainPlayer(String mediaUrl, {bool play = true}) async {
    final media = Media(mediaUrl);
    currentMedia.value = media;

    await _mainPlayer.open(media);
    if (play) {
      await _mainPlayer.play();
    }
  }

  // Pause/Reprendre le player principal
  Future<void> toggleMainPlayer() async {
    if (isPlaying.value) {
      await _mainPlayer.pause();
    } else {
      await _mainPlayer.play();
    }
  }

  // Arrêter tous les mini players
  void stopAllMiniPlayers() {
    for (final player in _miniPlayerInstances.values) {
      player.dispose();
    }
    _miniPlayers.clear();
    _miniPlayerInstances.clear();
  }

  // Mettre à jour la position de tous les mini players
  void syncAllPlayers(Duration position) {
    for (final player in _miniPlayerInstances.values) {
      player.seek(position);
    }
  }

  @override
  void onClose() {
    _mainPlayer.dispose();
    stopAllMiniPlayers();
    super.onClose();
  }

  // Getter pour le contrôleur vidéo principal
  VideoController get mainVideoController => _mainVideoController;
  Player get mainPlayer => _mainPlayer;
}

// Widget pour le mini player partagé
class _SharedMiniPlayer extends StatefulWidget {
  final String playerId;
  final String mediaUrl;
  final double width;
  final double height;
  final bool autoPlay;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool showControls;

  const _SharedMiniPlayer({
    required this.playerId,
    required this.mediaUrl,
    required this.width,
    required this.height,
    required this.autoPlay,
    required this.fit,
    this.borderRadius,
    this.onTap,
    this.showControls = false,
  });

  @override
  State<_SharedMiniPlayer> createState() => __SharedMiniPlayerState();
}

class __SharedMiniPlayerState extends State<_SharedMiniPlayer> {
  late Player _player;
  late VideoController _videoController;
  bool _isInitialized = false;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // Créer un nouveau player
      _player = Player();

      // Synchroniser avec le player principal si c'est le même média
      final playerManager = PlayerManager.instance;
      final currentMedia = playerManager.currentMedia.value;

      if (currentMedia != null &&
          currentMedia.uri.toString() == widget.mediaUrl) {
        // Si c'est le même média que celui en cours de lecture,
        // partager l'état avec le player principal
        _player = playerManager.mainPlayer;
        _videoController = playerManager.mainVideoController;
      } else {
        _videoController = VideoController(_player);
        await _player.open(Media(widget.mediaUrl));

        if (widget.autoPlay) {
          await _player.play();
        }
      }

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Erreur initialisation mini player: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTap: () async {
        await PlayerManager.instance.toggleFullscreen();
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            border: Border.all(
              color: Colors.cyanAccent.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            child: Stack(
              children: [
                // Video
                if (_isInitialized)
                  Video(
                    controller: _videoController,
                    controls: null,
                    wakelock: false,
                    fit: widget.fit,
                  )
                else
                  _buildPlaceholder(),

                // Overlay de contrôle au survol
                if (_isHovering && widget.showControls)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                        ),
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

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.blueGrey.shade900,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam,
              color: Colors.blueGrey.shade400,
              size: 32,
            ),
            const SizedBox(height: 8),
            CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.cyanAccent,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Ne pas disposer le player s'il est partagé avec le player principal
    final playerManager = PlayerManager.instance;
    if (_player != playerManager.mainPlayer) {
      _player.dispose();
    }
    super.dispose();
  }
}