import 'package:audioplayer/app/modules/home/home_binding.dart';
import 'package:audioplayer/app/modules/home/home_view.dart';
import 'package:audioplayer/app/modules/player/player_binding.dart';
import 'package:audioplayer/app/modules/player/player_view.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.PLAYER,
      page: () => const PlayerView(),
      binding: PlayerBinding(),
    ),
  ];
}
