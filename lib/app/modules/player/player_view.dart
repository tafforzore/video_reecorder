import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:get/get.dart';
import 'player_controller.dart';

class PlayerView extends GetView<PlayerController> {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VLC Player'),
      ),
      body: Center(
        child: Obx(() {
          if (controller.vlcController.value == null) {
            return const CircularProgressIndicator();
          }
          return VlcPlayer(
            controller: controller.vlcController.value!,
            aspectRatio: 16 / 9,
            placeholder: const Center(child: CircularProgressIndicator()),
          );
        }),
      ),
    );
  }
}
