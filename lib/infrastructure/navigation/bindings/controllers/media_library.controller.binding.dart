import 'package:get/get.dart';

import '../../../../presentation/media_library/controllers/media_library.controller.dart';

class MediaLibraryControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MediaLibraryController>(
      () => MediaLibraryController(),
    );
  }
}
