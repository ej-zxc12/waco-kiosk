import 'dart:async';
import 'package:flutter/material.dart';
import 'splash_screen.dart'; // for SplashScreen
import 'nav.dart';
import 'home_menu.dart' show cartItems, cartItemCount; // clear cart on timeout

class IdleWrapper extends StatefulWidget {
  final Widget child;
  final Duration idleDuration; // e.g. 1 minute

  const IdleWrapper({
    super.key,
    required this.child,
    this.idleDuration = const Duration(seconds: 60),
  });

  @override
  State<IdleWrapper> createState() => _IdleWrapperState();
}

class _IdleWrapperState extends State<IdleWrapper> {
  Timer? _timer;
  bool _showWarning = false;
  int _countdown = 10;

  void _resetTimer() {
    _timer?.cancel();
    _showWarning = false;
    _countdown = 10;
    _navigated = false;
    if (Nav.idleEnabled.value) {
      _timer = Timer(widget.idleDuration, _onIdle);
    }
  }

  bool _navigated = false;

  void _onIdle() {
    setState(() => _showWarning = true);

    // Countdown before going back
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
        if (!_navigated) {
          _navigated = true;
          // Clear kiosk data before returning home
          cartItems.clear();
          cartItemCount.value = 0;
          if (mounted) {
            setState(() {
              _showWarning = false;
            });
          }
          final nav = Nav.navKey.currentState;
          if (nav != null) {
            nav.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SplashScreen()),
              (route) => false,
            );
          }
        }
      } else {
        setState(() => _countdown--);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onUserActivity([_]) {
    if (_showWarning) {
      setState(() => _showWarning = false);
    }
    _navigated = false;
    _resetTimer();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Nav.idleEnabled,
      builder: (context, enabled, child) {
        if (!enabled) {
          _timer?.cancel();
          _showWarning = false;
          _navigated = false;
          return widget.child;
        }

        return Listener(
          onPointerDown: _onUserActivity,
          child: Stack(
            children: [
              widget.child,
              if (_showWarning)
                Container(
                  color: Colors.black54,
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Colors.orange, size: 60),
                        const SizedBox(height: 12),
                        const Text(
                          "No activity detected",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Returning to Home in $_countdown seconds...",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            _onUserActivity();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B4226),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Continue Order"),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
