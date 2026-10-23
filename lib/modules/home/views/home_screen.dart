import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_theme.dart';
import '../../../controllers/home_controller.dart';
import '../../../shared/widgets/room_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grand Vista'),
        actions: [
          IconButton(
            tooltip: 'Saved rooms',
            onPressed: () => Get.toNamed(AppRoutes.saved),
            icon: const Icon(Icons.favorite_border),
          ),
          IconButton(
            tooltip: 'My bookings',
            onPressed: () => Get.toNamed(AppRoutes.bookings),
            icon: const Icon(Icons.book_online),
          ),
          IconButton(
            tooltip: 'My profile',
            onPressed: () => Get.toNamed(AppRoutes.profile),
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshRooms,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.navy, AppColors.navy2],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'A stay worth remembering',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Discover comfort. Book with confidence.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      onChanged: (value) => controller.query.value = value,
                      decoration: InputDecoration(
                        hintText: 'Search room, location, amenity',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: Obx(
                          () => controller.query.value.isEmpty
                              ? const SizedBox.shrink()
                              : IconButton(
                                  tooltip: 'Clear search',
                                  onPressed: () => controller.query.value = '',
                                  icon: const Icon(Icons.close),
                                ),
                        ),
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Explore rooms',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: controller.clearFilters,
                      icon: const Icon(Icons.filter_alt_off, size: 18),
                      label: const Text('Reset'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Standard', 'Deluxe', 'Family', 'Suite']
                          .map(
                            (category) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(category),
                                selected: controller.category.value == category,
                                onSelected: (_) =>
                                    controller.category.value = category,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Card(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.payments_outlined, size: 20),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Maximum price per night',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              '₹${controller.maxPrice.value.round()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.navy,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: controller.maxPrice.value,
                          min: 3000,
                          max: 12000,
                          divisions: 9,
                          label: '₹${controller.maxPrice.value.round()}',
                          onChanged: (value) => controller.maxPrice.value = value,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(
                  () => Text(
                    '${controller.filteredRooms.length} rooms available',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: Obx(
                () => controller.filteredRooms.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.search_off, size: 44),
                                SizedBox(height: 10),
                                Text('No rooms match your filters.'),
                                SizedBox(height: 6),
                                Text('Try a different search or reset filters.'),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: RoomCard(
                              room: controller.filteredRooms[index],
                            ),
                          ),
                          childCount: controller.filteredRooms.length,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
