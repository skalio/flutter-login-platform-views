// lib/web_ui_stub.dart

abstract class PlatformViewRegistryShim {
  void registerViewFactory(String viewType, dynamic Function(int) factory);
}

final platformViewRegistry = _StubPlatformViewRegistry();

class _StubPlatformViewRegistry implements PlatformViewRegistryShim {
  @override
  void registerViewFactory(String viewType, Function factory) {
    throw UnsupportedError(
        'Cannot use platformViewRegistry on non-web platforms.');
  }
}