import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/booking_model.dart';
import '../models/room_model.dart';

class FirestoreService {
  FirestoreService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  String get _uid {
    final user = _auth.currentUser;
    if (user == null || !user.emailVerified) {
      throw Exception('Please sign in with a verified email.');
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _savedRooms =>
      _db.collection('users').doc(_uid).collection('savedRooms');

  CollectionReference<Map<String, dynamic>> get _bookings =>
      _db.collection('users').doc(_uid).collection('bookings');

  Future<List<RoomModel>> getSavedRooms() async {
    final snapshot = await _savedRooms.get();
    return snapshot.docs.map((doc) => RoomModel.fromMap(doc.data())).toList();
  }

  Future<bool> isSaved(String id) async =>
      (await _savedRooms.doc(id).get()).exists;

  Future<void> toggleSaved(RoomModel room) async {
    final reference = _savedRooms.doc(room.id);
    final snapshot = await reference.get();

    if (snapshot.exists) {
      await reference.delete();
    } else {
      await reference.set({
        ...room.toMap(),
        'savedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<List<BookingModel>> getBookings() async {
    final snapshot =
        await _bookings.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map(BookingModel.fromDoc).toList();
  }

  Future<String> createBooking({
    required RoomModel room,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
    required String guestName,
    required String guestPhone,
  }) async {
    if (!checkOut.isAfter(checkIn)) {
      throw Exception('Check-out must be after check-in.');
    }
    if (guests < 1 || guests > room.capacity) {
      throw Exception('Guest count exceeds this room capacity.');
    }
    if (guestName.trim().isEmpty) {
      throw Exception('Please enter the guest name.');
    }
    if (guestPhone.trim().length < 7) {
      throw Exception('Please enter a valid contact phone number.');
    }

    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('Please sign in to book a room.');
    }

    await currentUser.reload();
    final user = _auth.currentUser;
    if (user == null || !user.emailVerified) {
      throw Exception('Please verify your email before booking.');
    }
    if (user.email == null || user.email!.isEmpty) {
      throw Exception('Your account email is unavailable. Please sign in again.');
    }

    // Refresh claims so Firestore Rules evaluate the latest email_verified value.
    await user.getIdToken(true);

    final nights = checkOut.difference(checkIn).inDays;
    if (nights < 1) {
      throw Exception('Check-out must be at least one day after check-in.');
    }

    final reference = _bookings.doc();
    final booking = BookingModel(
      id: reference.id,
      room: room,
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
      total: nights * room.price,
      status: 'Requested',
      guestName: guestName.trim(),
      guestPhone: guestPhone.trim(),
    );

    final data = booking.toMap();
    data['ownerUid'] = user.uid;
    data['ownerEmail'] = user.email;

    await reference.set(data);
    return reference.id;
  }

  Future<void> cancelBooking(String id) async {
    final reference = _bookings.doc(id);
    final snapshot = await reference.get();

    if (!snapshot.exists) {
      throw Exception('Booking not found.');
    }
    if (snapshot.data()?['status'] == 'Cancelled') {
      return;
    }

    await reference.update({
      'status': 'Cancelled',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>> getProfile() async {
    final snapshot = await _db.collection('users').doc(_uid).get();
    return snapshot.data() ?? <String, dynamic>{};
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
  }) async {
    final user = _auth.currentUser;
    if (user == null || !user.emailVerified) {
      throw Exception('Please sign in with a verified email.');
    }

    await _db.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': name.trim(),
      'phone': phone.trim(),
      'email': user.email,
    }, SetOptions(merge: true));

    await user.updateDisplayName(name.trim());
  }
}
