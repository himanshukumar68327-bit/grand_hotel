import 'package:firebase_auth/firebase_auth.dart';
class UserModel {
  const UserModel({required this.uid, required this.email, required this.name, this.phone = ''});
  final String uid, email, name, phone;
  factory UserModel.fromFirebase(User u) => UserModel(uid:u.uid,email:u.email ?? '',name:u.displayName ?? '',phone:u.phoneNumber ?? '');
}
