// lib/ui/student/student_layout.dart
import 'package:flutter/material.dart';
import 'student_home_page.dart';
import 'student_profile_page.dart';

class StudentLayout extends StatefulWidget {
  const StudentLayout({super.key});

  @override
  State<StudentLayout> createState() => _StudentLayoutState();
}

class _StudentLayoutState extends State<StudentLayout> {
  int _index = 0;

  final _screens = const [
   StudentHomePage(), // lista de vacantes
    StudentProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: const Color(0xFF01472B),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: "Vacantes"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}
