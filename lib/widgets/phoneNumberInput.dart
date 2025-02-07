import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;

  const PhoneNumberInput({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive font size
    final fontSize = screenWidth * 0.040; // Adjust multiplier as needed

    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the container
        borderRadius: BorderRadius.circular(30), // Border radius of 30
      ),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.001, // Add some vertical padding
        horizontal: screenWidth * 0.05, // Add some horizontal padding
      ),
      child: Row(
        children: [
          // Fixed +91 prefix
          Text(
            '+91',
            style: GoogleFonts.fredoka(
              textStyle: TextStyle(
                color: Color.fromRGBO(6, 2, 112, 1), // Prefix text color
                fontWeight: FontWeight.w500,
                fontSize: fontSize, // Responsive font size
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.02), // Add some spacing between prefix and TextField
          // TextField for phone number input
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                hintStyle: GoogleFonts.fredoka(
                  textStyle: TextStyle(
                    color: Color.fromRGBO(6, 2, 112, 1), // Hint text color
                    fontSize: fontSize, // Responsive font size
                  ),
                ),
                filled: true,
                fillColor: Colors.transparent, // Make the TextField background transparent
                contentPadding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.015, // Responsive vertical padding
                ),
                // Remove borders
                enabledBorder: InputBorder.none, // No border when enabled
                focusedBorder: InputBorder.none, // No border when focused
                errorBorder: InputBorder.none, // No border when in error state
                disabledBorder: InputBorder.none, // No border when disabled
                border: InputBorder.none, // Default border (fallback)
              ),
              style: GoogleFonts.fredoka(
                textStyle: TextStyle(
                  color: Color.fromRGBO(6, 2, 112, 1), // Input text color
                  fontSize: fontSize, // Responsive font size
                ),
              ),
              keyboardType: TextInputType.phone, // Numeric keyboard
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Only numbers allowed
                LengthLimitingTextInputFormatter(10), // Max 10 characters
              ],
              onChanged: (value) {
                if (value.length == 10) {
                  // Dismiss the keyboard when 10 characters are entered
                  FocusScope.of(context).unfocus();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}