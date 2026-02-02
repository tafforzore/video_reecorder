import 'package:audioplayer/infrastructure/dal/services/player_manager.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';

import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';

void main() async {
  var initialRoute = await Routes.initialRoute;
  MediaKit.ensureInitialized();
  Get.put(PlayerManager());

  WidgetsFlutterBinding.ensureInitialized();
  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;
  Main(this.initialRoute);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: Nav.routes,
    );
  }
}
