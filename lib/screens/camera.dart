import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:google_fonts/google_fonts.dart';

// AppColors class
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

class _ScanPageState extends State<ScanPage> with TickerProviderStateMixin {
  CameraController? _controller;
  bool _isDetecting = false;
  bool _isFlashOn = false;
  String _plateNumber = 'No plate detected';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
            (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        backCamera,
        ResolutionPreset.low,
        enableAudio: false,
      );

      await _controller?.initialize();
      if (!mounted) return;

      await _controller?.setFlashMode(FlashMode.off);
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera initialization failed: $e')),
        );
      }
      Future.delayed(const Duration(seconds: 2), _initializeCamera);
    }
  }

  Future<void> _captureAndScan() async {
    if (_isDetecting ||
        _controller == null ||
        !_controller!.value.isInitialized) return;

    if (_debounceTimer?.isActive ?? false) return;
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {});

    setState(() => _isDetecting = true);

    try {
      final tempDir = await getTemporaryDirectory();
      final imagePath =
      path.join(tempDir.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');

      final XFile file = await _controller!.takePicture();
      final File imageFile = File(file.path);

      final plate = await _scanPlate(imageFile);
      setState(() => _plateNumber = plate);

      // Show dialog if plate is detected successfully
      if (plate != 'No plate detected' && !plate.startsWith('Error')) {
        if (mounted) {
          await showDialog(
            context: context,
            builder: (context) => PlateDetailsDialog(plateNumber: plate),
          );
        }
      }

      try {
        await imageFile.delete();
      } catch (e) {
        print('Error deleting temp file: $e');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error capturing image: $e')),
        );
      }
      setState(() => _plateNumber = 'Error capturing image');
    }

    setState(() => _isDetecting = false);
  }

  Future<String> _scanPlate(File imageFile) async {
    try {
      final uri = Uri.parse('https://api.platerecognizer.com/v1/plate-reader/');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] =
            'Token c966e7027f05bc0c2617c1c668a243d1d58869e0'
        ..files.add(await http.MultipartFile.fromPath('upload', imageFile.path));

      final response = await request.send().timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final respStr = await response.stream.bytesToString();
        final data = json.decode(respStr);
        final plate = data['results'].isNotEmpty
            ? data['results'][0]['plate'].toUpperCase()
            : 'No plate detected';
        return plate;
      } else {
        final respStr = await response.stream.bytesToString();
        print('API response: $respStr');
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      print('Scan Plate Error: $e');
      return 'Error processing image';
    }
  }

  Future<void> _toggleFlashlight() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
      await _controller!.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error toggling flashlight: $e')),
        );
      }
      setState(() => _isFlashOn = false);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
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
              child: const Center(
                  child: CircularProgressIndicator(color: AppColors.accent)),
            ),
          // Custom scanner square overlay
          Center(
            child: CustomScannerOverlay(
              width: screenWidth * 0.7,
              height: screenWidth * 0.7,
            ),
          ),
          // Top gradient overlay with back button and title
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.15,
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
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'License Plate Scanner',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: AppColors.white,
                    ),
                    onPressed: _toggleFlashlight,
                  ),
                ],
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
                    GestureDetector(
                      onTap: _isDetecting ? null : _captureAndScan,
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
                            ? SizedBox(
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                            strokeWidth: 3,
                          ),
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
        ],
      ),
    );
  }
}

// Dialog widget to display plate details and collect user input
class PlateDetailsDialog extends StatefulWidget {
  final String plateNumber;

  const PlateDetailsDialog({super.key, required this.plateNumber});

  @override
  State<PlateDetailsDialog> createState() => _PlateDetailsDialogState();
}

