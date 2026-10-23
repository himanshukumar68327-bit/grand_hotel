import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/services/firestore_service.dart';

class ProfileController extends GetxController {
  ProfileController(this.service);

  final FirestoreService service;
  final RxMap<String, dynamic> profile = <String, dynamic>{}.obs;
  final nameInput = TextEditingController();
  final phoneInput = TextEditingController();
  final RxBool loading = false.obs;
  final RxBool saving = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    try {
      profile.assignAll(await service.getProfile());
      nameInput.text = profile['name']?.toString() ?? '';
      phoneInput.text = profile['phone']?.toString() ?? '';
      error.value = '';
    } catch (e) {
      if (e.toString().contains('verified')) {
        clear();
      } else {
        error.value = 'Unable to load profile.';
      }
    } finally {
      loading.value = false;
    }
  }

  // Avoid naming this method `update`: GetxController already defines update().
  Future<bool> saveProfile({
    required String name,
    required String phone,
  }) async {
    saving.value = true;
    try {
      await service.updateProfile(name: name, phone: phone);
      await load();
      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      saving.value = false;
    }
  }

  void clear() {
    profile.clear();
    nameInput.clear();
    phoneInput.clear();
    error.value = '';
  }

  @override
  void onClose() {
    nameInput.dispose();
    phoneInput.dispose();
    super.onClose();
  }
}
