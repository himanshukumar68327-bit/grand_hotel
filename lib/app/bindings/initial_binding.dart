import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/firestore_service.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/saved_rooms_controller.dart';
import '../../controllers/bookings_controller.dart';
import '../../controllers/profile_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);
    Get.put(FirestoreService(), permanent: true);
    Get.put(AuthController(Get.find<AuthService>()), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(SavedRoomsController(Get.find<FirestoreService>()), permanent: true);
    Get.put(BookingsController(Get.find<FirestoreService>()), permanent: true);
    Get.put(ProfileController(Get.find<FirestoreService>()), permanent: true);
  }
}
