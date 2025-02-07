import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for haptic feedback
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/otpInput.dart';
import '../widgets/toast.dart';
import '../widgets/verifyOTPbutton.dart';
import 'authService.dart';


class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final PhoneAuthCredential? autoCredential; // Auto-fill OTP if available

  const OtpVerificationPage({
    Key? key,
    required this.phoneNumber,
    this.autoCredential,
  }) : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _otpControllers =
  List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    if (widget.autoCredential != null) {
      // ✅ Auto-fill OTP when auto sign-in occurs
      String? autoOtp = widget.autoCredential!.smsCode;
      if (autoOtp != null && autoOtp.length == 6) {
        for (int i = 0; i < 6; i++) {
          _otpControllers[i].text = autoOtp[i];
        }
        _verifyAutoOTP(autoOtp);
      }
    }
  }

  /// ✅ Verify OTP and navigate to Home
  void _verifyOTP() {
    String otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      AuthServices.verifyOTP(context, otp);
    } else {
      showToast(context, "Please enter a 6-digit OTP",2);
    }
  }

  /// ✅ Auto verify OTP if auto-filled
  void _verifyAutoOTP(String otp) {
    Future.delayed(const Duration(milliseconds: 500), () {
      AuthServices.verifyOTP(context, otp);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent resizing when keyboard opens
      extendBodyBehindAppBar: true, // Allows background image behind app bar
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.12,
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, weight: 600, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Go back when pressed
        ),
      ),
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
              // OTP Heading
              Positioned(
                top: screenHeight * 0.23,
                left: screenWidth * 0.06,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OTP',
                      style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.0001), // Add some spacing
                    Text(
                      'Verification',
                      style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.07, // Smaller font size
                          fontWeight: FontWeight.w600, // Lighter font weight
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // OTP Input
              Positioned(
                top: screenHeight * 0.37, // Adjusted to create more space
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                child: OtpInput(controllers: _otpControllers),
              ),
              // Verify OTP Button
              Positioned(
                top: screenHeight * 0.45, // Adjusted to create more space
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                child: Column(
                  children: [
                    VerifyOtpButton(
                      onPressed: _verifyOTP,
                    ),
                    SizedBox(height: screenHeight * 0.05), // Space below button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the code? ",
                          style: GoogleFonts.fredoka(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            HapticFeedback.lightImpact(); // Haptic feedback
                            AuthServices.sendOTP(context, widget.phoneNumber);
                          },
                          child: Text(
                            "Resend OTP",
                            style: GoogleFonts.fredoka(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Bottom Text
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
