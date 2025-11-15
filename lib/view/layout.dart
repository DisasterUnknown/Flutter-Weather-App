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

    _checkSession();
  }

  /// Checks if the user is already logged in
  void _checkSession() async {
    setState(() => _loading = true);

    if (kIsWeb) {
      try {
        final credentials = await auth0Web.onLoad();
        setState(() {
          _user = credentials?.user;
          _loading = false;
        });

        // Trigger login if not logged in yet
        if (_user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) => loginWeb());
        }
      } catch (e) {
        debugPrint('Error checking web session: $e');
        setState(() => _loading = false);
      }
    } else {
      loginMobile();
    }
  }

  /// Web login (redirect)
  Future<void> loginWeb() async {
    if (_webLoginCalled) return;
    _webLoginCalled = true;

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

  /// Mobile login
  Future<void> loginMobile() async {
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

  /// Trigger login dynamically (button, etc.)
  void triggerLogin() {
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
                      children: [
                        const Text(
                          'Not logged again!',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: triggerLogin,
                          child: const Text('Login'),
                        ),
                      ],
                    )),
        ),
      ),
    );
  }
}
