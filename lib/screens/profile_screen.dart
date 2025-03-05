import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'dart:math' show pi, sin;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.tabController,
  });

  final CupertinoTabController tabController;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF30B0C7);
    
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFE8E8EA).withOpacity(0.92),
      child: Stack(
        children: [
          // Wave Background
          Positioned.fill(
            child: CustomPaint(
              painter: WavePainter(
                animation: _controller,
                color: const Color(0xFFE5E5E7),
              ),
            ),
          ),
          // Main Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: '.SF Pro Text',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.41,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                middle: const Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: '.SF Pro Text',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.41,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                alwaysShowMiddle: false,
                backgroundColor: const Color(0xFFE8E8EA).withOpacity(1.0),
                border: null,
                stretch: false,
                automaticallyImplyLeading: false,
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => widget.tabController.index = 0,
                  child: const Icon(
                    CupertinoIcons.back,
                    color: Color(0xFF30B0C7),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildProfileHeader(),
                      const SizedBox(height: 24),
                      _buildStats(),
                      const SizedBox(height: 24),
                      _buildSettings(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CupertinoColors.systemBackground.withOpacity(0.35),
                CupertinoColors.secondarySystemBackground.withOpacity(0.35),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF30B0C7).withOpacity(0.08),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemFill.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF30B0C7).withOpacity(0.2),
                      const Color(0xFF30B0C7).withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    CupertinoIcons.person_fill,
                    size: 48,
                    color: Color(0xFF30B0C7),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'John Doe',
                style: TextStyle(
                  fontFamily: '.SF Pro Text',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.41,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Training since Jan 2024',
                style: TextStyle(
                  fontFamily: '.SF Pro Text',
                  fontSize: 15,
                  letterSpacing: -0.24,
                  color: CupertinoColors.secondaryLabel.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CupertinoColors.systemBackground.withOpacity(0.35),
                CupertinoColors.secondarySystemBackground.withOpacity(0.35),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF30B0C7).withOpacity(0.08),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemFill.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Stats',
                style: TextStyle(
                  fontFamily: '.SF Pro Text',
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.41,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatItem(
                    'Total Games',
                    '156',
                    const Color(0xFF30B0C7),
                  ),
                  const SizedBox(width: 12),
                  _buildStatItem(
                    'Best Score',
                    '98',
                    const Color(0xFF30B0C7),
                  ),
                  const SizedBox(width: 12),
                  _buildStatItem(
                    'Streak',
                    '7 days',
                    const Color(0xFF30B0C7),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.2),
              color.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.15),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemFill.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: '.SF Pro Text',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.41,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: '.SF Pro Text',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.24,
                color: CupertinoColors.secondaryLabel.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettings() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CupertinoColors.systemBackground.withOpacity(0.35),
                CupertinoColors.secondarySystemBackground.withOpacity(0.35),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF30B0C7).withOpacity(0.08),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemFill.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontFamily: '.SF Pro Text',
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.41,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingItem(
                'Notifications',
                CupertinoIcons.bell_fill,
                onTap: () {},
              ),
              _buildSettingItem(
                'Dark Mode',
                CupertinoIcons.moon_fill,
                onTap: () {},
              ),
              _buildSettingItem(
                'Language',
                CupertinoIcons.globe,
                onTap: () {},
              ),
              _buildSettingItem(
                'Privacy',
                CupertinoIcons.lock_fill,
                onTap: () {},
              ),
              _buildSettingItem(
                'Help & Support',
                CupertinoIcons.question_circle_fill,
                onTap: () {},
                showBorder: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon, {required VoidCallback onTap, bool showBorder = true}) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: showBorder ? Border(
            bottom: BorderSide(
              color: CupertinoColors.separator.withOpacity(0.2),
              width: 0.5,
            ),
          ) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF30B0C7).withOpacity(0.2),
                    const Color(0xFF30B0C7).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF30B0C7),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontFamily: '.SF Pro Text',
                fontSize: 17,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.41,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const Spacer(),
            const Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  WavePainter({
    required this.animation,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFFE8E8EA),
        const Color(0xFFE2E2E4),
      ],
    );
    
    final backgroundPaint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, backgroundPaint);

    final wavePaint = Paint()
      ..color = const Color(0xFFD8D8DA).withOpacity(0.45)
      ..style = PaintingStyle.fill;

    final path = Path();
    final path2 = Path();
    final path3 = Path();

    for (var i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final dx = (x / size.width);
      final sin1 = sin((dx * 2 * pi) + (animation.value * 2 * pi));
      final y = sin1 * 25 + size.height * 0.5;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    wavePaint.color = const Color(0xFFD0D0D2).withOpacity(0.35);
    for (var i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final dx = (x / size.width);
      final sin2 = sin((dx * 2 * pi) + (animation.value * 2 * pi) + pi / 4);
      final y = sin2 * 20 + size.height * 0.6;
      if (i == 0) {
        path2.moveTo(x, y);
      } else {
        path2.lineTo(x, y);
      }
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    wavePaint.color = const Color(0xFFC8C8CA).withOpacity(0.25);
    for (var i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final dx = (x / size.width);
      final sin3 = sin((dx * 2 * pi) + (animation.value * 2 * pi) - pi / 4);
      final y = sin3 * 8 + size.height * 0.8;
      if (i == 0) {
        path3.moveTo(x, y);
      } else {
        path3.lineTo(x, y);
      }
    }
    path3.lineTo(size.width, size.height);
    path3.lineTo(0, size.height);
    path3.close();

    canvas.drawPath(path, wavePaint);
    canvas.drawPath(path2, wavePaint);
    canvas.drawPath(path3, wavePaint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
} 