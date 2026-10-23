import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/bookings_controller.dart';

class BookingsScreen extends GetView<BookingsController> {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My bookings'),
        actions: [
          IconButton(
            onPressed: controller.load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (!auth.isLoggedIn) {
          return Center(
            child: FilledButton(
              onPressed: () => Get.toNamed(AppRoutes.login),
              child: const Text('Sign in to view bookings'),
            ),
          );
        }
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }
        if (controller.bookings.isEmpty) {
          return const Center(
            child: Text('No bookings yet. Explore rooms to plan your stay.'),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final booking = controller.bookings[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.room.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${DateFormat.yMMMd().format(booking.checkIn)} – '
                        '${DateFormat.yMMMd().format(booking.checkOut)}',
                      ),
                      Text('${booking.guests} guest(s) • ₹${booking.total}'),
                      const SizedBox(height: 6),
                      Chip(label: Text(booking.status)),
                      if (booking.status != 'Cancelled')
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Cancel booking?'),
                                  content: const Text(
                                    'This will mark your request as cancelled.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: Get.back,
                                      child: const Text('Keep booking'),
                                    ),
                                    FilledButton(
                                      onPressed: () async {
                                        Get.back();
                                        final ok = await controller.cancel(booking.id);
                                        if (ok) {
                                          Get.snackbar(
                                            'Booking updated',
                                            'Booking cancelled.',
                                          );
                                        }
                                      },
                                      child: const Text('Cancel booking'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text('Cancel request'),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
