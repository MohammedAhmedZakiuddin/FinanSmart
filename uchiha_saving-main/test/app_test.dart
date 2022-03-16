import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:uchiha_saving/api/auth.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User?> authStateChanges() {
    return Stream.fromIterable([_mockUser]);
  }
}

void main() {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final Auth auth = Auth();
  setUp(() {});
  tearDown(() {});

  test("emit occurs", () async {
    expectLater(auth.stream, emitsInOrder([_mockUser]));
  });

  test("sign in", () async {
    when(
      mockFirebaseAuth.signInWithEmailAndPassword(
          email: "tadas@gmail.com", password: "123456"),
    ).thenAnswer((realInvocation) async {
      return await mockFirebaseAuth.signInWithEmailAndPassword(
          email: "tadas@gmail.com", password: "123456");
    });

    expect(await auth.signInWithEmailAndPassword("tadas@gmail.com", "123456"),
        "Success");
  });
  //
  // test("sign in exception", () async {
  //   when(
  //     mockFirebaseAuth.signInWithEmailAndPassword(
  //         email: "tadas@gmail.com", password: "123456"),
  //   ).thenAnswer((realInvocation)
  //   async {
  //     // throw FirebaseAuthException(
  //     //     code: "",
  //     //     message: "You screwed up");
  //   return await mockFirebaseAuth.signInWithEmailAndPassword(
  //   email: "tadas@gmail.com", password: "123456");
  //
  //   }
  //  );
  //
  //   expect(await auth.signInWithEmailAndPassword( "tadas@gmail.com",  "123456"),
  //       "You screwed up");
  // });
}
