// lib/features/auth/data/datasources/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/domain/entities/app_user.dart'; // Updated import
import '../../../core/config.dart'; // Updated import

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream of Firebase User
  Stream<User?> get userStream => _auth.authStateChanges();
  
  // Register
  Future<User?> registerWithEmail(String username, String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = cred.user;
    if (user != null) {
      // create user doc in firestore
      final appUser = AppUser(id: user.uid, username: username, email: email);
      await _db.collection(Config.usersCollection).doc(user.uid).set(appUser.toMap());
    }                                                                                                                                                                                    
    return user;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return cred.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}