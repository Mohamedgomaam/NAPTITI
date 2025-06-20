import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nabtiti/NABTITI/UI/Landing/page/landing.dart';
import 'package:nabtiti/NABTITI/manager/app_cubit.dart';
import 'package:nabtiti/NABTITI/manager/app_cubit.dart';
import 'NABTITI/UI/ChatBot/Page/core/di/service_locator.dart';
import 'NABTITI/UI/ChatBot/Page/presentation/pages/chat_page.dart';
import 'NABTITI/UI/Home/Page/Home.dart';
import 'NABTITI/shared.dart';
import 'generated/l10n.dart';


void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PreferenceUtils.init();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return MaterialApp(
            locale: Locale(PreferenceUtils.getString(prefKeys.language, 'ar')),
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: const[
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
            routes: {
              '/home': (context) => Home(),
              '/chatbot': (context) => ChatPage(),
            },
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1100), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });
    ;
    Timer(const Duration(seconds: 7), () {
      print("==========================${PreferenceUtils.getBool(
          prefKeys.loggedIn)}");
      if (!PreferenceUtils.getBool(prefKeys.loggedIn)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PostLoginSplashScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/bg_login.png', fit: BoxFit.cover),
          Center(
            child: AnimatedOpacity(
              duration: const Duration(seconds: 5),
              opacity: _opacity,
              child: AnimatedScale(
                scale: _scale,
                duration: const Duration(seconds: 5),
                curve: Curves.easeOutBack,
                child: Image.asset('assets/logo.png', width: 200, height: 200),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class PostRegisterScreen extends StatefulWidget {
  @override
  _PostRegisterScreenState createState() => _PostRegisterScreenState();
}

class _PostRegisterScreenState extends State<PostRegisterScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_after.png'), // Ensure this exists
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', width: 100),
              // Ensure this exists
              SizedBox(height: 20),
              Text(
                S().thankYou,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(color: Colors.white),
              // Ensure visibility
            ],
          ),
        ),
      ),
    );
  }
}


class PostLoginSplashScreen extends StatefulWidget {
  @override
  _PostLoginSplashScreenState createState() => _PostLoginSplashScreenState();
}

class _PostLoginSplashScreenState extends State<PostLoginSplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_after.png'), // Ensure this exists
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', width: 100),
              SizedBox(height: 20),
              Text(
                S().welcomeBack,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(color: Colors.white),
              // Ensure visibility
            ],
          ),
        ),
      ),
    );
  }
}

