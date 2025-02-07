import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpInput extends StatelessWidget {
  final List<TextEditingController> controllers;

  const OtpInput({super.key, required this.controllers});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.040; // Responsive font size

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(controllers.length, (index) {
        return SizedBox(
          width: 45,
          child: TextField(
            controller: controllers[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Colors.white, // White background inside
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.transparent), // No border when focused
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.transparent), // No border normally
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.transparent), // No border when disabled
              ),
            ),
            style: GoogleFonts.fredoka(
              textStyle: TextStyle(
                color: Color.fromRGBO(6, 2, 112, 1), // Text color
                fontWeight: FontWeight.w500,
                fontSize: fontSize, // Responsive font size
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Only numbers allowed
            ],
            onChanged: (value) {
              if (value.length == 1 && index < controllers.length - 1) {
                // Move focus to the next field
                FocusScope.of(context).nextFocus();
              } else if (value.isEmpty && index > 0) {
                // Move focus to the previous field on backspace
                FocusScope.of(context).previousFocus();
              }
            },
          ),
        );
      }),
    );
  }
}