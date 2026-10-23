import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../app/routes/app_routes.dart';
import '../data/models/user_model.dart';
import '../data/services/auth_service.dart';
import 'bookings_controller.dart';
import 'saved_rooms_controller.dart';
import 'profile_controller.dart';

class AuthController extends GetxController {
  AuthController(this.service);
  final AuthService service;
  final Rxn<UserModel> user=Rxn<UserModel>();
  final emailInput=TextEditingController(); final passwordInput=TextEditingController(); final nameInput=TextEditingController(); final phoneInput=TextEditingController();
  final RxBool loading=false.obs;
  final RxString error=''.obs;
  StreamSubscription<User?>? _subscription;
  bool get isLoggedIn => user.value!=null;
  @override void onInit(){super.onInit(); _subscription=service.authChanges().listen((u){ if(u!=null && u.emailVerified){user.value=UserModel.fromFirebase(u);} else {user.value=null;} });}
  Future<bool> login(String email,String password) async {if(loading.value)return false; loading.value=true;error.value='';try{final u=await service.signIn(email:email,password:password);user.value=UserModel.fromFirebase(u); await _refreshUserData(); Get.offAllNamed(AppRoutes.home);return true;}catch(e){error.value=_message(e);return false;}finally{loading.value=false;}}
  Future<bool> signup(String name,String email,String phone,String password) async {if(loading.value)return false;loading.value=true;error.value='';try{await service.signUp(name:name,email:email,phone:phone,password:password);Get.snackbar('Verify your email','Verification link sent to $email');Get.offAllNamed(AppRoutes.login);return true;}catch(e){error.value=_message(e);return false;}finally{loading.value=false;}}
  Future<bool> forgotPassword(String email) async {loading.value=true;error.value='';try{await service.sendReset(email);return true;}catch(e){error.value=_message(e);return false;}finally{loading.value=false;}}
  Future<void> logout() async {await service.signOut();user.value=null; if(Get.isRegistered<SavedRoomsController>())Get.find<SavedRoomsController>().clear(); if(Get.isRegistered<BookingsController>())Get.find<BookingsController>().clear(); if(Get.isRegistered<ProfileController>())Get.find<ProfileController>().clear();Get.offAllNamed(AppRoutes.login);}
  Future<void> _refreshUserData() async {if(Get.isRegistered<SavedRoomsController>())await Get.find<SavedRoomsController>().load();if(Get.isRegistered<BookingsController>())await Get.find<BookingsController>().load();if(Get.isRegistered<ProfileController>())await Get.find<ProfileController>().load();}
  String _message(Object e){if(e is FirebaseAuthException){switch(e.code){case 'email-already-in-use':return 'This email is already registered.';case 'invalid-email':return 'Please enter a valid email address.';case 'weak-password':return 'Use a stronger password (at least 6 characters).';case 'user-not-found':case 'wrong-password':case 'invalid-credential':return 'Email or password is incorrect.';case 'too-many-requests':return 'Too many attempts. Please try again later.';default:return e.message ?? 'Authentication failed.';}} return e.toString().replaceFirst('Exception: ','');}
  @override void onClose(){_subscription?.cancel();emailInput.dispose();passwordInput.dispose();nameInput.dispose();phoneInput.dispose();super.onClose();}
}
