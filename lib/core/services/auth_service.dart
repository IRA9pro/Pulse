import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // Stream of session changes for the app gatekeeper
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Get current session
  Session? get currentSession => _client.auth.currentSession;

  // Sign in with Email and Password
  Future<void> signIn(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  // --- SIGN UP FLOW ---
  // Step 1: Send OTP to email
  Future<void> sendOtp(String email) async {
    await _client.auth.signInWithOtp(
      email: email,
      shouldCreateUser: true,
    );
  }

  // Step 2: Verify OTP
  Future<AuthResponse> verifyOtp(String email, String token) async {
    return await _client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.email,
    );
  }

  // --- PASSWORD RECOVERY FLOW ---
  // Step 1: Send Reset OTP
  Future<void> sendResetOtp(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  // Step 2: Verify Recovery OTP
  Future<AuthResponse> verifyRecoveryOtp(String email, String token) async {
    return await _client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.recovery,
    );
  }

  // --- COMMON ---
  // Update password for the currently authenticated user
  Future<void> setPassword(String password) async {
    await _client.auth.updateUser(
      UserAttributes(password: password),
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
