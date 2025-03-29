import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import './choose_supplements_screen.dart';
import '../widgets/widgets.dart';
import '../main.dart';
import 'supplement_quiz_screen.dart';
import 'supplement_details_screen.dart';

class CodeScannerScreen extends StatefulWidget {
  const CodeScannerScreen({super.key});

  @override
  State<CodeScannerScreen> createState() => _CodeScannerScreenState();
}

class _CodeScannerScreenState extends State<CodeScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: CustomNavigationBar(
        title: localizations.scanSupplementCode,
        subtitle: localizations.scanBarcodeSubtitle,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      child: Stack(
        children: [
          // Static gradient background with frosted glass effect
          GradientBackground(
            child: Container(),
            style: BackgroundStyle.premium,
            hasSafeArea: false,
          ),
          // Code Scanner content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Instructions text - moved above scanner
                  Text(
                    localizations.pointCameraBarcode,
                    style: AppTextStyles.withColor(
                      AppTextStyles.bodyMedium,
                      AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Scanner viewport
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Scanner viewport - now rectangular
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              width: 280,
                              height: 180,
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
                            width: 280,
                            height: 180,
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
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Option to enter code manually - styled as button
                        ActionButton(
                          text: localizations.enterCodeManually,
                          onPressed: () => _showManualCodeEntry(),
                          style: ActionButtonStyle.filled,
                          backgroundColor: Colors.white.withOpacity(0.8),
                          textColor: AppColors.primary,
                          isFullWidth: true,
                          height: 44,
                        ),
                        const SizedBox(height: 16),
                        // No product code option - with gradient
                        ActionButton(
                          text: localizations.noProductCode,
                          onPressed: () => _navigateToQuiz(),
                          style: ActionButtonStyle.filled,
                          backgroundColor: const Color.fromARGB(255, 18, 162, 183),
                          textColor: AppColors.surface,
                          isFullWidth: true,
                          height: 44,
                        ),
                        const SizedBox(height: 24),
                        // Development only button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              onPressed: () => _handleScannedCode('dev-test-code'),
                              color: AppColors.getPrimaryWithOpacity(0.3),
                              minSize: 0,
                              borderRadius: BorderRadius.circular(12),
                              child: Text(
                                localizations.devTestScan,
                                style: AppTextStyles.withColor(
                                  AppTextStyles.bodySmall,
                                  AppColors.surface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showManualCodeEntry() {
    final localizations = AppLocalizations.of(context)!;
    final TextEditingController codeController = TextEditingController();
    
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(localizations.enterSupplementCode),
        content: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: CupertinoTextField(
            controller: codeController,
            placeholder: localizations.enterCodeHere,
            autofocus: true,
            padding: const EdgeInsets.all(12),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(localizations.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: Text(localizations.submit),
            onPressed: () {
              final code = codeController.text.trim();
              if (code.isNotEmpty) {
                Navigator.of(context).pop();
                _handleScannedCode(code);
              }
            },
          ),
        ],
      ),
    );
  }

  void _handleScannedCode(String code) {
    // Navigate to supplement details screen with the scanned code
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => SupplementDetailsScreen(scannedCode: code),
      ),
    );
  }

  void _navigateToQuiz() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const SupplementQuizScreen(),
      ),
    );
  }

  void _navigateToLimitedFeatures() {
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => MainScreen(key: UniqueKey(), isLimitedMode: true),
        fullscreenDialog: true,
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