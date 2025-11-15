import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/home_page.dart';

class ExampleApp extends StatefulWidget {
  final Auth0? auth0;
  const ExampleApp({this.auth0, Key? key}) : super(key: key);

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  UserProfile? _user;
  late Auth0 auth0;
  late Auth0Web auth0Web;
  bool _loading = true;
  bool _webLoginCalled = false;

  @override
  void initState() {
    super.initState();

    auth0 = widget.auth0 ??
        Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);
    auth0Web =
        Auth0Web(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);

    if (kIsWeb) {
      _handleWebRedirect();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => triggerLogin());
    }
  }

  Future<void> _handleWebRedirect() async {
    try {
      final credentials = await auth0Web.onLoad();
      if (credentials != null) {
        setState(() {
          _user = credentials.user;
          _loading = false;
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) => triggerLogin());
      }
    } catch (e) {
      debugPrint('Error handling web redirect: $e');
      setState(() => _loading = false);
    }
  }

  Future<void> loginWeb() async {
    if (_webLoginCalled) return;
    _webLoginCalled = true;
    setState(() => _loading = true);

    try {
      await auth0Web.loginWithRedirect(
        redirectUrl: kReleaseMode
            ? 'https://your-production-domain.com/callback'
            : 'http://localhost:3000/callback',
      );
    } catch (e) {
      debugPrint('Web login error: $e');
      setState(() => _loading = false);
    }
  }

  Future<void> loginMobile() async {
    setState(() => _loading = true);

    try {
      final credentials = await auth0
          .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
          .login(useHTTPS: true);

      setState(() {
        _user = credentials.user;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Mobile login error: $e');
      setState(() => _loading = false);
    }
  }

  void triggerLogin() {
    if (_user != null) return;
    if (kIsWeb) {
      loginWeb();
    } else {
      loginMobile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        body: Center(
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : (_user != null
                  ? const HomePage()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle,
                          size: 100,
                          color: Colors.white70,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Please log in to continue',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: triggerLogin,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.blueAccent,
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )),
        ),
      ),
    );
  }
}
