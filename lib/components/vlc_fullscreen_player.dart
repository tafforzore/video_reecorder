import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VlcFullscreenPlayer extends StatefulWidget {
  final Widget child;
  final bool isPlaying;
  final String currentTime;
  final String totalTime;
  final double progressValue;
  final Function() onPlayPause;
  final Function() onForward;
  final Function() onRewind;
  final Function(double) onProgressChanged;
  final Function() onExitFullscreen;
  final Function() onToggleMute;
  final bool isMuted;
  final Function() onInfo;
  final String? fileName;
  final String? resolution;

  const VlcFullscreenPlayer({
    super.key,
    required this.child,
    required this.isPlaying,
    required this.currentTime,
    required this.totalTime,
    required this.progressValue,
    required this.onPlayPause,
    required this.onForward,
    required this.onRewind,
    required this.onProgressChanged,
    required this.onExitFullscreen,
    required this.onToggleMute,
    required this.isMuted,
    required this.onInfo,
    this.fileName,
    this.resolution,
  });

  @override
  State<VlcFullscreenPlayer> createState() => _VlcFullscreenPlayerState();
}

class _VlcFullscreenPlayerState extends State<VlcFullscreenPlayer> {
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _resetHideTimer();
  }

  void _resetHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _resetHideTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Video
            Positioned.fill(child: widget.child),

            // Contrôles
            if (_showControls)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Top bar
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Bouton retour
                            IconButton(
                              onPressed: widget.onExitFullscreen,
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),

                            // Informations du fichier
                            if (widget.fileName != null)
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    widget.fileName!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),

                            // Boutons de contrôle
                            Row(
                              children: [
                                if (widget.onInfo != null)
                                  IconButton(
                                    onPressed: widget.onInfo,
                                    icon: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      child: const Icon(
                                        Icons.info_outline,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),

                                IconButton(
                                  onPressed: widget.onToggleMute,
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    child: Icon(
                                      widget.isMuted
                                          ? Icons.volume_off
                                          : Icons.volume_up,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Bottom controls
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Progress bar
                            SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 10,
                                  elevation: 8,
                                ),
                                overlayShape: SliderComponentShape.noOverlay,
                                activeTrackColor: Colors.blue.shade400,
                                inactiveTrackColor: Colors.grey.withOpacity(0.3),
                                thumbColor: Colors.blue.shade300,
                              ),
                              child: Slider(
                                value: widget.progressValue,
                                onChanged: widget.onProgressChanged,
                                min: 0,
                                max: 100,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Time indicators
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.currentTime,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    widget.totalTime,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Control buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Rewind
                                _FullscreenControlButton(
                                  icon: Icons.replay_10,
                                  onTap: widget.onRewind,
                                  size: 50,
                                ),

                                // Play/Pause
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade400,
                                        Colors.blue.shade700,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.shade400
                                            .withOpacity(0.5),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    onPressed: widget.onPlayPause,
                                    icon: Icon(
                                      widget.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    iconSize: 50,
                                  ),
                                ),

                                // Forward
                                _FullscreenControlButton(
                                  icon: Icons.forward_10,
                                  onTap: widget.onForward,
                                  size: 50,
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

            // Indicateur de double tap pour fullscreen
            if (!_showControls)
              Positioned.fill(
                child: Center(
                  child: AnimatedOpacity(
                    opacity: 0,
                    duration: const Duration(seconds: 2),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.fullscreen_exit,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }
}

class _FullscreenControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const _FullscreenControlButton({
    required this.icon,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.5),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: size * 0.5,
        ),
      ),
    );
  }
}