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

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter phone number',
        hintStyle: GoogleFonts.fredoka(
          textStyle: TextStyle(
            color: Color.fromRGBO(6, 2, 112, 1), // Hint text color
            fontSize: fontSize, // Responsive font size
          ),
        ),

        prefix: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02), // Responsive padding
          child: Text(
            '+91',
            style: GoogleFonts.fredoka(
              textStyle: TextStyle(
                color: Color.fromRGBO(6, 2, 112, 1), // Prefix text color
                fontWeight: FontWeight.w500,
                fontSize: fontSize, // Responsive font size
              ),
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0), // Ensure prefix is always visible
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0), // Circular border radius
        ),
        filled: true,
        fillColor: Colors.white, // White background
        contentPadding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.015, // Responsive vertical padding
          horizontal: screenWidth * 0.04, // Responsive horizontal padding
        ),
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
    );
  }
}