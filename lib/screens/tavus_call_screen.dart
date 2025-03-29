import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/tavus_service.dart';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
// Conditionally import dart:html using a different approach
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'package:flutter/services.dart';

// Import stub for non-web platforms
import 'web_stub.dart' if (dart.library.html) 'web_shim.dart';

class TavusCallScreen extends StatefulWidget {
  final String conversationUrl;
  final String conversationId;

  const TavusCallScreen({
    Key? key,
    required this.conversationUrl,
    required this.conversationId,
  }) : super(key: key);

  @override
  State<TavusCallScreen> createState() => _TavusCallScreenState();
}

class _TavusCallScreenState extends State<TavusCallScreen> {
  final _logger = Logger('TavusCallScreen');
  final _tavusService = TavusService();
  late final WebViewController _controller;
  bool _isLoading = true;
  final String _viewType = 'tavus-iframe';

  @override
  void initState() {
    super.initState();
    _cleanupOldConversations();
    if (kIsWeb) {
      // On web, we'll register a different view
      registerWebView();
      // Set loading to false after a short delay for web
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      });
    } else {
      _initWebView();
    }
  }

  Future<void> _cleanupOldConversations() async {
    try {
      await _tavusService.endAllActiveConversations();
    } catch (e) {
      _logger.warning('Error cleaning up old conversations: $e');
    }
  }

  // This method will only be called on web platforms
  // The implementation is in web_shim.dart which is only loaded on web
  void registerWebView() {
    if (kIsWeb) {
      try {
        // Call the method from the conditionally imported file
        registerViewFactory(_viewType, widget.conversationUrl, (isLoaded) {
          if (mounted) {
            setState(() => _isLoading = false);
          }
        });
      } catch (e) {
        _logger.severe('Error registering web view: $e');
      }
    }
  }

  @override
  void dispose() {
    _endConversation();
    super.dispose();
  }

  Future<void> _endConversation() async {
    try {
      _logger.info('Ending conversation: ${widget.conversationId}');
      await _tavusService.endConversation(widget.conversationId);
    } catch (e) {
      _logger.warning('Error ending conversation: $e');
    }
  }

  void _initWebView() {
    late final PlatformWebViewControllerCreationParams params;

    if (!kIsWeb && Platform.isIOS) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(CupertinoColors.systemBackground)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            _logger.severe('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.conversationUrl));

    if (!kIsWeb && Platform.isAndroid) {
      final AndroidWebViewController androidController = _controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }
  }

  Widget _buildWebView() {
    if (kIsWeb) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: getWebView(_viewType),
      );
    } else {
      return WebViewWidget(controller: _controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return WillPopScope(
      onWillPop: () async {
        await _endConversation();
        return true;
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            localizations.aiCoachCall,
            style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
          ),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.xmark),
            onPressed: () async {
              await _endConversation();
              if (!mounted) return;
              Navigator.of(context).pop();
            },
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: _buildWebView(),
            ),
            if (_isLoading)
              const Center(
                child: CupertinoActivityIndicator(),
              ),
          ],
        ),
      ),
    );
  }
} 