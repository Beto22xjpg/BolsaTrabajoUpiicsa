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
        title: const Text(
          "Perfil del Publicador",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25),

            // Avatar elegante
            CircleAvatar(
              radius: 48,
              backgroundColor: const Color(0xFF01472B),
              child: const Icon(Icons.person, size: 55, color: Colors.white),
            ),

            const SizedBox(height: 18),

            // Nombre
            Text(
              name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF01472B),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 6),

            

            // ID Publicador
            Text(
              "ID Usuario: $id",
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF01472B),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 40),


            const Spacer(),

            // BOTÓN CERRAR SESIÓN
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
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
