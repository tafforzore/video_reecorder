import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:get/get.dart';

class PlayerController extends GetxController {
  final Rx<VlcPlayerController?> vlcController = Rx<VlcPlayerController?>(null);

  @override
  void onInit() {
    super.onInit();
    // Example network video URL. You can replace this with a local file path.
    const videoUrl = 'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4';
    vlcController.value = VlcPlayerController.network(
      videoUrl,
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

  @override
  void onClose() {
    vlcController.value?.dispose();
    super.onClose();
  }
}
