import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/routes/app_routes.dart';
import '../data/models/room_model.dart';
import 'auth_controller.dart';
import 'bookings_controller.dart';

class BookingFormController extends GetxController {
  final name = TextEditingController();
  final phone = TextEditingController();
  final checkIn = DateTime.now().add(const Duration(days: 1)).obs;
  final checkOut = DateTime.now().add(const Duration(days: 2)).obs;
  final guests = 1.obs;
  final submitting = false.obs;

  int get nights => checkOut.value.difference(checkIn.value).inDays;

  Future<void> pickCheckIn(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: checkIn.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (selected == null) return;
    checkIn.value = selected;
    if (!checkOut.value.isAfter(selected)) {
      checkOut.value = selected.add(const Duration(days: 1));
    }
  }

  Future<void> pickCheckOut(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: checkOut.value,
      firstDate: checkIn.value.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (selected != null) checkOut.value = selected;
  }

  Future<void> submit(RoomModel room) async {
    if (!Get.find<AuthController>().isLoggedIn) {
      Get.toNamed(AppRoutes.login);
      return;
    }
    if (name.text.trim().isEmpty || phone.text.trim().length < 7) {
      Get.snackbar('Missing details', 'Enter guest name and a valid phone number.');
      return;
    }
    if (nights < 1) {
      Get.snackbar('Invalid dates', 'Check-out must be after check-in.');
      return;
    }

    submitting.value = true;
    try {
      final id = await Get.find<BookingsController>().create(
        room: room,
        checkIn: checkIn.value,
        checkOut: checkOut.value,
        guests: guests.value,
        name: name.text.trim(),
        phone: phone.text.trim(),
      );
      if (id != null) {
        Get.dialog(
          AlertDialog(
            title: const Text('Booking request submitted'),
            content: Text('Reference: $id\nTotal: ₹${room.price * nights}'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.offAll(AppRoutes.bookings);
                },
                child: const Text('View bookings'),
              ),
            ],
          ),
        );
      }
    } finally {
      submitting.value = false;
    }
  }

  @override
  void onClose() {
    name.dispose();
    phone.dispose();
    super.onClose();
  }
}
