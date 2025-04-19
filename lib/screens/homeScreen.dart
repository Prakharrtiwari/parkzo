import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile.dart';
import 'alerts.dart';
import 'camera.dart';
import 'history.dart';

// Custom colors
class AppColors {
  static const darkBlue = Color(0xFF180440);
  static const lightVioletBlue = Color(0xFF311b83);
  static const darkBlueAccent = Color(0xFF242c6c);
  static const white = Colors.white;
  static const grey = Color(0xFF757575);
  static const accent = Color(0xFF00C4B4);
  static const divider = Color(0xFFE0E0E0);
  static const lightGreen = Color(0xFFA5D6A7);
  static const lightYellow = Color(0xFFFFF59D);
  static const softOrange = Color(0xFFFFB74D);
  static const pastelPurple = Color(0xFFB39DDB);
  static const glassWhite = Color(0x22FFFFFF);
}

// New stateless widget for HomeContent's body
class HomeContentBody extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final AnimationController animationController;

  const HomeContentBody({
    super.key,
    required this.fadeAnimation,
    required this.animationController,
  });

  final List<Map<String, String>> vehicleEntries = const [
    {
      'vehicleNo': 'DL 1C 1234',
      'time': '2025-04-18 09:00',
      'driver': 'Ravi Kumar'
    },
    {
      'vehicleNo': 'UP 16 5678',
      'time': '2025-04-18 08:45',
      'driver': 'Amit Singh'
    },
    {
      'vehicleNo': 'HR 26 9012',
      'time': '2025-04-18 08:30',
      'driver': 'Suresh Yadav'
    },
    {
      'vehicleNo': 'RJ 14 3456',
      'time': '2025-04-18 08:15',
      'driver': 'Vikram Sharma'
    },
    {
      'vehicleNo': 'MH 04 7890',
      'time': '2025-04-18 08:00',
      'driver': 'Rahul Patil'
    },
  ];

  final List<Map<String, dynamic>> recentActivities = const [
    {
      'description': 'Vehicle DL 1C 1234 entered',
      'time': '2 mins ago',
      'icon': Icons.directions_car,
      'color': AppColors.lightGreen,
    },
    {
      'description': 'Vehicle UP 16 5678 scanned',
      'time': '5 mins ago',
      'icon': Icons.camera_alt,
      'color': AppColors.lightYellow,
    },
    {
      'description': 'Vehicle HR 26 9012 exited',
      'time': '10 mins ago',
      'icon': Icons.exit_to_app,
      'color': AppColors.softOrange,
    },
    {
      'description': 'Vehicle RJ 14 3456 added',
      'time': '15 mins ago',
      'icon': Icons.add,
      'color': AppColors.pastelPurple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.12),
        child: Container(
          width: screenWidth,
          height: screenHeight * 0.20,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 6),
                blurRadius: 10,
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.darkBlue,
                AppColors.lightVioletBlue,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: -screenWidth * 0.3,
                top: -screenHeight * 0.1,
                child: Container(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.3,
                  decoration: BoxDecoration(
                    color: AppColors.glassWhite,
                    borderRadius: BorderRadius.all(Radius.elliptical(300, 200)),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                ),
              ),
              Positioned(
                left: screenWidth * 0.06,
                top: screenHeight * 0.08,
                child: Row(
                  children: [
                    Container(
                      width: screenWidth * 0.12,
                      height: screenWidth * 0.12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.directions_car,
                        color: AppColors.darkBlue,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Text(
                      'Parkzo',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                right: screenWidth * 0.06,
                top: screenHeight * 0.08,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()),
                    );
                  },
                  child: Container(
                    width: screenWidth * 0.12,
                    height: screenWidth * 0.12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(Icons.person,
                        color: AppColors.darkBlue, size: 28),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              _buildQuickStats(context, screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.035),
              _buildOptionCard(
                context,
                screenWidth,
                screenHeight,
                title: 'Manage Entries', // Fixed: Correct named parameter
                subtitle: 'Sync vehicle entries into the record',
                icon: Icons.edit_note,
                gradientColors: [
                  AppColors.darkBlue,
                  Color.lerp(AppColors.lightVioletBlue, AppColors.accent, 0.2)!,
                ],
                onTap: () {},
              ),
              SizedBox(height: screenHeight * 0.03),
              _buildOptionCard(
                context,
                screenWidth,
                screenHeight,
                title: 'Select default options',
                subtitle: 'Select In/Out or Residential/Visitor',
                icon: Icons.local_parking,
                gradientColors: [
                  AppColors.lightVioletBlue,
                  Color.lerp(AppColors.darkBlue, AppColors.glassWhite, 0.3)!,
                ],
                onTap: () {},
              ),
              SizedBox(height: screenHeight * 0.03),
              _buildOptionCard(
                context,
                screenWidth,
                screenHeight,
                title: 'Completed Entries',
                subtitle: 'View or export completed entries',
                icon: Icons.check_circle,
                gradientColors: [
                  AppColors.darkBlue,
                  Color.lerp(AppColors.lightVioletBlue, AppColors.accent, 0.3)!,
                ],
                onTap: () {},
              ),
              SizedBox(height: screenHeight * 0.035),
              _buildRecentActivity(context, screenWidth, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(
      BuildContext context, double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today’s Overview',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.w700,
            color: AppColors.darkBlue,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Container(
          padding: EdgeInsets.all(screenWidth * 0.045),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                context,
                screenWidth,
                screenHeight,
                label: 'Total Entries',
                value: '45',
                icon: Icons.directions_car,
                color: AppColors.darkBlue,
              ),
              _buildStatItem(
                context,
                screenWidth,
                screenHeight,
                label: 'Pending',
                value: '8',
                icon: Icons.hourglass_empty,
                color: AppColors.lightVioletBlue,
              ),
              _buildStatItem(
                context,
                screenWidth,
                screenHeight,
                label: 'Completed',
                value: '37',
                icon: Icons.check_circle,
                color: AppColors.accent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
      BuildContext context,
      double screenWidth,
      double screenHeight, {
        required String label,
        required String value,
        required IconData icon,
        required Color color,
      }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label tapped')),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.1),
                ),
                child: Icon(
                  icon,
                  size: screenWidth * 0.07,
                  color: color,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkBlue,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
      BuildContext context,
      double screenWidth,
      double screenHeight, {
        required String title,
        required String subtitle,
        required IconData icon,
        required List<Color> gradientColors,
        required VoidCallback onTap,
      }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 1.0, end: 1.0),
      duration: const Duration(milliseconds: 1),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) {},
        onTapUp: (_) {
          onTap();
        },
        onTapCancel: () {},
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.045),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: AppColors.glassWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: screenWidth * 0.07,
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.9),
                size: screenWidth * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(
      BuildContext context, double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w700,
                color: AppColors.darkBlue,
                letterSpacing: 0.8,
              ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('View All Activities')),
                );
              },
              child: Text(
                'View All',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.02),
        Container(
          padding: EdgeInsets.all(screenWidth * 0.05),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentActivities.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: screenHeight * 0.025),
            itemBuilder: (context, index) {
              final activity = recentActivities[index];
              return FadeTransition(
                opacity: fadeAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.2, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Interval(
                        index * 0.1,
                        1.0,
                        curve: Curves.easeOut,
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                            Text('Tapped: ${activity['description']}')),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: screenWidth * 0.03,
                              height: screenWidth * 0.03,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    activity['color'],
                                    activity['color'].withOpacity(0.5),
                                  ],
                                ),
                              ),
                            ),
                            if (index < recentActivities.length - 1)
                              Container(
                                width: 2,
                                height: screenHeight * 0.07,
                                color: AppColors.divider.withOpacity(0.5),
                              ),
                          ],
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Container(
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          decoration: BoxDecoration(
                            color: activity['color'].withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: activity['color'].withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            activity['icon'],
                            color: activity['color'],
                            size: screenWidth * 0.06,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHighlightedDescription(
                                activity['description'],
                                screenWidth,
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                activity['time'],
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.034,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightedDescription(String description, double screenWidth) {
    final vehicleNoPattern =
    RegExp(r'[A-Z]{2}\s*\d{1,2}\s*[A-Z0-9]{1,4}\s*\d{4}');
    final vehicleNoMatch = vehicleNoPattern.firstMatch(description);
    final vehicleNo = vehicleNoMatch?.group(0) ?? '';

    final parts = description.split(vehicleNo);
    final cleanVehicleNo = vehicleNo.replaceAll(' ', '');

    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.w600,
          color: AppColors.darkBlue,
        ),
        children: [
          if (parts.isNotEmpty) TextSpan(text: parts[0]),
          if (vehicleNo.isNotEmpty)
            TextSpan(
              text: cleanVehicleNo,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w800,
                color: AppColors.accent,
                backgroundColor: AppColors.accent.withOpacity(0.15),
              ),
            ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _selectedIndex = 0;

  // List of pages for IndexedStack
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Faster transition
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuad, // Snappier curve
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Slide from right
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuad, // Matching curve
      ),
    );
    _animationController.forward();

    // Initialize pages with HomeContentBody
    _pages = [
      HomeContentBody(
        fadeAnimation: _fadeAnimation,
        animationController: _animationController,
      ),
      const HistoryPage(),
      const ScanPage(),
      const AlertsPage(),
      const ProfilePage(),
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SlideTransition(
        position: _slideAnimation,
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, -2),
              blurRadius: 8,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            child: GNav(
              backgroundColor: AppColors.white,
              color: AppColors.grey,
              activeColor: AppColors.darkBlue,
              tabBackgroundColor: Colors.transparent,
              tabBorderRadius: 16,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              tabMargin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              gap: 0,
              selectedIndex: _selectedIndex,
              onTabChange: _onItemTapped,
              tabs: [
                GButton(
                  icon: Icons.home_outlined,
                  iconSize: _selectedIndex == 0 ? 28 : 26,
                  iconActiveColor: AppColors.darkBlue,
                  iconColor: AppColors.grey,
                  leading: _buildHighlightedIcon(
                    icon: Icons.home_outlined,
                    isSelected: _selectedIndex == 0,
                  ),
                ),
                GButton(
                  icon: Icons.history_outlined,
                  iconSize: _selectedIndex == 1 ? 28 : 26,
                  iconActiveColor: AppColors.darkBlue,
                  iconColor: AppColors.grey,
                  leading: _buildHighlightedIcon(
                    icon: Icons.history_outlined,
                    isSelected: _selectedIndex == 1,
                  ),
                ),
                GButton(
                  icon: Icons.camera_alt_outlined,
                  iconSize: _selectedIndex == 2 ? 38 : 36,
                  iconActiveColor: AppColors.white,
                  iconColor: AppColors.white,
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.darkBlue,
                          AppColors.lightVioletBlue,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                              _selectedIndex == 2 ? 0.3 : 0.2),
                          blurRadius: _selectedIndex == 2 ? 12 : 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: _selectedIndex == 2 ? 36 : 34,
                      color: AppColors.white,
                    ),
                  ),
                ),
                GButton(
                  icon: Icons.notifications_outlined,
                  iconSize: _selectedIndex == 3 ? 28 : 26,
                  iconActiveColor: AppColors.darkBlue,
                  iconColor: AppColors.grey,
                  leading: _buildHighlightedIcon(
                    icon: Icons.notifications_outlined,
                    isSelected: _selectedIndex == 3,
                  ),
                ),
                GButton(
                  icon: Icons.person_outlined,
                  iconSize: _selectedIndex == 4 ? 28 : 26,
                  iconActiveColor: AppColors.darkBlue,
                  iconColor: AppColors.grey,
                  leading: _buildHighlightedIcon(
                    icon: Icons.person_outlined,
                    isSelected: _selectedIndex == 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedIcon(
      {required IconData icon, required bool isSelected}) {
    return Container(
      width: 52,
      height: 32,
      decoration: BoxDecoration(
        color:
        isSelected ? AppColors.darkBlue.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        icon,
        size: isSelected ? 26 : 24,
        color: isSelected ? AppColors.darkBlue : AppColors.grey,
      ),
    );
  }
}