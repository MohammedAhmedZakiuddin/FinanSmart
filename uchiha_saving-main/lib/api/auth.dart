import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uchiha_saving/api/auth_base.dart';
import 'package:uchiha_saving/models/address.dart';
import 'package:uchiha_saving/models/name.dart';
import 'package:uchiha_saving/models/person.dart';

class Auth implements AuthBase {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  @override
  Person? personFromFirebase(User? user) {
    return user == null
        ? null
        : Person(
            id: user.uid,
            phone: "",
            email: user.email!,
            address: Address(
              street: "street",
              roomNumber: "room number",
              city: "city",
              state: "state",
              zipCode: 00000,
            ),
            name: Name(
              firstName: "firstName",
              middleName: "middleName",
              lastName: "lastName",
            ),
            photoURL: "photoURL",
            balance: 0.00,
          );
  }

  @override
  Stream<Person?> get stream =>
      _firebaseAuth.authStateChanges().map((user) => personFromFirebase(user!));

  @override
  Future<Person?> registerWithEmailAndPassword(
      String email, String password) async {
    UserCredential _userCredential;
    try {
      _userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    }
    return personFromFirebase(_userCredential.user!);
  }

  @override
  Future<Person?> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential _userCredential;
    try {
      _userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    }
    return personFromFirebase(_userCredential.user!);
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    }
  }

  @override
  Future<Person?> signinWithGoogle() async {
    final _googleAccount = await _googleSignIn.signIn();
    if (_googleAccount != null) {
      final googleAuth = await _googleAccount.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final authResult = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return personFromFirebase(authResult.user!);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_firebaseAuth_TOKEN',
          message: 'Missing Google Auth TOken',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<void> signOut() async {
    _googleSignIn.signOut();
    _firebaseAuth.signOut();
  }
}
