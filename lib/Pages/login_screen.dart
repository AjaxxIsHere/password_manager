import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pixelarticons/pixel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';
  bool _hasBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool hasBiometrics;
    try {
      hasBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      hasBiometrics = false;
    }
    setState(() {
      _hasBiometrics = hasBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });

      if (_hasBiometrics) {
        authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to access your passwords',
          options: const AuthenticationOptions(
            biometricOnly: true,
          ),
        );
      } else {
        // Fallback to phone's password if biometrics are not available
        authenticated = await auth.authenticate(
          localizedReason:
              'Please use your phone password to access your passwords',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
      }

      setState(() {
        _isAuthenticating = false;
        _authorized = authenticated ? 'Authorized' : 'Not Authorized';
      });

      if (animatedIcon) {
        // Check if authentication was successful
        animatedIcon = false; // Reset animation flag
      } else {
        animatedIcon = true; // Start animation on successful authentication
      }

      if (authenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error: $e';
      });
      return;
    }
  }

  bool animatedIcon = false; // Flag to control lock to checkmark animation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Lock icon with animation
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: _isAuthenticating
                  ? const CircularProgressIndicator(
                      color: Colors.green,
                    )
                  : _authorized == 'Authorized'
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 100,
                        )
                      : const Icon(
                          Pixel.lock,
                          color: Colors.green,
                          size: 100,
                        ),
            ),
            const SizedBox(height: 30),
            const Text(
              'LockBox', // App name
              style: TextStyle(
                color: Colors.green,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _authenticate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Set button color to green
                  ),
                  child: Text(
                    _hasBiometrics
                        ? 'Login with Fingerprint'
                        : 'Login with Password',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Status: $_authorized',
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
