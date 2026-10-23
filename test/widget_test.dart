import 'package:flutter_test/flutter_test.dart';
import 'package:grand_vista_hotel/data/models/room_model.dart';

void main() {
  test('demo room data has unique IDs and positive prices', () {
    expect(demoRooms.map((r) => r.id).toSet().length, demoRooms.length);
    expect(demoRooms.every((r) => r.price > 0), isTrue);
  });
}
