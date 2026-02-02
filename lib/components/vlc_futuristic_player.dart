import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VlcFuturisticPlayer extends StatelessWidget {
  final Widget? child;
  final bool isPlaying;
  final String? currentTime;
  final String? totalTime;
  final double? progressValue;
  final Function()? onPlayPause;
  final Function()? onForward;
  final Function()? onRewind;
  final Function(double)? onProgressChanged;

  const VlcFuturisticPlayer({
    super.key,
    this.child,
    this.isPlaying = false,
    this.currentTime,
    this.totalTime,
    this.progressValue,
    this.onPlayPause,
    this.onForward,
    this.onRewind,
    this.onProgressChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade900.withOpacity(0.8),
            Colors.black,
            Colors.black,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Video area
          Positioned.fill(
            child: child ??
                Container(
                  color: Colors.black,
                  child: Center(
                    child: Icon(
                      Icons.play_circle_filled,
                      size: 80,
                      color: Colors.blue.shade300.withOpacity(0.3),
                    ),
                  ),
                ),
          ),

          // Gradient overlay top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Gradient overlay bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Controls overlay
          if (onPlayPause != null)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                              elevation: 4,
                            ),
                            overlayShape: SliderComponentShape.noOverlay,
                            activeTrackColor: Colors.blue.shade400,
                            inactiveTrackColor: Colors.grey.shade800,
                            thumbColor: Colors.blue.shade300,
                          ),
                          child: Slider(
                            value: progressValue ?? 0,
                            onChanged: onProgressChanged,
                            min: 0,
                            max: 100,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                currentTime ?? '00:00',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                totalTime ?? '00:00',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
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
                      _ControlButton(
                        icon: Icons.replay_10,
                        onTap: onRewind,
                        iconSize: 30,
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
                              color: Colors.blue.shade400.withOpacity(0.5),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: onPlayPause,
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 35,
                          ),
                          iconSize: 40,
                        ),
                      ),

                      // Forward
                      _ControlButton(
                        icon: Icons.forward_10,
                        onTap: onForward,
                        iconSize: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Function()? onTap;
  final double iconSize;

  const _ControlButton({
    required this.icon,
    this.onTap,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.4),
          border: Border.all(
            color: Colors.blue.shade300.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.blue.shade300,
          size: iconSize,
        ),
      ),
    );
  }
}