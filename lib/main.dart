import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const GrandVistaApp());
}

class GrandVistaApp extends StatelessWidget {
  const GrandVistaApp({super.key});
  @override
  Widget build(BuildContext context) => GetMaterialApp(
    title: 'Grand Vista Hotel', debugShowCheckedModeBanner: false,
    theme: AppTheme.light, initialBinding: InitialBinding(),
    initialRoute: AppRoutes.splash, getPages: AppPages.pages,
  );
}
