import 'package:flutter_test/flutter_test.dart';
import 'package:grand_vista_hotel/data/models/room_model.dart';

void main() {
  group('RoomModel', () {
    test('serializes and restores a room without losing key fields', () {
      const original = RoomModel(
        id: 'deluxe',
        name: 'Deluxe King Room',
        category: 'Deluxe',
        description: 'A spacious room.',
        price: 5200,
        capacity: 2,
        amenities: ['Wi-Fi', 'King bed'],
        imageUrl: 'https://example.com/room.jpg',
        size: '360 sq ft',
        location: 'City Centre',
        rating: 4.9,
        badge: 'GUEST FAVOURITE',
      );

      final restored = RoomModel.fromMap(original.toMap());

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.category, original.category);
      expect(restored.price, original.price);
      expect(restored.capacity, original.capacity);
      expect(restored.amenities, original.amenities);
      expect(restored.rating, original.rating);
    });

    test('sample catalogue contains the categories used by the UI', () {
      final categories = demoRooms.map((room) => room.category).toSet();

      expect(categories, containsAll(['Standard', 'Deluxe', 'Family', 'Suite']));
      expect(demoRooms, isNotEmpty);
      expect(demoRooms.every((room) => room.price > 0), isTrue);
    });
  });
}
