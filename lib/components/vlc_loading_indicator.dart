import 'package:audioplayer/components/vlc_glass_card.dart';
import 'package:flutter/material.dart';

class VlcLoadingIndicator extends StatelessWidget {
  final String? message;

  const VlcLoadingIndicator({
    super.key,
    this.message = 'Chargement...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
            if (message != null) ...[
              const SizedBox(height: 20),
              Text(
                message!,
                style: TextStyle(
                  color: Colors.blue.shade300,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}