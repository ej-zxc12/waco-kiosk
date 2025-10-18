import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart'; // for SplashScreen

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
    _timer = Timer(widget.idleDuration, _onIdle);
  }

  void _onIdle() {
    setState(() => _showWarning = true);

    // Countdown before going back
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
            (route) => false,
          );
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
    _resetTimer();
  }

  @override
  Widget build(BuildContext context) {
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
  }
}
