import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/services/auth_provider.dart';
import '../../core/theme/pulse_theme.dart';
import '../../core/widgets/pulse_button.dart';

enum AuthStep { email, otp, password }
enum AuthMode { login, signup, recovery }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  
  AuthStep _currentStep = AuthStep.email;
  AuthMode _authMode = AuthMode.login;
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _handleAuth() async {
    final auth = ref.read(authServiceProvider);
    
    // LOGIN MODE
    if (_authMode == AuthMode.login) {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        _showError("Please fill in all fields");
        return;
      }
      setState(() => _isLoading = true);
      try {
        await auth.signIn(_emailController.text.trim(), _passwordController.text.trim());
      } on AuthException catch (e) {
        if (e.message.toLowerCase().contains("invalid login credentials")) {
          _showError("Email or password is incorrect");
        } else {
          _showError(e.message);
        }
      } catch (e) {
        _showError("An unexpected error occurred. Please try again.");
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
      return;
    }

    // MULTI-STEP FLOW (SIGNUP & RECOVERY)
    switch (_currentStep) {
      case AuthStep.email:
        if (_emailController.text.isEmpty) {
          _showError("Please enter your email");
          return;
        }
        setState(() => _isLoading = true);
        try {
          // Set registration flag to true to prevent auto-routing in main.dart
          ref.read(registrationInProgressProvider.notifier).state = true;
          
          if (_authMode == AuthMode.signup) {
            await auth.sendOtp(_emailController.text.trim());
          } else {
            await auth.sendResetOtp(_emailController.text.trim());
          }
          setState(() => _currentStep = AuthStep.otp);
          _showSuccess("A 6-digit code has been sent to your email!");
        } on AuthException catch (e) {
          _showError(e.message);
        } catch (e) {
          _showError("Could not send code. Try again.");
        } finally {
          if (mounted) setState(() => _isLoading = false);
        }
        break;

      case AuthStep.otp:
        if (_otpController.text.length != 6) {
          _showError("Please enter the 6-digit code");
          return;
        }
        setState(() => _isLoading = true);
        try {
          if (_authMode == AuthMode.signup) {
            await auth.verifyOtp(_emailController.text.trim(), _otpController.text.trim());
          } else {
            await auth.verifyRecoveryOtp(_emailController.text.trim(), _otpController.text.trim());
          }
          setState(() => _currentStep = AuthStep.password);
          _showSuccess("Email verified! Now set your password.");
        } on AuthException catch (e) {
          _showError(e.message);
        } catch (e) {
          _showError("Invalid or expired code");
        } finally {
          if (mounted) setState(() => _isLoading = false);
        }
        break;

      case AuthStep.password:
        if (_passwordController.text.length < 6) {
          _showError("Password must be at least 6 characters");
          return;
        }
        setState(() => _isLoading = true);
        try {
          await auth.setPassword(_passwordController.text.trim());
          
          // Clear registration flag - main.dart will now move to HomeScreen
          ref.read(registrationInProgressProvider.notifier).state = false;
          
          _showSuccess(_authMode == AuthMode.signup ? "Account secured! Welcome to Pulse." : "Password reset successful!");
          
          if (_authMode == AuthMode.recovery) {
             setState(() {
               _authMode = AuthMode.login;
               _currentStep = AuthStep.email;
               _passwordController.clear();
               _otpController.clear();
             });
          }
        } on AuthException catch (e) {
          _showError(e.message);
        } catch (e) {
          _showError("Failed to set password. Try again.");
        } finally {
          if (mounted) setState(() => _isLoading = false);
        }
        break;
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.black)),
        backgroundColor: PulseTheme.neonCyan,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("PULSE", style: textTheme.displayLarge, textAlign: TextAlign.center),
                Text(
                  _getStepTitle(),
                  style: textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 64),
                
                _buildFormFields(),
                
                const SizedBox(height: 32),
                PulseButton(
                  label: _getButtonLabel(),
                  isLoading: _isLoading,
                  onPressed: _handleAuth,
                ),
                
                const SizedBox(height: 16),
                _buildNavigationLinks(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getStepTitle() {
    if (_authMode == AuthMode.login) return "FEEL THE BEAT OF YOUR LIFE";
    
    switch (_currentStep) {
      case AuthStep.email: 
        return _authMode == AuthMode.signup ? "START YOUR NEW HEARTBEAT" : "RECOVER YOUR BEAT";
      case AuthStep.otp: 
        return "CONFIRM YOUR BEAT";
      case AuthStep.password: 
        return _authMode == AuthMode.signup ? "SECURE YOUR BEAT" : "RESET YOUR BEAT";
    }
  }

  String _getButtonLabel() {
    if (_authMode == AuthMode.login) return "SIGN IN";
    
    switch (_currentStep) {
      case AuthStep.email: return "SEND CODE";
      case AuthStep.otp: return "VERIFY CODE";
      case AuthStep.password: 
        return _authMode == AuthMode.signup ? "COMPLETE REGISTRATION" : "UPDATE PASSWORD";
    }
  }

  Widget _buildFormFields() {
    if (_authMode == AuthMode.login) {
      return Column(
        children: [
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: "EMAIL", prefixIcon: Icon(Icons.alternate_email)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: "PASSWORD", 
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                color: Colors.grey,
              ),
            ),
          ),
        ],
      );
    }

    switch (_currentStep) {
      case AuthStep.email:
        return TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: "EMAIL", prefixIcon: Icon(Icons.alternate_email)),
        );
      case AuthStep.otp:
        return Column(
          children: [
            Text(
              "WE SENT A CODE TO\n${_emailController.text.toUpperCase()}",
              style: const TextStyle(fontSize: 10, letterSpacing: 1, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
              decoration: const InputDecoration(labelText: "6-DIGIT CODE", counterText: "", prefixIcon: Icon(Icons.security)),
            ),
          ],
        );
      case AuthStep.password:
        return TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: _authMode == AuthMode.signup ? "SET PASSWORD" : "NEW PASSWORD",
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                color: Colors.grey,
              ),
          ),
        );
    }
  }

  Widget _buildNavigationLinks() {
    if (_authMode == AuthMode.login) {
      return Column(
        children: [
          TextButton(
            onPressed: () => setState(() {
              _authMode = AuthMode.signup;
              _currentStep = AuthStep.email;
              _emailController.clear();
              _passwordController.clear();
            }),
            child: const Text(
              "NEW TO PULSE? JOIN NOW",
              style: TextStyle(color: PulseTheme.neonCyan, fontSize: 11, letterSpacing: 1, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () => setState(() {
              _authMode = AuthMode.recovery;
              _currentStep = AuthStep.email;
              _emailController.clear();
              _passwordController.clear();
            }),
            child: const Text(
              "FORGOT PASSWORD?",
              style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1),
            ),
          ),
        ],
      );
    }

    return TextButton(
      onPressed: () {
        setState(() {
          _authMode = AuthMode.login;
          _currentStep = AuthStep.email;
          _otpController.clear();
          _emailController.clear();
          _passwordController.clear();
          ref.read(registrationInProgressProvider.notifier).state = false;
        });
      },
      child: const Text(
        "ALREADY HAVE AN ACCOUNT? SIGN IN",
        style: TextStyle(color: PulseTheme.neonCyan, fontSize: 11, letterSpacing: 1, fontWeight: FontWeight.bold),
      ),
    );
  }
}
