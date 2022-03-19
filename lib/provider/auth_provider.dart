import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider {
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp({required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw ErrorHint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw ErrorHint('The account already exists for that email.');
      }
      throw ErrorHint(e.message ?? 'An error has occurred');
    } catch (e) {
      ErrorHint('An error has occurred');
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ErrorHint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw ErrorHint('Wrong password provided for that user.');
      }
      throw ErrorHint(e.message ?? 'An error has occurred');
    } catch (e) {
      ErrorHint('An error has occurred');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ErrorHint(e.message ?? 'An error has occurred');
    } catch (e) {
      ErrorHint('An error has occurred');
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw ErrorHint('An error has occurred');
    }
  }
}
