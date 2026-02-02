import 'package:audioplayer/components/vlc_glass_card.dart';
import 'package:flutter/material.dart';

class VlcErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const VlcErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: VlcGlassCard(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red.shade300,
                size: 60,
              ),
              const SizedBox(height: 20),
              Text(
                'Erreur',
                style: TextStyle(
                  color: Colors.red.shade300,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red.shade300.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: onRetry,
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh,
                        color: Colors.blue.shade300,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Réessayer',
                        style: TextStyle(
                          color: Colors.blue.shade300,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}