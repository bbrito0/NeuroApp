// This is a stub file for non-web platforms 
// providing empty implementations

import 'package:flutter/widgets.dart';

// Stub classes for HTML elements
class IFrameElement {
  String src = '';
  String allow = '';
  final style = _StyleElement();
  
  Stream<dynamic> get onLoad => const Stream.empty();
}

class _StyleElement {
  String border = '';
  String height = '';
  String width = '';
}

// Stub implementations of functions used in web_shim.dart
void registerViewFactory(String viewType, String url, Function(bool) onLoaded) {
  // Do nothing in non-web platforms
}

Widget getWebView(String viewType) {
  // Return an empty container on non-web platforms
  return Container();
}

// Other necessary stub classes could be added here 