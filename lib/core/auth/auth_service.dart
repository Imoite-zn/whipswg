import 'package:flutter/foundation.dart';
import 'package:ride_swg/core/supabase/supabase_config.dart';

class TestAccount {
  final String email;
  final String password;
  final String displayName;
  final String role;
  final String badge;

  const TestAccount({
    required this.email,
    required this.password,
    required this.displayName,
    required this.role,
    required this.badge,
  });
}

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._internal();

  AuthService._internal() {
    _initSupabaseListener();
  }

  void _initSupabaseListener() {
    try {
      if (SupabaseConfig.isConfigured) {
        SupabaseConfig.client.auth.onAuthStateChange.listen((_) {
          notifyListeners();
        });
      }
    } catch (_) {}
  }

  /// Curated test accounts for development, testing, and demos
  static const List<TestAccount> testAccounts = [
    TestAccount(
      email: 'driver@rideswg.com',
      password: 'RideSwg2026!',
      displayName: 'Alex Mercer',
      role: 'Pro Street Tuner',
      badge: 'PRO',
    ),
    TestAccount(
      email: 'speed@rideswg.com',
      password: 'RideSwg2026!',
      displayName: 'Sarah Jenkins',
      role: 'Track Specialist',
      badge: 'TRACK',
    ),
    TestAccount(
      email: 'drift@rideswg.com',
      password: 'RideSwg2026!',
      displayName: 'Kenji Sato',
      role: 'Drift Master',
      badge: 'DRIFT',
    ),
    TestAccount(
      email: 'demo@rideswg.com',
      password: 'demo1234',
      displayName: 'Demo Driver',
      role: 'VIP Member',
      badge: 'VIP',
    ),
  ];

  TestAccount? _currentDemoUser;
  TestAccount? get currentDemoUser => _currentDemoUser;

  bool get isAuthenticated {
    if (_currentDemoUser != null) return true;
    try {
      if (SupabaseConfig.isConfigured) {
        return SupabaseConfig.client.auth.currentSession != null;
      }
    } catch (_) {}
    return false;
  }

  String get currentUserName {
    if (_currentDemoUser != null) {
      return _currentDemoUser!.displayName;
    }
    try {
      if (SupabaseConfig.isConfigured) {
        final meta = SupabaseConfig.client.auth.currentUser?.userMetadata;
        final name = meta?['display_name'] as String?;
        if (name != null && name.isNotEmpty) return name;
      }
    } catch (_) {}
    return 'Driver';
  }

  String get currentUserEmail {
    if (_currentDemoUser != null) {
      return _currentDemoUser!.email;
    }
    try {
      if (SupabaseConfig.isConfigured) {
        return SupabaseConfig.client.auth.currentUser?.email ?? '';
      }
    } catch (_) {}
    return '';
  }

  String get currentUserRole {
    if (_currentDemoUser != null) {
      return _currentDemoUser!.role;
    }
    return 'Tuner';
  }

  Future<void> signIn({required String email, required String password}) async {
    final cleanEmail = email.trim().toLowerCase();

    // 1. Check for matching test account
    final testAccount = testAccounts.where(
      (a) => a.email.toLowerCase() == cleanEmail && a.password == password,
    ).firstOrNull;

    if (testAccount != null) {
      _currentDemoUser = testAccount;
      notifyListeners();
      return;
    }

    // 2. Check if it is a test account email with wrong password
    final testWithEmail = testAccounts.where(
      (a) => a.email.toLowerCase() == cleanEmail,
    ).firstOrNull;

    if (testWithEmail != null) {
      throw Exception('Incorrect password for ${testWithEmail.email}. Expected: ${testWithEmail.password}');
    }

    // 3. Otherwise use Supabase if configured
    if (SupabaseConfig.isConfigured) {
      await SupabaseConfig.client.auth.signInWithPassword(
        email: cleanEmail,
        password: password,
      );
      _currentDemoUser = null;
      notifyListeners();
    } else {
      throw Exception(
        'Supabase is not configured yet. Use a test account (e.g. demo@rideswg.com / demo1234) or add credentials to supabase_config.dart',
      );
    }
  }

  void loginAsTestAccount(TestAccount account) {
    _currentDemoUser = account;
    notifyListeners();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (SupabaseConfig.isConfigured) {
      await SupabaseConfig.client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'display_name': displayName.trim()},
      );
      _currentDemoUser = null;
      notifyListeners();
    } else {
      // In offline / preview mode, create a local session
      _currentDemoUser = TestAccount(
        email: email.trim(),
        password: password,
        displayName: displayName.trim().isEmpty ? 'Driver' : displayName.trim(),
        role: 'Tuner',
        badge: 'NEW',
      );
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _currentDemoUser = null;
    try {
      if (SupabaseConfig.isConfigured) {
        await SupabaseConfig.client.auth.signOut();
      }
    } catch (_) {}
    notifyListeners();
  }
}
