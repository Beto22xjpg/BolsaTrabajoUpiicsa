import 'package:flutter/material.dart';

// IMPORTS CORRECTOS
import 'ui/auth/login_page.dart';
import 'ui/student/student_home_page.dart';
import 'ui/publisher/publisher_layout.dart';
import 'ui/validator/validator_layout.dart';
import 'ui/admin/admin_layout.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // PANTALLA INICIAL (LOGIN)
      home: const LoginPage(),

      routes: {
        "/estudiante": (_) => const StudentHomePage(),
        "/publicador": (_) => const PublisherLayout(),
        "/validador": (_) => const ValidatorLayout(),
        "/admin":     (_) => const AdminLayout(),
      },
    );
  }
}
