import 'package:get/get.dart';
import '../app/routes/app_routes.dart';
import 'auth_controller.dart';

class SplashController extends GetxController {
  @override void onReady() { super.onReady(); _continue(); }
  Future<void> _continue() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final auth = Get.find<AuthController>();
    Get.offAllNamed(auth.isLoggedIn ? AppRoutes.home : AppRoutes.login);
  }
}
