import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../auth/login_page.dart';

class ValidatorProfilePage extends StatelessWidget {
  const ValidatorProfilePage({super.key});

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
    final name = AuthService.name ?? "Validador";
    final id = AuthService.userId?.toString() ?? "-";

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5C1),

      appBar: AppBar(
        backgroundColor: const Color(0xFF01472B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Perfil del Validador",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // ----------------------------------------------------------------------
            // AVATAR PROFESIONAL
            // ----------------------------------------------------------------------
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF01472B),
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xFFF3E5C1),
                child: Icon(Icons.verified_user, size: 60, color: Color(0xFF01472B)),
              ),
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------------------------------
            // NOMBRE
            // ----------------------------------------------------------------------
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF01472B),
              ),
            ),

            const SizedBox(height: 8),

            // ----------------------------------------------------------------------
            // ID DEL VALIDADOR
            // ----------------------------------------------------------------------
            Text(
              "ID Usuario: $id",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 35),

            // ----------------------------------------------------------------------
            // TARJETA DE INFORMACIÓN
            // ----------------------------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF01472B), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Información del Rol",
                    style: TextStyle(
                      color: Color(0xFF01472B),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Como validador, tu función es revisar las vacantes enviadas por los publicadores, aprobarlas o rechazarlas con un motivo.",
                    style: TextStyle(fontSize: 15, height: 1.3),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // ----------------------------------------------------------------------
            // BOTÓN CERRAR SESIÓN
            // ----------------------------------------------------------------------
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
                  elevation: 2,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
