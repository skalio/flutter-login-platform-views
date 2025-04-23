// Flutter Web Login Autofill Example
// This project demonstrates how to create custom HTML input elements with proper autocomplete attributes
// and embed them into a Flutter web app using HtmlElementView. This approach enables password managers
// to recognize and autofill login fields seamlessly.

// The code registers platform views that wrap native HTML input elements with autocomplete attributes,
// and embeds them into the Flutter widget tree, allowing password managers to interact with them naturally.

import 'package:flutter/material.dart';
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui' as ui;

// Creates a DivElement wrapper for the given input element.
// The wrapper is styled to take full width and height and is not focusable itself.
// Wrapping input elements helps with styling and layout control when embedding as platform views.
html.DivElement containerInput(html.InputElement input) {
  final wrapper =
      html.DivElement()
        ..tabIndex =
            -1 // do not allow wrapper to receive focus
        ..append(input)
        ..style.height = '100%'
        ..style.width = '100%';
  return wrapper;
}

// Registers a platform view factory with the given viewType and HTML element.
// Platform views allow embedding native HTML elements inside Flutter widgets via HtmlElementView.
// This registration is essential for Flutter Web to render the native input elements.
void registerTextField(String viewType, html.Element element) {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
    viewType,
    (int viewId) => element,
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Entry point of the app, runs the LoginApp widget.
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Login Autofill',
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static bool _initialized = false; // Ensures platform views are registered only once.

  // Native HTML input element for username with autocomplete attribute set.
  // Proper autocomplete attribute enables password managers to identify the field.
  final html.InputElement _usernameInput =
      html.InputElement()
        ..type = 'text'
        ..placeholder = 'Username'
        ..name = 'username'
        ..setAttribute('autocomplete', 'username')
        ..setAttribute('tabindex', '0')
        ..style.width = '100%'
        ..style.padding = '10px'
        ..style.fontSize = '16px';

  // Native HTML input element for password with autocomplete attribute set.
  // This setup allows password managers to autofill the password securely.
  final html.InputElement _passwordInput =
      html.InputElement()
        ..type = 'password'
        ..placeholder = 'Password'
        ..name = 'password'
        ..setAttribute('autocomplete', 'current-password')
        ..setAttribute('tabindex', '0')
        ..style.width = '100%'
        ..style.padding = '10px'
        ..style.fontSize = '16px';

  @override
  void initState() {
    super.initState();

    // Register platform views only once to avoid duplicate registrations.
    // Each input field is wrapped and registered with a unique viewType.
    if (!_initialized) {
      registerTextField('username-input', containerInput(_usernameInput));
      registerTextField('password-input', containerInput(_passwordInput));
      _initialized = true;
    }
  }

  // Handles login button press by retrieving values from native inputs.
  // Shows a dialog with the entered credentials.
  void _handleLogin() {
    final username = _usernameInput.value ?? '';
    final password = _passwordInput.value ?? '';
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Credentials'),
            content: Text('Username: $username\nPassword: $password'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message at the top of the login form.
              const Text(
                'Welcome! Please log in.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),

              // Label for username field.
              const Text('Username'),
              const SizedBox(height: 5),

              // Embeds the native username input HTML element using HtmlElementView.
              // This allows password managers to detect and autofill the username field.
              SizedBox(
                height: 50,
                child: HtmlElementView(viewType: 'username-input'),
              ),
              const SizedBox(height: 20),

              // Label for password field.
              const Text('Password'),
              const SizedBox(height: 5),

              // Embeds the native password input HTML element using HtmlElementView.
              // This enables secure autofill of the password by password managers.
              SizedBox(
                height: 50,
                child: HtmlElementView(viewType: 'password-input'),
              ),
              const SizedBox(height: 30),

              // Login button centered below the input fields.
              Center(
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
