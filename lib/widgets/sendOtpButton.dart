import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SendOtpButton extends StatelessWidget {
  final VoidCallback onPressed; // Callback for button press
  final double fontSize; // Optional custom font size
  final double horizontalPadding; // Optional custom horizontal padding
  final double verticalPadding; // Optional custom vertical padding

  const SendOtpButton({
    Key? key,
    required this.onPressed,
    this.fontSize = 0.045, // Default responsive font size multiplier
    this.horizontalPadding = 0.1, // Default responsive horizontal padding multiplier
    this.verticalPadding = 0.013, // Default responsive vertical padding multiplier
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate dynamic padding values
    final dynamicHorizontalPadding = screenWidth * horizontalPadding;
    final dynamicVerticalPadding = screenHeight * verticalPadding;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30.0), // Circular border radius
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0), // Circular border radius
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(75, 0, 130, 1), // Dark Purple
              Color.fromRGBO(139, 0, 0, 1), // Dark Red
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: dynamicVerticalPadding, // Responsive vertical padding
          horizontal: dynamicHorizontalPadding, // Responsive horizontal padding
        ),
        child: Center(
          child: Text(
            'Send OTP',
            style: GoogleFonts.fredoka(
              textStyle: TextStyle(
                color: Colors.white, // Text color
                fontSize: screenWidth * fontSize, // Responsive font size
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
