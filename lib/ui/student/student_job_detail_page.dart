// lib/ui/student/job_detail_page.dart
import 'package:flutter/material.dart';

class JobDetailPage extends StatelessWidget {
  final Map<String, String> job;
  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5C1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF01472B),
        title: Text(job["titulo"] ?? job["title"] ?? "Detalle", style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(job["titulo"] ?? job["title"] ?? "", style: const TextStyle(fontSize: 28, color: Color(0xFF01472B), fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(job["empresa"] ?? job["company"] ?? "Empresa no especificada", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(height: 20),
          _infoCard(icon: Icons.pin_drop, title: "Ubicación", value: job["ubicacion"] ?? ""),
          _infoCard(icon: Icons.access_time, title: "Horario", value: job["horario"] ?? ""),
          _infoCard(icon: Icons.meeting_room, title: "Modalidad", value: job["modalidad"] ?? ""),
          _infoCard(icon: Icons.category, title: "Categoría", value: job["categoria"] ?? ""),
          _infoCard(icon: Icons.work_outline, title: "Tipo", value: job["tipo"] ?? ""),
          const SizedBox(height: 20),
          const Text("Descripción del Puesto", style: TextStyle(fontSize: 22, color: Color(0xFF01472B), fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(job["descripcion"] ?? job["descripcion"] ?? "No hay descripción.", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          const Text("Contacto", style: TextStyle(fontSize: 22, color: Color(0xFF01472B), fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _contactRow(Icons.phone, job["telefono"] ?? ""),
          _contactRow(Icons.email, job["correo"] ?? ""),
          _contactRow(Icons.language, job["sitio"] ?? ""),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _infoCard({required IconData icon, required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF7D1A21), width: 2)),
      child: Row(children: [
        Icon(icon, color: const Color(0xFF01472B)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF01472B))), Text(value)])),
      ]),
    );
  }

  Widget _contactRow(IconData icon, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF01472B), width: 2)),
      child: Row(children: [Icon(icon, color: const Color(0xFF01472B)), const SizedBox(width: 12), Expanded(child: Text(value.isEmpty ? "No disponible" : value))]),
    );
  }
}
