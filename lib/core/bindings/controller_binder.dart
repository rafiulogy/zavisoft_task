import 'package:get/get.dart';
import '../../features/authentication/controllers/login_controller.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../features/profile/controllers/profile_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
      fenix: true,
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
      fenix: true,
    );
  }
}
