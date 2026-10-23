import 'package:flutter_test/flutter_test.dart';
import 'package:grand_vista_hotel/controllers/home_controller.dart';

void main() {
  group('HomeController', () {
    late HomeController controller;

    setUp(() {
      controller = HomeController();
    });

    tearDown(() {
      controller.onClose();
    });

    test('shows all sample rooms by default', () {
      expect(controller.filteredRooms.length, 4);
    });

    test('filters rooms by category', () {
      controller.category.value = 'Deluxe';

      expect(controller.filteredRooms.length, 1);
      expect(controller.filteredRooms.single.category, 'Deluxe');
    });

    test('filters rooms by search term and maximum price', () {
      controller.query.value = 'garden';
      controller.maxPrice.value = 8000;

      expect(controller.filteredRooms.length, 1);
      expect(controller.filteredRooms.single.id, 'family');
    });

    test('reset restores default filters', () {
      controller.query.value = 'suite';
      controller.category.value = 'Suite';
      controller.maxPrice.value = 9800;

      controller.clearFilters();

      expect(controller.query.value, '');
      expect(controller.category.value, 'All');
      expect(controller.maxPrice.value, 12000);
      expect(controller.filteredRooms.length, 4);
    });
  });
}
