import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:parkzo/auth/otpScreen.dart';
import '../screens/homeScreen.dart';
import '../widgets/toast.dart';

class AuthServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static late String _verificationId;

  /// Google Sign-In
  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent closing
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        Navigator.pop(context); // Close loading indicator
        return; // User canceled sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      // ✅ Navigate to Home on success
      Navigator.pop(context); // Close loading indicator
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading indicator
      showToast(context, "Google Sign-In Failed: $e", 2);
    }
  }


  /// Send OTP to Mobile Number
  static Future<void> sendOTP(BuildContext context, String phoneNumber) async {
    if (phoneNumber.isEmpty || phoneNumber.length < 10) {
      showToast(context, "Please enter a valid phone number", 2);
      return;
    }

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ✅ Auto Sign-in
          await _auth.signInWithCredential(credential);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          showToast(context, "OTP Verification Failed: ${e.message}", 2);
        },
        codeSent: (String verId, int? resendToken) {
          _verificationId = verId;
          showToast(context, "OTP Sent to $phoneNumber", 2);

          // ✅ Navigate to OTP Screen & Pass Phone Number
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(phoneNumber: phoneNumber),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verId) {
          _verificationId = verId;
        },
      );
    } catch (e) {
      showToast(context, "Error sending OTP: $e", 2);
    }
  }


  /// Resend OTP (Uses stored verificationId)
  static Future<void> resendOTP(BuildContext context) async {
    if (_verificationId.isEmpty) {
      showToast(context, "Request OTP first!", 2);
      return;
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: "USE_SAVED_PHONE_NUMBER",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        showToast(context, "OTP Resend Failed: ${e.message}", 2);
      },
      codeSent: (String verId, int? resendToken) {
        _verificationId = verId;
        showToast(context, "OTP Resent!", 2);
      },
      codeAutoRetrievalTimeout: (String verId) {
        _verificationId = verId;
      },
    );
  }

  /// Verify OTP
  static Future<void> verifyOTP(BuildContext context, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);

      // ✅ Navigate to Home on success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      showToast(context, "OTP Verification Failed: $e", 2);
    }
  }
}
