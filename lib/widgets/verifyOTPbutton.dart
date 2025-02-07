import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for haptic feedback
import 'package:google_fonts/google_fonts.dart';

class VerifyOtpButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double fontSize;
  final double horizontalPadding;
  final double verticalPadding;

  const VerifyOtpButton({
    Key? key,
    required this.onPressed,
    this.fontSize = 0.045,
    this.horizontalPadding = 0.1,
    this.verticalPadding = 0.013,
  }) : super(key: key);

  @override
  State<VerifyOtpButton> createState() => _VerifyOtpButtonState();
}

class _VerifyOtpButtonState extends State<VerifyOtpButton> {
  bool _isPressed = false; // Track button press state

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final dynamicHorizontalPadding = screenWidth * widget.horizontalPadding;
    final dynamicVerticalPadding = screenHeight * widget.verticalPadding;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true); // Shrink animation on press
        HapticFeedback.mediumImpact(); // Haptic feedback
      },
      onTapUp: (_) {
        setState(() => _isPressed = false); // Restore button size
        Future.delayed(const Duration(milliseconds: 100), widget.onPressed); // Delay action slightly
      },
      onTapCancel: () => setState(() => _isPressed = false), // Restore size if tap is canceled
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100), // Smooth animation
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0), // Shrink effect
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(75, 0, 130, 1), // Dark Purple
              Color.fromRGBO(139, 0, 0, 1), // Dark Red
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: dynamicVerticalPadding,
          horizontal: dynamicHorizontalPadding,
        ),
        child: Center(
          child: Text(
            'Verify',
            style: GoogleFonts.fredoka(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * widget.fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
