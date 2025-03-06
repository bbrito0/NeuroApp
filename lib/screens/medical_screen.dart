import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';

class MedicalScreen extends StatefulWidget {
  const MedicalScreen({
    super.key,
    required this.tabController,
  });

  final CupertinoTabController tabController;

  @override
  State<MedicalScreen> createState() => _MedicalScreenState();
}

class _MedicalScreenState extends State<MedicalScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF0C99B3);
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Premium Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-1.0, 1.0),
                end: const Alignment(1.0, -1.0),
                colors: [
                  const Color(0xFF6a8d97).withOpacity(0.9),
                  const Color(0xFFbdd1d5).withOpacity(0.9),
                  const Color(0xFFE8F5F8).withOpacity(0.9),
                ],
                stops: const [0.15, 0.6, 1.0],
              ),
            ),
          ),
          // Frosted Glass Overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-1.0, 1.0),
                  end: const Alignment(1.0, -1.0),
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),
          // Main Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text(
                  'Medical',
                  style: TextStyle(
                    fontFamily: '.SF Pro Text',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.41,
                    color: CupertinoColors.label,
                  ),
                ),
                middle: const Text(
                  'Medical',
                  style: TextStyle(
                    fontFamily: '.SF Pro Text',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.41,
                    color: CupertinoColors.label,
                  ),
                ),
                alwaysShowMiddle: false,
                backgroundColor: Colors.transparent,
                border: null,
                stretch: false,
                automaticallyImplyLeading: false,
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => widget.tabController.index = 0,
                  child: Icon(
                    CupertinoIcons.back,
                    color: primaryColor,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              primaryColor.withOpacity(0.15),
                              primaryColor.withOpacity(0.05),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: SFIcon(
                          SFIcons.sf_cross_case,
                          fontSize: 48,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Coming Soon',
                        style: TextStyle(
                          fontFamily: '.SF Pro Text',
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.41,
                          color: CupertinoColors.label,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Medical features are being developed.\nStay tuned for comprehensive health tracking.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: '.SF Pro Text',
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.41,
                          color: CupertinoColors.secondaryLabel.withOpacity(0.9),
                          height: 1.3,
                        ),
                      ),
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
} 