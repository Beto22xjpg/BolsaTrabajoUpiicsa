import 'package:flutter/material.dart';

class JobDetailPage extends StatelessWidget {
  final Map<String, String> job;

  const JobDetailPage({super.key, required this.job});

  // ======== TARJETA DE INFORMACIÓN PROFESIONAL ==========
  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
        border: Border.all(color: const Color(0xFF01472B), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: const Color(0xFF01472B)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF01472B),
                      fontSize: 15,
                    )),
                const SizedBox(height: 6),
                Text(
                  value.isEmpty ? "No especificado" : value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================
  // BUILD
  // ===========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5C1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF01472B),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Detalles de la Vacante",
            style: TextStyle(color: Colors.white)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // =====================================================
            // TÍTULO + EMPRESA
            // =====================================================
            Center(
              child: Column(
                children: [
                  Text(
                    job["titulo"] ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF01472B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job["empresa"] ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // =====================================================
            // SECCIÓN: INFORMACIÓN GENERAL
            // =====================================================
            const Text(
              "Información General",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF01472B),
              ),
            ),

            const SizedBox(height: 10),

            _infoCard(
              icon: Icons.description,
              title: "Descripción",
              value: job["descripcion"] ?? "",
            ),

            _infoCard(
              icon: Icons.location_on,
              title: "Ubicación",
              value: job["ubicacion"] ?? "",
            ),

            _infoCard(
              icon: Icons.home_work,
              title: "Dirección",
              value: job["direccion"] ?? "",
            ),

            _infoCard(
              icon: Icons.category,
              title: "Categoría",
              value: job["categoria"] ?? "",
            ),

            _infoCard(
              icon: Icons.work_outline,
              title: "Modalidad",
              value: job["modalidad"] ?? "",
            ),

            _infoCard(
              icon: Icons.access_time,
              title: "Horario",
              value: job["horario"] ?? "",
            ),

            _infoCard(
              icon: Icons.assignment_turned_in,
              title: "Tipo",
              value: job["tipo"] ?? "",
            ),

            const SizedBox(height: 20),

            // =====================================================
            // SECCIÓN: CONTACTO
            // =====================================================
            const Text(
              "Medios de Contacto",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF01472B),
              ),
            ),
            const SizedBox(height: 10),

            _infoCard(
              icon: Icons.email_outlined,
              title: "Correo electrónico",
              value: job["contacto_email"] ?? "",
            ),

            _infoCard(
              icon: Icons.phone,
              title: "Teléfono",
              value: job["contacto_tel"] ?? "",
            ),

            _infoCard(
              icon: Icons.public,
              title: "Sitio web",
              value: job["contacto_web"] ?? "",
            ),

            const SizedBox(height: 25),

            // =====================================================
            // FECHA PUBLICACIÓN
            // =====================================================
            Center(
              child: Text(
                "Fecha de publicación: ${job["fecha_publicacion"] ?? ""}",
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
