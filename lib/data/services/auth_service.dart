import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? get firebaseUser => _auth.currentUser;
  Stream<User?> authChanges() => _auth.authStateChanges();

  Future<void> signUp({required String name, required String email, required String password, required String phone}) async {
    final credential = await _auth.createUserWithEmailAndPassword(email:email.trim().toLowerCase(),password:password);
    final user=credential.user;
    if(user==null) throw Exception('Account creation failed.');
    try {
      await user.updateDisplayName(name.trim());
      await _db.collection('users').doc(user.uid).set({'uid':user.uid,'name':name.trim(),'email':email.trim().toLowerCase(),'phone':phone.trim(),'createdAt':FieldValue.serverTimestamp()});
      await user.sendEmailVerification();
    } finally { await _auth.signOut(); }
  }
  Future<User> signIn({required String email,required String password}) async {
    await _auth.signInWithEmailAndPassword(email:email.trim().toLowerCase(),password:password);
    await _auth.currentUser?.reload();
    final user=_auth.currentUser;
    if(user==null) throw Exception('Unable to sign in. Please retry.');
    if(!user.emailVerified){
      try { await user.sendEmailVerification(); } finally { await _auth.signOut(); }
      throw Exception('Please verify your email. We sent a verification link.');
    }
    return user;
  }
  Future<void> sendReset(String email) => _auth.sendPasswordResetEmail(email:email.trim().toLowerCase());
  Future<void> resendVerification() async { final u=_auth.currentUser; if(u==null) throw Exception('Please sign in first.'); await u.sendEmailVerification(); }
  Future<void> signOut() => _auth.signOut();
}
