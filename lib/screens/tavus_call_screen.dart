import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../services/tavus_service.dart';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'dart:html' as html;
import 'dart:ui' as ui;
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'package:flutter/material.dart' show Colors;

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
      _registerWebView();
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

  void _registerWebView() {
    // Register the view factory only once
    ui.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframeElement = html.IFrameElement()
        ..style.border = 'none'
        ..style.height = '100%'
        ..style.width = '100%'
        ..src = widget.conversationUrl
        ..allow = 'camera; microphone; fullscreen; display-capture; autoplay';

      // Listen for iframe load event
      iframeElement.onLoad.listen((_) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      });

      return iframeElement;
    });
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

    if (Platform.isIOS) {
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

    if (Platform.isAndroid) {
      final AndroidWebViewController androidController = _controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }
  }

  Widget _buildWebView() {
    if (kIsWeb) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: HtmlElementView(
          viewType: _viewType,
        ),
      );
    } else {
      return WebViewWidget(controller: _controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _endConversation();
        return true;
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'AI Coach Call',
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