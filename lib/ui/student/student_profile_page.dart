// lib/ui/student/student_profile_page.dart
import 'package:flutter/material.dart';
import '../auth/login_page.dart';
import '../../services/auth_service.dart';

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({super.key});

  void _logout(BuildContext context) {
    AuthService.clear();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final name = AuthService.name ?? "Estudiante";
    final id = AuthService.userId?.toString() ?? "-";

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5C1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF01472B),
        title: const Text("Perfil", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF01472B), width: 2)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF01472B))),
              const SizedBox(height: 6),
              Text("ID: $id"),
            ]),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text("Cerrar sesión"),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF01472B)),
          ),
        ]),
      ),
    );
  }
}
