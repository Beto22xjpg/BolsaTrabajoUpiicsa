import 'package:flutter/material.dart';
import 'validator_home_page.dart';
import 'validator_profile_page.dart';

class ValidatorLayout extends StatefulWidget {
  const ValidatorLayout({super.key});

  @override
  State<ValidatorLayout> createState() => _ValidatorLayoutState();
}

class _ValidatorLayoutState extends State<ValidatorLayout> {
  int index = 0;

  final screens = const [
    ValidatorHomePage(),
    ValidatorProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: const Color(0xFF01472B),
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Validar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}
