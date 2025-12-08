import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../auth/login_page.dart';

class PublisherProfilePage extends StatelessWidget {
  const PublisherProfilePage({super.key});

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
    final name = AuthService.name ?? "Publicador";
    final id = AuthService.userId?.toString() ?? "-";

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5C1),

      appBar: AppBar(
        backgroundColor: const Color(0xFF01472B),
        elevation: 0,
        title: const Text(
          "Perfil del Publicador",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --------------------------
            // AVATAR ELEGANTE
            // --------------------------
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF01472B),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 70, color: Color(0xFF01472B)),
              ),
            ),

            const SizedBox(height: 20),

            // --------------------------
            // NOMBRE
            // --------------------------
            Text(
              name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF01472B),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 6),

            // --------------------------
            // ID
            // --------------------------
            Text(
              "ID del Publicador: $id",
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF01472B),
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 30),

            // --------------------------
            // CARD DE INFORMACIÓN
            // --------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF01472B), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.badge, color: Color(0xFF01472B), size: 28),
                      SizedBox(width: 12),
                      Text(
                        "Cuenta verificada",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF01472B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Tu rol te permite crear y enviar vacantes dentro de la plataforma.",
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // --------------------------
            // BOTÓN DE CERRAR SESIÓN
            // --------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Cerrar Sesión",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF7D1A21),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
