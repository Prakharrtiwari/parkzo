import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:google_fonts/google_fonts.dart';

// Assuming AppColors is defined elsewhere, reusing it
class AppColors {
  static const darkBlue = Color(0xFF180440);
  static const lightVioletBlue = Color(0xFF311b83);
  static const white = Colors.white;
  static const grey = Color(0xFF757575);
  static const accent = Color(0xFF00C4B4);
  static const glassWhite = Color(0x22FFFFFF);
}

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with SingleTickerProviderStateMixin {
  CameraController? _controller;
  bool _isDetecting = false;
  String _plateNumber = 'No plate detected';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    initializeCamera();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere((cam) => cam.lensDirection == CameraLensDirection.back);

      _controller = CameraController(backCamera, ResolutionPreset.medium);
      await _controller?.initialize();

      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print("Camera Initialization Error: $e");
    }
  }

  Future<void> captureAndScan() async {
    if (_isDetecting || _controller == null || !_controller!.value.isInitialized) return;

    setState(() => _isDetecting = true);

    try {
      final tempDir = await getTemporaryDirectory();
      final imagePath = path.join(tempDir.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');

      await _controller!.takePicture().then((XFile file) async {
        final File imageFile = File(file.path);
        final plate = await scanPlate(imageFile);
        setState(() => _plateNumber = plate);
      });
    } catch (e) {
      print("Capture Error: $e");
      setState(() => _plateNumber = 'Error capturing image');
    }

    await Future.delayed(const Duration(seconds: 3));
    setState(() => _isDetecting = false);
  }

  Future<String> scanPlate(File imageFile) async {
    try {
      final uri = Uri.parse('https://api.platerecognizer.com/v1/plate-reader/');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Token c966e7027f05bc0c2617c1c668a243d1d58869e0'
        ..files.add(await http.MultipartFile.fromPath('upload', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final respStr = await response.stream.bytesToString();
        final data = json.decode(respStr);
        final plate = data['results'].isNotEmpty
            ? data['results'][0]['plate'].toUpperCase()
            : 'No plate detected';
        return plate;
      } else {
        final respStr = await response.stream.bytesToString();
        print("API response: $respStr");
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      print("Scan Plate Error: $e");
      return 'Error processing image';
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full-screen camera preview
          if (_controller?.value.isInitialized ?? false)
            SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: CameraPreview(_controller!),
            )
          else
            Container(
              width: screenWidth,
              height: screenHeight,
              color: Colors.black,
              child: const Center(child: CircularProgressIndicator(color: AppColors.accent)),
            ),
          // Top gradient overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.25,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.darkBlue.withOpacity(0.9),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.glassWhite,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: AppColors.white,
                            size: screenWidth * 0.06,
                          ),
                        ),
                      ),
                      Text(
                        'Scan Number Plate',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.glassWhite,
                        ),
                        child: Icon(
                          Icons.flash_off,
                          color: AppColors.white,
                          size: screenWidth * 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bottom overlay with scan button and plate display
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.darkBlue.withOpacity(0.9),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_car,
                            color: AppColors.darkBlue,
                            size: screenWidth * 0.06,
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            _plateNumber,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    GestureDetector(
                      onTap: _isDetecting ? null : captureAndScan,
                      child: Container(
                        width: screenWidth * 0.18,
                        height: screenWidth * 0.18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.darkBlue,
                              AppColors.lightVioletBlue,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _isDetecting
                            ? CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 3,
                        )
                            : Icon(
                          Icons.camera,
                          color: AppColors.white,
                          size: screenWidth * 0.08,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ),
          // Scanning frame overlay
          Center(
            child: Container(
              width: screenWidth * 0.7,
              height: screenWidth * 0.4,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accent, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}