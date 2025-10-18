import 'package:flutter/material.dart';
import 'home_menu.dart' show cartItems, cartItemCount;
import 'splash_screen.dart';
import 'nav.dart';

/// 🔹 Cancel Confirmation Dialog
Future<void> showCancelConfirmation(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: const Color(0xFFF5E6D3),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Do you want to cancel your order?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// ❌ NO
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "No",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  /// ✅ YES
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B4226),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                    ),
                    onPressed: () {
                      // Clear all kiosk state
                      cartItems.clear();
                      cartItemCount.value = 0;

                      // Close dialog
                      Navigator.of(context).pop();

                      // Navigate back to Splash using root navigator
                      final nav = Nav.navKey.currentState;
                      if (nav != null) {
                        nav.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const SplashScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: const Text(
                      "Yes",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// 🔹 Animated Scale Button (for product cards)
class AnimatedScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const AnimatedScaleButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<AnimatedScaleButton> createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// 🔹 Animated Button (for actions like Place/Cancel Order)
class AnimatedButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const AnimatedButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.97);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 🔹 Expandable Section Widget (for MilkTea, Coffee, etc.)
class ExpandableSection extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> options;
  final bool multiSelect;

  /// ✅ Updated: Pass both total and items
  final Function(int total, List<Map<String, dynamic>> items)? onTotalChanged;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.options,
    this.multiSelect = false,
    this.onTotalChanged,
  });

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  bool _expanded = false;

  /// Track quantities for each option
  late List<int> _quantities;

  @override
  void initState() {
    super.initState();
    _quantities = List.generate(widget.options.length, (_) => 0);
  }

  /// Compute total dynamically
  int get totalPrice {
    int total = 0;
    for (int i = 0; i < widget.options.length; i++) {
      total += _quantities[i] * (widget.options[i]['price'] as int);
    }
    return total;
  }

  /// Get selected items with quantities
  List<Map<String, dynamic>> get selectedItems {
    List<Map<String, dynamic>> items = [];
    for (int i = 0; i < widget.options.length; i++) {
      if (_quantities[i] > 0) {
        items.add({
          "label": widget.options[i]['label'],
          "price": widget.options[i]['price'],
          "qty": _quantities[i],
        });
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                _expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                size: 28,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        /// EXPANDED OPTIONS
        if (_expanded) _buildExpandedOptions(),

        /// TOTAL PRICE (only show if something selected)
        if (_expanded && totalPrice > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 4),
            child: Text(
              "Total: ₱$totalPrice",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  /// Expanded Option List
  Widget _buildExpandedOptions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          for (int i = 0; i < widget.options.length; i++)
            ListTile(
              title: Text(
                "${widget.options[i]['label']} - ₱${widget.options[i]['price']}",
                style: const TextStyle(fontSize: 16),
              ),
              trailing: _buildQuantityControls(i),
            ),
        ],
      ),
    );
  }

  /// Quantity Controls
  Widget _buildQuantityControls(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              if (_quantities[index] > 0) _quantities[index]--;
            });
            if (widget.onTotalChanged != null) {
              widget.onTotalChanged!(totalPrice, selectedItems);
            }
          },
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(
          _quantities[index] == 0 ? "" : "${_quantities[index]}",
          style: const TextStyle(fontSize: 18),
        ),
        IconButton(
          onPressed: () {
            setState(() => _quantities[index]++);
            if (widget.onTotalChanged != null) {
              widget.onTotalChanged!(totalPrice, selectedItems);
            }
          },
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
