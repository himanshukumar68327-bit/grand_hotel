import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/booking_form_controller.dart';
import '../../../controllers/bookings_controller.dart';
import '../../../data/models/room_model.dart';

class BookingFormScreen extends GetView<BookingFormController> {
  const BookingFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final room = Get.arguments as RoomModel;
    return Scaffold(
        appBar: AppBar(title: const Text('Complete booking')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          Text(room.name,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text('₹${room.price} per night'),
          const SizedBox(height: 18),
          TextField(
              controller: controller.name,
              decoration: const InputDecoration(labelText: 'Guest full name')),
          const SizedBox(height: 12),
          TextField(
              controller: controller.phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Contact phone')),
          const SizedBox(height: 12),
          Obx(() => ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Check-in'),
              subtitle:
                  Text(DateFormat.yMMMd().format(controller.checkIn.value)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => controller.pickCheckIn(context))),
          Obx(() => ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Check-out'),
              subtitle:
                  Text(DateFormat.yMMMd().format(controller.checkOut.value)),
              trailing: const Icon(Icons.calendar_month),
              onTap: () => controller.pickCheckOut(context))),
          Obx(() => DropdownButtonFormField<int>(
              initialValue: controller.guests.value,
              decoration: const InputDecoration(labelText: 'Guests'),
              items: List.generate(
                  room.capacity,
                  (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text('${i + 1} guest${i == 0 ? '' : 's'}'))),
              onChanged: (v) {
                if (v != null) controller.guests.value = v;
              })),
          const SizedBox(height: 18),
          Obx(() => Card(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Stay: ${controller.nights} night(s)'),
                        Text('Total: ₹${room.price * controller.nights}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20))
                      ])))),
          const SizedBox(height: 18),
          Obx(() => Get.find<BookingsController>().error.value.isEmpty
              ? const SizedBox.shrink()
              : Text(Get.find<BookingsController>().error.value,
                  style: const TextStyle(color: Colors.red))),
          Obx(() => FilledButton(
              onPressed: controller.submitting.value
                  ? null
                  : () => controller.submit(room),
              child: controller.submitting.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit booking request'))),
        ]));
  }
}
