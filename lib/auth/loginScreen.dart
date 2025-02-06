import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/phoneNumberInput.dart';
import '../widgets/sendOtpButton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent resizing when keyboard opens
      body: SingleChildScrollView(
        // Make the page scrollable
        child: Container(
          height: screenHeight, // Ensure the container takes full height
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/images/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Parkzo Text and Subtext
              Positioned(
                top: screenHeight * 0.16,
                left: screenWidth * 0.06,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Parkzo',
                      style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.0001), // Add some spacing
                    Text(
                      'Instant Logs,\nZero Hassle!',
                      style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.05, // Smaller font size
                          fontWeight: FontWeight.w600, // Lighter font weight
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Phone Number Input (Moved down to create space)
              Positioned(
                top: screenHeight * 0.37, // Adjusted to create more space
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                child: PhoneNumberInput(controller: _phoneController),
              ),
              // Send OTP Button (Moved down accordingly)
              Positioned(
                top: screenHeight * 0.45, // Adjusted to create more space
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                child: SendOtpButton(
                  onPressed: () {
                    // Handle OTP sending logic here
                  },
                ),
              ),
              // OR Divider (Moved down accordingly)
              Positioned(
                top: screenHeight * 0.59, // Adjusted to create more space
                left: screenWidth * 0.2,
                right: screenWidth * 0.2,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 0.3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'OR',
                            style: GoogleFonts.fredoka(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Google Logo (Moved down accordingly)
              Positioned(
                top: screenHeight * 0.68, // Adjusted to create more space
                left: screenWidth * 0.35,
                right: screenWidth * 0.35,
                child: Image.asset(
                  'lib/assets/images/google.png',
                  width: screenWidth * 0.15,
                  height: screenWidth * 0.15,
                ),
              ),
              // Bottom Text (No changes needed)
              Positioned(
                bottom: screenHeight * 0.05,
                left: screenWidth * 0.1,
                right: screenWidth * 0.1,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.fredoka(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.033,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    children: const <TextSpan>[
                      TextSpan(text: 'By continuing, you agree to our\n'),
                      TextSpan(
                        text: 'Terms of Use',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' & '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}