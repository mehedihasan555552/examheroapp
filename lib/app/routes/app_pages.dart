import 'package:get/get.dart';

import '../modules/info/bindings/info_binding.dart';
import '../modules/info/views/info_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.INFO;

  static final routes = [
    GetPage(
      name: _Paths.INFO,
      page: () => const InfoView(),
      binding: InfoBinding(),
    ),
  ];
}
