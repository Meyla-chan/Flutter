import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart';
import 'screens/profil/profile_screen.dart';
import 'utils/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Identity Service App',
      theme: ThemeData(),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String? _token;
  Map<String, dynamic>? _user;
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  void _checkLoginState() async {
    final t = Storage.getToken();
    final u = Storage.getUser();

    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      _token = t;
      _user = u;
      _checked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_checked) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_token == null || _user == null) {
      return LoginScreen();
    }

    return ProfileScreen(); // langsung ke profil sesuai role
  }
}
