// This file is only loaded on web platforms
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';

// Register a view factory for the iframe
void registerViewFactory(String viewType, String url, Function(bool) onLoaded) {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final iframeElement = html.IFrameElement()
      ..style.border = 'none'
      ..style.height = '100%'
      ..style.width = '100%'
      ..src = url
      ..allow = 'camera; microphone; fullscreen; display-capture; autoplay';

    // Listen for iframe load event
    iframeElement.onLoad.listen((_) {
      onLoaded(true);
    });

    return iframeElement;
  });
}

// Return the HtmlElementView
Widget getWebView(String viewType) {
  return HtmlElementView(viewType: viewType);
} 