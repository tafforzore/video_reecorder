import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class MiniVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final double width;
  final double height;
  final bool autoPlay;
  final bool showControls;
  final bool loop;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  const MiniVideoPlayer({
    super.key,
    required this.videoUrl,
    this.width = 200,
    this.height = 120,
    this.autoPlay = false,
    this.showControls = false,
    this.loop = false,
    this.onTap,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  @override
  State<MiniVideoPlayer> createState() => _MiniVideoPlayerState();
}

class _MiniVideoPlayerState extends State<MiniVideoPlayer> {
  late Player _player;
  late VideoController _videoController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showMiniControls = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _player = Player();
      _videoController = VideoController(_player);

      await _player.open(Media(widget.videoUrl));

      if (widget.autoPlay) {
        await _player.play();
      }

      if (widget.loop) {
        _player.streams.completed.listen((completed) {
          if (completed) {
            _player.seek(Duration.zero);
            _player.play();
          }
        });
      }

      _player.streams.playing.listen((playing) {
        if (mounted) {
          setState(() {
            _isPlaying = playing;
          });
        }
      });

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Erreur initialisation mini player: $e');
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        if (widget.showControls) {
          setState(() {
            _showMiniControls = true;
          });

          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _showMiniControls = false;
              });
            }
          });
        }
      },
      child: Stack(
        children: [
          // Conteneur principal
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              child: _isInitialized
                  ? Video(
                controller: _videoController,
                controls: null,
                wakelock: false,
                fit: widget.fit,
              )
                  : Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueGrey.shade800,
                        Colors.blueGrey.shade900,
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.videocam,
                    color: Colors.white.withOpacity(0.5),
                    size: 40,
                  ),
                ),
              ),
            ),
          ),

          // Overlay de chargement
          if (!_isInitialized)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueGrey.shade800.withOpacity(0.8),
                      Colors.blueGrey.shade900.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.cyanAccent,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),

          // Overlay avec bouton play/pause
          if (_isInitialized && widget.showControls && _showMiniControls)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Indicateur de lecture en cours
          if (_isPlaying && !_showMiniControls)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'EN DIRECT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Bouton play/pause flottant (toujours visible si pas en lecture auto)
          if (_isInitialized && !_isPlaying && !widget.autoPlay)
            Positioned.fill(
              child: GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

// Fonction utilitaire pour créer un lecteur vidéo miniature
Widget createMiniVideoPlayer({
  required String videoUrl,
  double width = 200,
  double height = 120,
  bool autoPlay = false,
  bool showControls = false,
  bool loop = false,
  VoidCallback? onTap,
  BorderRadius? borderRadius,
  BoxFit fit = BoxFit.cover,
}) {
  return MiniVideoPlayer(
    videoUrl: videoUrl,
    width: width,
    height: height,
    autoPlay: autoPlay,
    showControls: showControls,
    loop: loop,
    onTap: onTap,
    borderRadius: borderRadius,
    fit: fit,
  );
}

// Version futuriste avec effet cyberpunk
class CyberMiniVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final double width;
  final double height;
  final bool autoPlay;
  final bool showGlow;
  final Color glowColor;
  final VoidCallback? onFullscreenTap;

  const CyberMiniVideoPlayer({
    super.key,
    required this.videoUrl,
    this.width = 250,
    this.height = 140,
    this.autoPlay = true,
    this.showGlow = true,
    this.glowColor = Colors.cyanAccent,
    this.onFullscreenTap,
  });

  @override
  State<CyberMiniVideoPlayer> createState() => _CyberMiniVideoPlayerState();
}

class _CyberMiniVideoPlayerState extends State<CyberMiniVideoPlayer> {
  late Player _player;
  late VideoController _videoController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _player = Player();
      _videoController = VideoController(_player);

      await _player.open(Media(widget.videoUrl));

      if (widget.autoPlay) {
        await _player.play();
      }

      _player.streams.playing.listen((playing) {
        if (mounted) {
          setState(() {
            _isPlaying = playing;
          });
        }
      });

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Erreur initialisation cyber player: $e');
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: widget.showGlow && _isPlaying
              ? [
            BoxShadow(
              color: widget.glowColor.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ]
              : null,
        ),
        child: Stack(
          children: [
            // Lecteur vidéo
            _isInitialized
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Video(
                controller: _videoController,
                controls: null,
                wakelock: false,
                fit: BoxFit.cover,
              ),
            )
                : _buildPlaceholder(),

            // Overlay cyberpunk
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.glowColor.withOpacity(_isPlaying ? 0.5 : 0.2),
                    width: _isPlaying ? 2 : 1,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      widget.glowColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Contrôles au survol
            if (_isHovering && _isInitialized)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Barre supérieure
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (widget.onFullscreenTap != null)
                              GestureDetector(
                                onTap: widget.onFullscreenTap,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: widget.glowColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.fullscreen,
                                    color: widget.glowColor,
                                    size: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Barre inférieure avec contrôles
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: _togglePlayPause,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      widget.glowColor.withOpacity(0.8),
                                      Colors.blueAccent.withOpacity(0.8),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.glowColor.withOpacity(0.3),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.black,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Indicateur de lecture
            if (_isPlaying && !_isHovering)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: widget.glowColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: widget.glowColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: widget.glowColor.withOpacity(0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'LECTURE',
                        style: TextStyle(
                          color: widget.glowColor,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Colors.blueGrey.shade900,
            Colors.blueGrey.shade800,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam,
              color: widget.glowColor.withOpacity(0.3),
              size: 40,
            ),
            const SizedBox(height: 8),
            CircularProgressIndicator(
              strokeWidth: 2,
              color: widget.glowColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

// Fonction utilitaire pour créer un lecteur cyberpunk
Widget createCyberMiniVideoPlayer({
  required String videoUrl,
  double width = 250,
  double height = 140,
  bool autoPlay = true,
  bool showGlow = true,
  Color glowColor = Colors.cyanAccent,
  VoidCallback? onFullscreenTap,
}) {
  return CyberMiniVideoPlayer(
    videoUrl: videoUrl,
    width: width,
    height: height,
    autoPlay: autoPlay,
    showGlow: showGlow,
    glowColor: glowColor,
    onFullscreenTap: onFullscreenTap,
  );
}