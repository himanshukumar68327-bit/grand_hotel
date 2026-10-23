import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/room_model.dart';
import '../../../app/routes/app_routes.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/saved_rooms_controller.dart';

class RoomDetailsScreen extends StatelessWidget {
  const RoomDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final room = Get.arguments as RoomModel;
    final saved = Get.find<SavedRoomsController>();
    final auth = Get.find<AuthController>();
    return Scaffold(
        appBar: AppBar(title: const Text('Room details'), actions: [
          Obx(() => IconButton(
              onPressed: () {
                if (!auth.isLoggedIn) {
                  Get.toNamed(AppRoutes.login);
                  return;
                }
                saved.toggle(room);
              },
              icon: Icon(saved.isSaved(room.id)
                  ? Icons.favorite
                  : Icons.favorite_border)))
        ]),
        body: ListView(children: [
          CachedNetworkImage(
              imageUrl: room.imageUrl,
              height: 260,
              width: double.infinity,
              fit: BoxFit.cover,
              errorWidget: (c, u, e) => const SizedBox(
                  height: 260, child: Icon(Icons.hotel, size: 70))),
          Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(room.name,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                        '${room.location} • ${room.size} • ${room.capacity} guests'),
                    const SizedBox(height: 14),
                    Text(room.description),
                    const SizedBox(height: 18),
                    Text('₹${room.price} / night',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 18),
                    const Text('Amenities',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: room.amenities
                            .map((a) => Chip(label: Text(a)))
                            .toList()),
                    const SizedBox(height: 24),
                    SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                            onPressed: () =>
                                Get.toNamed(AppRoutes.booking, arguments: room),
                            child: const Text('Book this room')))
                  ]))
        ]));
  }
}
