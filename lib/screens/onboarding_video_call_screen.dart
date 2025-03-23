import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/tavus_onboarding_service.dart';
import 'finalize_account_screen.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

class OnboardingVideoCallScreen extends StatefulWidget {
  const OnboardingVideoCallScreen({super.key});

  @override
  State<OnboardingVideoCallScreen> createState() => _OnboardingVideoCallScreenState();
}

class _OnboardingVideoCallScreenState extends State<OnboardingVideoCallScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Alignment> _beginAlignment;
  late final Animation<Alignment> _endAlignment;
  
  final _tavusService = TavusOnboardingService();
  String? _callId;
  String? _callUrl;
  Timer? _statusCheckTimer;
  bool _isCallComplete = false;
  bool _isLoading = true;
  WebViewController? _webViewController;

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

    _initializeCall();
  }

  Future<void> _initializeCall() async {
    try {
      final response = await _tavusService.createOnboardingCall();
      
      if (!mounted) return;

      final webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(response.conversationUrl));

      setState(() {
        _callId = response.conversationId;
        _callUrl = response.conversationUrl;
        _webViewController = webViewController;
        _isLoading = false;
      });

      _startStatusCheck();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _showError('Failed to initialize video call');
    }
  }

  void _showError(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _startStatusCheck() {
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_callId == null) return;

      try {
        final status = await _tavusService.getVideoCallStatus(_callId!);
        if (!mounted) return;
        
        if (status['status'] == 'completed') {
          setState(() {
            _isCallComplete = true;
          });
          _statusCheckTimer?.cancel();
          await _tavusService.endCall(_callId!);
          _navigateToFinalize();
        }
      } catch (e) {
        debugPrint('Error checking call status: $e');
      }
    });
  }

  void _navigateToFinalize() {
    if (!mounted) return;
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const FinalizeAccountScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _statusCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_callId != null) {
          await _tavusService.endCall(_callId!);
          _navigateToFinalize();
        }
        return true;
      },
      child: CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.transparent,
          border: null,
          middle: Text(
            'Initial Health Assessment',
            style: AppTextStyles.withColor(
              AppTextStyles.heading3,
              AppColors.surface,
            ),
          ),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.xmark, color: AppColors.surface),
            onPressed: () async {
              if (_callId != null) {
                await _tavusService.endCall(_callId!);
                _navigateToFinalize();
              }
              Navigator.of(context).pop();
            },
          ),
        ),
        child: Stack(
          children: [
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
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.frostedGlassGradient,
                ),
              ),
            ),
            SafeArea(
              child: _isLoading
                  ? const Center(
                      child: CupertinoActivityIndicator(
                        radius: 16,
                      ),
                    )
                  : _webViewController == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.exclamationmark_circle,
                                size: 48,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Failed to initialize video call',
                                style: AppTextStyles.withColor(
                                  AppTextStyles.heading3,
                                  AppColors.surface,
                                ),
                              ),
                              const SizedBox(height: 24),
                              CupertinoButton(
                                child: Text(
                                  'Try Again',
                                  style: AppTextStyles.withColor(
                                    AppTextStyles.actionButton,
                                    AppColors.surface,
                                  ),
                                ),
                                onPressed: _initializeCall,
                              ),
                            ],
                          ),
                        )
                      : WebViewWidget(
                          controller: _webViewController!,
                        ),
            ),
          ],
        ),
      ),
    );
  }
} 