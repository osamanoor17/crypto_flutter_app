import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/consts.dart';
import '../list_of_coins/crypto_lists.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => CryptoListScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.greenAccent, Colors.amberAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SizedBox(
              child: Image.asset(
                AppImages.logo,
                fit: BoxFit.cover,
                height: 400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
