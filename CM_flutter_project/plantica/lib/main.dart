import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantica/bloc/auth/auth_bloc.dart';
import 'package:plantica/bloc/scan/scan_bloc.dart'; 
import 'package:plantica/screens/login.dart';
import 'package:plantica/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plantica/database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  late final AppDatabase appDatabase;

  @override
  void initState() {
    super.initState();
    appDatabase = AppDatabase();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;

    setState(() {
      _isLoggedIn = loggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: appDatabase,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              database: context.read<AppDatabase>(),
            ),
          ),
          BlocProvider(
            create: (context) => ScanBloc(
              database: context.read<AppDatabase>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: _isLoggedIn ? const MainPage() : LoginPage(),
        ),
      ),
    );
  }
}