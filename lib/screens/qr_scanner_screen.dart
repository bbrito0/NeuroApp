import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import './choose_supplements_screen.dart';
import '../widgets/widgets.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Alignment> _beginAlignment;
  late final Animation<Alignment> _endAlignment;
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _beginAlignment = AlignmentTween(
      begin: const Alignment(-1.0, -1.0),
      end: const Alignment(1.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _endAlignment = AlignmentTween(
      begin: const Alignment(0.0, 0.0),
      end: const Alignment(2.0, 2.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: CustomNavigationBar(
        title: 'Scan Supplements',
        subtitle: 'We added a QR code to each supplement.\nThis will allow you to access all the resources\nand specific information for your recovery.',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      child: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: _beginAlignment.value,
                    end: _endAlignment.value,
                    colors: AppColors.primaryGradient.colors,
                    tileMode: TileMode.mirror,
                  ),
                ),
              );
            },
          ),
          // Frosted glass effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.frostedGlassGradient,
              ),
            ),
          ),
          // QR Scanner content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Scanner viewport
                  Expanded(
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Scanner viewport
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.getPrimaryWithOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: MobileScanner(
                                controller: _scannerController,
                                onDetect: (capture) {
                                  final List<Barcode> barcodes = capture.barcodes;
                                  for (final barcode in barcodes) {
                                    if (barcode.rawValue != null) {
                                      _handleScannedCode(barcode.rawValue!);
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          // Corner guides
                          SizedBox(
                            width: 250,
                            height: 250,
                            child: CustomPaint(
                              painter: CornerPainter(
                                color: AppColors.primary.withOpacity(0.8),
                                cornerLength: 30,
                                cornerWidth: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Instructions text
                  FrostedCard(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.transparent,
                    border: Border.all(
                      color: Colors.transparent,
                      width: 0,
                    ),
                    child: Text(
                      'Point your camera at the QR code on your supplement package',
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodyMedium,
                        const Color.fromARGB(255, 255, 255, 255),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  // Development only button
                  ActionButton(
                    text: 'Dev: Go to Choose Supplements',
                    onPressed: () => _handleScannedCode('dev-test-code'),
                    style: ActionButtonStyle.filled,
                    backgroundColor: const Color.fromARGB(255, 18, 162, 183),
                    textColor: AppColors.surface,
                    isFullWidth: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleScannedCode(String code) {
    // Navigate to choose supplements screen with the scanned code
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ChooseSupplementsScreen(scannedCode: code),
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  final Color color;
  final double cornerLength;
  final double cornerWidth;

  CornerPainter({
    required this.color,
    required this.cornerLength,
    required this.cornerWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerWidth;

    // Top left corner
    canvas.drawPath(
      Path()
        ..moveTo(0, cornerLength)
        ..lineTo(0, 0)
        ..lineTo(cornerLength, 0),
      paint,
    );

    // Top right corner
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, cornerLength),
      paint,
    );

    // Bottom left corner
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - cornerLength)
        ..lineTo(0, size.height)
        ..lineTo(cornerLength, size.height),
      paint,
    );

    // Bottom right corner
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 