import 'package:flutter/material.dart';
import 'publisher_home_page.dart';
import 'publisher_create_page.dart';
import 'publisher_profile_page.dart';

class PublisherLayout extends StatefulWidget {
  const PublisherLayout({super.key});

  @override
  State<PublisherLayout> createState() => _PublisherLayoutState();
}

class _PublisherLayoutState extends State<PublisherLayout> {
  int index = 0;

  final screens = const [
    PublisherHomePage(),
    PublisherCreatePage(),
    PublisherProfilePage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Mis Vacantes"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Crear"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}
