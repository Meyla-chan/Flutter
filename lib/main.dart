import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'utils/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.init();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Identity Service App',
      theme: ThemeData(primarySwatch: Colors.blue),
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
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  void _checkToken() async {
    final t = Storage.getToken();
    setState(() {
      _token = t;
      _checked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_checked) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_token == null) {
      return LoginScreen();
    } else {
      return ProfileScreen();
    }
  }
}
