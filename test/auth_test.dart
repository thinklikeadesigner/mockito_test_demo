import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito_test_demo/auth.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
    ]);
  }
}

void main() {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();

  final Auth auth = Auth(auth: mockFirebaseAuth);

  setUp(() => {});
  tearDown(() => {});

  // if(MockUser() == McokUser()) because they are different instances of MockUser

  test("emit occurs", () async {
    expectLater(auth.user, emitsInOrder([_mockUser]));
  });

  test("create account", () async {
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'tadas@gmail.com', password: "123456"))
        .thenAnswer((realInvocation) => null);

    expect(
        await auth.createAccount(email: 'tadas@gmail.com', password: "123456"),
        "Success");
  });

  test("create account exception", () async {
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'tadas@gmail.com', password: "123456"))
        .thenAnswer((realInvocation) =>
            throw FirebaseAuthException(message: 'You Screwed up'));

    expect(
        await auth.createAccount(email: 'tadas@gmail.com', password: "123456"),
        'You Screwed up');
  });

  test("Sign in ", () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'tadas@gmail.com', password: "123456"))
        .thenAnswer((realInvocation) => null);

    expect(await auth.signIn(email: 'tadas@gmail.com', password: "123456"),
        "Success");
  });

  test("sign in exception", () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'tadas@gmail.com', password: "123456"))
        .thenAnswer((realInvocation) =>
            throw FirebaseAuthException(message: 'You Screwed up'));

    expect(await auth.signIn(email: 'tadas@gmail.com', password: "123456"),
        'You Screwed up');
  });
  test("Sign out", () async {
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) => null);

    expect(await auth.signOut(), "Success");
  });

  test("sign out exception", () async {
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) =>
        throw FirebaseAuthException(message: 'You Screwed up'));

    expect(await auth.signOut(), 'You Screwed up');
  });
}
