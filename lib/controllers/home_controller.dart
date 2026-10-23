import 'package:get/get.dart';

import '../data/models/room_model.dart';

class HomeController extends GetxController {
  final RxString query = ''.obs;
  final RxString category = 'All'.obs;
  final RxDouble maxPrice = 12000.0.obs;

  final RxList<RoomModel> rooms = demoRooms.obs;

  List<RoomModel> get filteredRooms {
    final search = query.value.trim().toLowerCase();

    return rooms.where((room) {
      final matchesSearch = search.isEmpty ||
          room.name.toLowerCase().contains(search) ||
          room.location.toLowerCase().contains(search) ||
          room.amenities.any((amenity) => amenity.toLowerCase().contains(search));

      final matchesCategory =
          category.value == 'All' || room.category == category.value;
      final matchesPrice = room.price <= maxPrice.value;

      return matchesSearch && matchesCategory && matchesPrice;
    }).toList();
  }

  /// Refreshes the local sample catalogue while retaining the active filters.
  Future<void> refreshRooms() async {
    rooms.assignAll(demoRooms);
  }

  void clearFilters() {
    query.value = '';
    category.value = 'All';
    maxPrice.value = 12000;
  }
}
