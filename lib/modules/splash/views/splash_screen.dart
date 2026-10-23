import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../../../controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});
  @override Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.hotel, size: 64, color: AppColors.gold), SizedBox(height: 12), Text('GRAND VISTA HOTEL', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2))])));
  }
}
