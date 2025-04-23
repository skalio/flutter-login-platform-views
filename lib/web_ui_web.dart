// lib/web_ui_web.dart
// ignore: avoid_web_libraries_in_flutter
@JS('window')
library web;

import 'dart:html';
import 'package:js/js.dart';

import 'web_ui_stub.dart';

@JS()
external Flutter get flutter;

@JS()
@anonymous
class Flutter {
  external void registerPlatformViewFactory(String viewType, Function factory);
}

class _WebPlatformViewRegistry implements PlatformViewRegistryShim {
  @override
  void registerViewFactory(String viewType, Function factory) {
    flutter.registerPlatformViewFactory(viewType, allowInterop(factory));
  }
}

final platformViewRegistry = _WebPlatformViewRegistry();