import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:shop_wise/app/view/home/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff213555),
      body: Center(
        child: Lottie.asset(
          'assets/animations/splash_shop_wise.json',
          repeat: false,
          onLoaded: (composition) {
            _goToHomeDelayed();
          }
        ),
      ),
    );
  }

  void _goToHomeDelayed() {
    Future.delayed(Duration(seconds: 4)).then((value) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          return HomePage();
        }),
        (route) => false,
      );
    });
  }
}
