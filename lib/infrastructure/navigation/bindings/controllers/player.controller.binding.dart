import 'package:get/get.dart';

import '../../../../presentation/player/controllers/player.controller.dart';

class PlayerControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayerController>(
      () => PlayerController(),
    );
  }
}
