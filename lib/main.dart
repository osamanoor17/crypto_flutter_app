// lib/main.dart
import 'package:crypto_flutter_app/screens/crypto_lists.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CryptoApp());
}

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto Prices',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CryptoListScreen(),
    );
  }
}
