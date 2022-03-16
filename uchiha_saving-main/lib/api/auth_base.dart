import 'package:firebase_auth/firebase_auth.dart';
import 'package:uchiha_saving/models/person.dart';

abstract class AuthBase {
  Person? personFromFirebase(User? user);
  Stream<Person?> get stream;
  Future<Person?> signInWithEmailAndPassword(String email, String password);
  Future<Person?> registerWithEmailAndPassword(String email, String password);
  Future<Person?> signinWithGoogle();
  Future<void> resetPassword(String email);
  Future<void> signOut();
}
