import 'package:flutter_test/flutter_test.dart';
import 'package:ride_swg/core/auth/auth_service.dart';

void main() {
  test('AuthService has valid test accounts', () {
    expect(AuthService.testAccounts.isNotEmpty, isTrue);
    expect(AuthService.testAccounts.length, equals(4));

    final driver = AuthService.testAccounts.first;
    expect(driver.email, equals('driver@rideswg.com'));
    expect(driver.displayName, equals('Alex Mercer'));
  });

  test('AuthService test account sign in, verify, and sign out', () async {
    final auth = AuthService.instance;

    // Initially unauthenticated
    await auth.signOut();
    expect(auth.isAuthenticated, isFalse);

    // Sign in with valid test account
    await auth.signIn(
      email: 'driver@rideswg.com',
      password: 'RideSwg2026!',
    );
    expect(auth.isAuthenticated, isTrue);
    expect(auth.currentUserName, equals('Alex Mercer'));
    expect(auth.currentUserRole, equals('Pro Street Tuner'));

    // Sign out
    await auth.signOut();
    expect(auth.isAuthenticated, isFalse);

    // Sign in with 1-tap test login
    final demoAccount = AuthService.testAccounts.last;
    await auth.loginAsTestAccount(demoAccount);
    expect(auth.isAuthenticated, isTrue);
    expect(auth.currentUserName, equals('Demo Driver'));

    // Sign out
    await auth.signOut();
    expect(auth.isAuthenticated, isFalse);
  });

  test('AuthService invalid password does not authenticate', () async {
    final auth = AuthService.instance;
    await auth.signOut();

    // In test env, Supabase is not initialized so signIn will throw
    // (either Exception for bad password or AssertionError for uninitialized Supabase).
    // Either way the user must NOT end up authenticated.
    try {
      await auth.signIn(
        email: 'driver@rideswg.com',
        password: 'wrong_password',
      );
    } catch (_) {
      // Expected to throw
    }
    expect(auth.isAuthenticated, isFalse);
  });
  test('AuthService loginAsTestAccount works', () async {
    final auth = AuthService.instance;
    await auth.signOut();
    final demo = AuthService.testAccounts.last;
    await auth.loginAsTestAccount(demo);
    expect(auth.isAuthenticated, isTrue);
    expect(auth.currentUserName, equals(demo.displayName));
  });
}

