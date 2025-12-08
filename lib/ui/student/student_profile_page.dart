// lib/ui/student/student_profile_page.dart

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../auth/login_page.dart';

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({super.key});

  void _logout(BuildContext context) {
    AuthService.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = AuthService.name ?? "Estudiante";
    final id = AuthService.userId?.toString() ?? "-";

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5C1),

      appBar: AppBar(
        backgroundColor: const Color(0xFF01472B),
        title: const Text(
          "Perfil del Estudiante",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25),

            // Avatar elegante
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFFDFAE3B),
              child: const Icon(Icons.person, size: 58, color: Colors.white),
            ),

            const SizedBox(height: 18),

            // Nombre
            Text(
              name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF01472B),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // ID Estudiante estilizado
            Text(
              "ID Usuario: $id",
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF01472B),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            // Tarjeta elegante
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF01472B), width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Información del estudiante",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF01472B),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Puedes revisar las vacantes disponibles, aplicar filtros y consultar los detalles completos de cada vacante.",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // Botón cerrar sesión
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Cerrar Sesión",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: const Color(0xFF01472B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
