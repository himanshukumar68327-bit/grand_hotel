
import 'package:get/get.dart';

import '../data/models/booking_model.dart';
import '../data/models/room_model.dart';
import '../data/services/firestore_service.dart';

class BookingsController extends GetxController {
  BookingsController(this.service);

  final FirestoreService service;

  final RxList<BookingModel> bookings = <BookingModel>[].obs;
  final RxBool loading = false.obs;
  final RxString error = ''.obs;

  Future<void> load() async {
    loading.value = true;

    try {
      bookings.assignAll(await service.getBookings());
      error.value = '';
    } catch (e) {
      if (e.toString().contains('verified')) {
        clear();
      } else {
        error.value = 'Unable to load bookings.';
      }
    } finally {
      loading.value = false;
    }
  }

  Future<String?> create({
    required RoomModel room,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
    required String name,
    required String phone,
  }) async {
    try {
      final id = await service.createBooking(
        room: room,
        checkIn: checkIn,
        checkOut: checkOut,
        guests: guests,
        guestName: name,
        guestPhone: phone,
      );

      await load();
      return id;
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
      return null;
    }
  }

  Future<bool> cancel(String id) async {
    try {
      await service.cancelBooking(id);
      await load();
      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    }
  }

  void clear() {
    bookings.clear();
    error.value = '';
  }
}
