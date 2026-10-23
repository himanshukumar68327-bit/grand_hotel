import 'package:get/get.dart';
import '../../modules/auth/views/login_screen.dart';
import '../../modules/auth/views/signup_screen.dart';
import '../../modules/auth/views/forgot_password_screen.dart';
import '../../modules/home/views/home_screen.dart';
import '../../modules/rooms/views/room_details_screen.dart';
import '../../modules/bookings/views/booking_form_screen.dart';
import '../../controllers/booking_form_controller.dart';
import '../../controllers/splash_controller.dart';
import '../../modules/bookings/views/bookings_screen.dart';
import '../../modules/saved_rooms/views/saved_rooms_screen.dart';
import '../../modules/profile/views/profile_screen.dart';
import '../../modules/splash/views/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen(), binding: BindingsBuilder(() { Get.put(SplashController()); })),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.signup, page: () => const SignupScreen()),
    GetPage(name: AppRoutes.forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
    GetPage(name: AppRoutes.roomDetails, page: () => const RoomDetailsScreen()),
    GetPage(name: AppRoutes.booking, page: () => const BookingFormScreen(), binding: BindingsBuilder(() { Get.put(BookingFormController()); })),
    GetPage(name: AppRoutes.bookings, page: () => const BookingsScreen()),
    GetPage(name: AppRoutes.saved, page: () => const SavedRoomsScreen()),
    GetPage(name: AppRoutes.profile, page: () => const ProfileScreen()),
  ];
}
