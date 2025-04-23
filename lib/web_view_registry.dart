// Only expose platformViewRegistry on web
// This will not be included in non-web builds
// ignore: avoid_web_libraries_in_flutter
@JS('window')
library web;

import 'dart:html';
import 'package:js/js.dart';

@JS('customElements')
external dynamic get customElements;

@JS('flutter')
external Flutter get flutter;

@JS()
@anonymous
class Flutter {
  external void registerPlatformViewFactory(
      String viewType, Function factory);
}