class _PlateDetailsDialogState extends State<PlateDetailsDialog>
    with SingleTickerProviderStateMixin {
  String _entryType = 'In'; // Default value for In/Out
  String _vehicleType = 'Residential'; // Default value for Residential/Visitor
  late AnimationController _dialogAnimationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _dialogAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _dialogAnimationController,
        curve: Curves.easeInOutCubic,
      ),
    );
    _dialogAnimationController.forward();
  }

  @override
  void dispose() {
    _dialogAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final currentDateTime = DateTime.now();
    final formattedDateTime =
        '${currentDateTime.day}/${currentDateTime.month}/${currentDateTime.year} ${currentDateTime.hour}:${currentDateTime.minute.toString().padLeft(2, '0')}';

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.05), // Reduced padding
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.zero), // Sharp rectangular shape
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // License Plate Number
                _buildInfoRow(
                  context,
                  label: 'License Plate',
                  value: widget.plateNumber,
                  icon: Icons.directions_car,
                ),
                SizedBox(height: screenWidth * 0.04), // Reduced spacing
                // Date and Time
                _buildInfoRow(
                  context,
                  label: 'Date & Time',
                  value: formattedDateTime,
                  icon: Icons.calendar_today,
                ),
                SizedBox(height: screenWidth * 0.04), // Reduced spacing
                // Divider
                Divider(
                  color: AppColors.grey.withOpacity(0.3),
                  thickness: 1,
                  height: 1,
                ),
                SizedBox(height: screenWidth * 0.06), // Reduced spacing
                // In or Out Dropdown
                Text(
                  'Entry Type',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035, // Reduced font size
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlue,
                  ),
                ),
                SizedBox(height: screenWidth * 0.02), // Reduced spacing
                InputDecorator(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03, // Reduced padding
                      vertical: screenWidth * 0.015, // Reduced padding
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.grey.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.accent,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _entryType,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.accent,
                        size: screenWidth * 0.05, // Reduced icon size
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035, // Reduced font size
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.w600,
                      ),
                      items: ['In', 'Out'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.015), // Reduced padding
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _entryType = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.06), // Reduced spacing
                // Residential or Visitor Dropdown
                Text(
                  'Vehicle Type',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035, // Reduced font size
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlue,
                  ),
                ),
                SizedBox(height: screenWidth * 0.02), // Reduced spacing
                InputDecorator(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03, // Reduced padding
                      vertical: screenWidth * 0.015, // Reduced padding
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.grey.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.accent,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _vehicleType,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.accent,
                        size: screenWidth * 0.05, // Reduced icon size
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035, // Reduced font size
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.w600,
                      ),
                      items: ['Residential', 'Visitor'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.015), // Reduced padding
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _vehicleType = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.08), // Reduced spacing
                // Submit Button
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.darkBlue,
                                  AppColors.lightVioletBlue,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03, // Reduced padding
                              vertical: screenWidth * 0.02, // Reduced padding
                            ),
                            child: Text(
                              'Record Saved Successfully',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035, // Reduced font size
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.1,
                            vertical: screenHeight * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'OK',
                            textColor: AppColors.accent,
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.identity()..scale(1.0),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08, // Reduced padding
                        vertical: screenWidth * 0.035, // Reduced padding
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.darkBlue,
                            AppColors.lightVioletBlue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text(
                        'Submit Record',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04, // Reduced font size
                          fontWeight: FontWeight.w900,
                          color: AppColors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, {
        required String label,
        required String value,
        required IconData icon,
      }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.015), // Reduced padding
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.accent,
                AppColors.accent.withOpacity(0.7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: screenWidth * 0.06, // Reduced icon size
          ),
        ),
        SizedBox(width: screenWidth * 0.03), // Reduced spacing
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035, // Reduced font size
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.042, // Reduced font size
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomScannerOverlay extends StatelessWidget {
  final double width;
  final double height;

  const CustomScannerOverlay({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    const double cornerLength = 20.0;
    const double cornerThickness = 4.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Scanner square
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.white.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // Top-left corner
        Positioned(
          top: (MediaQuery.of(context).size.height - height) / 2 -
              cornerThickness / 2,
          left: (MediaQuery.of(context).size.width - width) / 2 -
              cornerThickness / 2,
          child: CustomPaint(
            size: const Size(cornerLength, cornerLength),
            painter: CornerPainter(),
          ),
        ),
        // Top-right corner
        Positioned(
          top: (MediaQuery.of(context).size.height - height) / 2 -
              cornerThickness / 2,
          left: (MediaQuery.of(context).size.width + width) / 2 -
              cornerLength +
              cornerThickness / 2,
          child: CustomPaint(
            size: const Size(cornerLength, cornerLength),
            painter: CornerPainter(),
          ),
        ),
        // Bottom-left corner
        Positioned(
          top: (MediaQuery.of(context).size.height + height) / 2 -
              cornerLength +
              cornerThickness / 2,
          left: (MediaQuery.of(context).size.width - width) / 2 -
              cornerThickness / 2,
          child: CustomPaint(
            size: const Size(cornerLength, cornerLength),
            painter: CornerPainter(),
          ),
        ),
        // Bottom-right corner
        Positioned(
          top: (MediaQuery.of(context).size.height + height) / 2 -
              cornerLength +
              cornerThickness / 2,
          left: (MediaQuery.of(context).size.width + width) / 2 -
              cornerLength +
              cornerThickness / 2,
          child: CustomPaint(
            size: const Size(cornerLength, cornerLength),
            painter: CornerPainter(),
          ),
        ),
      ],
    );
  }
}

class CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    // Draw L-shaped corner
    canvas.drawLine(
      const Offset(0, 0),
      Offset(0, size.height / 2),
      paint,
    );
    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width / 2, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}