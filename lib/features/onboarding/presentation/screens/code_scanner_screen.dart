import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:go_router/go_router.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';

import '../../../../core/widgets/widgets.dart';

class CodeScannerScreen extends StatefulWidget {
  const CodeScannerScreen({super.key});

  @override
  State<CodeScannerScreen> createState() => _CodeScannerScreenState();
}

class _CodeScannerScreenState extends State<CodeScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  
  // UI Constants
  static const double standardPadding = 24.0;
  static const double smallSpacing = 16.0;
  static const double mediumSpacing = 20.0;
  static const double largeSpacing = 24.0;
  static const double scannerWidth = 280.0;
  static const double scannerHeight = 180.0;
  static const double scannerBorderRadius = 24.0;
  static const double scannerBorderWidth = 2.0;
  static const double cornerLength = 30.0;
  static const double cornerWidth = 4.0;
  static const double buttonHeight = 44.0;
  static const double devButtonPaddingHorizontal = 12.0;
  static const double devButtonPaddingVertical = 6.0;
  static const double devButtonBorderRadius = 12.0;
  static const double textFieldTopPadding = 16.0;
  static const double textFieldPadding = 12.0;

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
    final localizations = AppLocalizations.of(context);
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: CustomNavigationBar(
        title: localizations.scanSupplementCode,
        subtitle: localizations.scanBarcodeSubtitle,
        onBackPressed: () => GoRouter.of(context).pop(),
      ),
      child: Stack(
        children: [
          // Static gradient background with frosted glass effect
          GradientBackground(
            style: BackgroundStyle.premium,
            hasSafeArea: false,
            child: Container(),
          ),
          // Code Scanner content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(standardPadding),
              child: Column(
                children: [
                  const SizedBox(height: smallSpacing),
                  // Instructions text - moved above scanner
                  Text(
                    localizations.pointCameraBarcode,
                    style: AppTextStyles.withColor(
                      AppTextStyles.bodyMedium,
                      AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: mediumSpacing),
                  // Scanner viewport
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Scanner viewport - now rectangular
                          ClipRRect(
                            borderRadius: BorderRadius.circular(scannerBorderRadius),
                            child: Container(
                              width: scannerWidth,
                              height: scannerHeight,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.getPrimaryWithOpacity(0.3),
                                  width: scannerBorderWidth,
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
                            width: scannerWidth,
                            height: scannerHeight,
                            child: CustomPaint(
                              painter: CornerPainter(
                                color: AppColors.getColorWithOpacity(AppColors.primary, 0.8),
                                cornerLength: cornerLength,
                                cornerWidth: cornerWidth,
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
                          backgroundColor: AppColors.getColorWithOpacity(Colors.white, 0.8),
                          textColor: AppColors.primary,
                          isFullWidth: true,
                          height: buttonHeight,
                        ),
                        const SizedBox(height: smallSpacing),
                        // No product code option - with gradient
                        ActionButton(
                          text: localizations.noProductCode,
                          onPressed: () => _navigateToQuiz(),
                          style: ActionButtonStyle.filled,
                          backgroundColor: const Color.fromARGB(255, 18, 162, 183),
                          textColor: AppColors.surface,
                          isFullWidth: true,
                          height: buttonHeight,
                        ),
                        const SizedBox(height: largeSpacing),
                        // Development only button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(
                                horizontal: devButtonPaddingHorizontal, 
                                vertical: devButtonPaddingVertical
                              ),
                              onPressed: () => _handleScannedCode('dev-test-code'),
                              color: AppColors.getPrimaryWithOpacity(0.3),
                              minSize: 0,
                              borderRadius: BorderRadius.circular(devButtonBorderRadius),
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
    final localizations = AppLocalizations.of(context);
    final TextEditingController codeController = TextEditingController();
    
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(localizations.enterSupplementCode),
        content: Padding(
          padding: const EdgeInsets.only(top: textFieldTopPadding),
          child: CupertinoTextField(
            controller: codeController,
            placeholder: localizations.enterCodeHere,
            autofocus: true,
            padding: const EdgeInsets.all(textFieldPadding),
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
    context.goNamed(
      'supplement-details',
      pathParameters: {'code': code},
    );
  }

  void _navigateToQuiz() {
    context.goNamed('supplement-quiz');
  }


}

class CornerPainter extends CustomPainter {
  final Color color;
  final double cornerLength;
  final double cornerWidth;

  const CornerPainter({
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