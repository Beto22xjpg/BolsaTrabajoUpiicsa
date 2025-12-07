// lib/ui/publisher/publisher_edit_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PublisherEditPage extends StatefulWidget {
  final Map<String, dynamic> vacante;
  const PublisherEditPage({super.key, required this.vacante});

  @override
  State<PublisherEditPage> createState() => _PublisherEditPageState();
}

class _PublisherEditPageState extends State<PublisherEditPage> {
  final String apiBase = "http://192.168.0.92/bolsa_api/api.php?endpoint=vacantes&action=";

  late TextEditingController titulo;
  late TextEditingController empresa;
  late TextEditingController direccion;
  late TextEditingController descripcion;
  late TextEditingController telefono;
  late TextEditingController correo;
  late TextEditingController sitio;

  String? categoria;
  String? modalidad;
  String? horario;
  String? tipo;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    final v = widget.vacante;
    titulo = TextEditingController(text: v["titulo"] ?? v["title"] ?? "");
    empresa = TextEditingController(text: v["empresa"] ?? "");
    direccion = TextEditingController(text: v["direccion"] ?? "");
    descripcion = TextEditingController(text: v["descripcion"] ?? "");
    telefono = TextEditingController(text: v["telefono"] ?? "");
    correo = TextEditingController(text: v["correo"] ?? "");
    sitio = TextEditingController(text: v["sitio"] ?? "");
    categoria = v["categoria"] ?? "";
    modalidad = v["modalidad"] ?? "";
    horario = v["horario"] ?? "";
    tipo = v["tipo"] ?? "";
  }

  Future<void> actualizar() async {
    setState(()=>loading=true);
    final uri = Uri.parse("${apiBase}update");
    final Map<String,String> body = {
      "id": widget.vacante["id"].toString(),
      // enviamos solo los campos actuales (puedes ajustar para enviar solo si cambiaron)
      "titulo": titulo.text.trim(),
      "empresa": empresa.text.trim(),
      "direccion": direccion.text.trim(),
      "categoria": categoria ?? "",
      "modalidad": modalidad ?? "",
      "horario": horario ?? "",
      "ubicacion": direccion.text.trim(),
      "tipo": tipo ?? "",
      "descripcion": descripcion.text.trim(),
      "telefono": telefono.text.trim(),
      "correo": correo.text.trim(),
      "sitio": sitio.text.trim(),
    };

    try {
      final res = await http.post(uri, body: body);
      setState(()=>loading=false);
      if (res.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error HTTP: ${res.statusCode}")));
        return;
      }
      final data = jsonDecode(res.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["mensaje"] ?? "Respuesta servidor")));
      if (data["error"] == false) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(()=>loading=false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Excepción: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.vacante;
    final estado = v["estado"] ?? "Pendiente";

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5C1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF01472B),
        title: Text(v["titulo"] ?? "Editar vacante", style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _input("Título", titulo),
            _input("Empresa", empresa),
            _input("Dirección", direccion),
            _input("Teléfono", telefono),
            _input("Correo", correo),
            _input("Sitio web", sitio),
            _largeInput("Descripción", descripcion),
            const SizedBox(height: 10),
            Text("Estado: $estado", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : actualizar,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF01472B)),
                child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text("Guardar cambios"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _largeInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: 5,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
