// lib/features/auth/data/repositories_impl/auth_repository_impl.dart
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:dartz/dartz.dart'; 

// Data Sources (The dependencies this layer relies on)
import '../datasources/auth_service.dart';
import '../datasources/cloudinary_service.dart';

// Domain Layer Contracts and Entities
import '../../domain/domain/repositories/auth_repository.dart';
import '../../domain/domain/entities/app_user.dart';
import '../../../core/failures/failures.dart'; // Import Failure for potential error handling

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;
  final CloudinaryService cloudinaryService;

  AuthRepositoryImpl({
    required this.authService,
    required this.cloudinaryService,
  });

  @override
  Stream<User?> get userStream => authService.userStream;

  @override
  User? getCurrentUser() => authService.currentUser;

  // 💡 Implementation using AuthService
  @override
  Future<User?> signUp(String username, String email, String password) async {
    try {
      return await authService.registerWithEmail(username, email, password);
    } on FirebaseAuthException catch (e) {
      // Typically, you would return a Left(AuthFailure(e.message)) here, 
      // but the AuthRepo definition did not use Either. Sticking to current return type.
      throw AuthFailure(message: e.message ?? 'Sign up failed.');
    }
  }

  // 💡 Implementation using AuthService
  @override
  Future<User?> signIn(String email, String password) async {
    try {
      return await authService.signInWithEmail(email, password);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(message: e.message ?? 'Sign in failed.');
    }
  }

  // 💡 Implementation using AuthService
  @override
  Future<void> signOut() async {
    await authService.signOut();
  }
  
  // 💡 Implementation using CloudinaryService
  @override
  Future<String?> uploadProfilePicture(File file) async {
    return await cloudinaryService.uploadFile(file);
  }

  // 💡 Implementation to fetch the full user entity
  @override
  Future<AppUser?> getAppUser(String uid) async {
    // You'll need to add a method to AuthService/AuthDataSource to fetch the user document
    // For now, assume a method exists on the authService:
    // return await authService.fetchAppUser(uid);
    // Since we don't have that method yet, we'll keep it as a placeholder:
    return null; // Placeholder: Must be implemented in AuthService/DataSource
  }
}