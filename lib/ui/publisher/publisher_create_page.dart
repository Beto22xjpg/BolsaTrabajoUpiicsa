// Página para crear vacante — envía id_publicador (y created_by por seguridad)
// Asegúrate que tu API acepte id_publicador o created_by.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/auth_service.dart';

class PublisherCreatePage extends StatefulWidget {
  const PublisherCreatePage({super.key});

  @override
  State<PublisherCreatePage> createState() => _PublisherCreatePageState();
}

class _PublisherCreatePageState extends State<PublisherCreatePage> {
  final formKey = GlobalKey<FormState>();

  final titulo = TextEditingController();
  final empresa = TextEditingController();
  final direccion = TextEditingController();
  final descripcion = TextEditingController();
  final telefono = TextEditingController();
  final correo = TextEditingController();
  final sitio = TextEditingController();

  String? categoria;
  String? modalidad;
  String? horario;
  String? tipo;

  List<String> categorias = ["Tecnología", "Administración", "Calidad"];
  List<String> modalidades = ["Presencial", "Híbrida", "Remota"];
  List<String> horarios = ["Tiempo completo", "Medio tiempo"];
  List<String> tipos = ["Empleo", "Prácticas", "Proyecto"];

  bool loading = false;

  final String apiBase = "http://192.168.0.92/bolsa_api/api.php?endpoint=vacantes&action=";

  Future<void> guardarYEnviar() async {
    final pubId = AuthService.userId;
    if (pubId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No se encontró id de publicador. Reingresa sesión.")));
      return;
    }

    if (titulo.text.trim().isEmpty || empresa.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Título y empresa son obligatorios")));
      return;
    }

    setState(() => loading = true);

    final uri = Uri.parse("${apiBase}create");

    final body = {
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
      // envío ambos por compatibilidad con diferentes backends:
      "created_by": pubId.toString(),
      "id_publicador": pubId.toString(),
    };

    try {
      final res = await http.post(uri, body: body);

      if (res.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error HTTP: ${res.statusCode}")));
        setState(() => loading = false);
        return;
      }

      dynamic data;
      try {
        data = json.decode(res.body);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Respuesta inválida del servidor")));
        setState(() => loading = false);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["mensaje"] ?? "Respuesta del servidor")));
      setState(() => loading = false);

      if (data["error"] == false) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Excepción: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5C1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF01472B),
        title: const Text("Crear Vacante", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _input("Título de la vacante", titulo),
            _input("Empresa", empresa),
            _input("Dirección", direccion),
            _dropdown("Categoría", categorias, (v) => categoria = v),
            _dropdown("Modalidad", modalidades, (v) => modalidad = v),
            _dropdown("Horario", horarios, (v) => horario = v),
            _dropdown("Tipo de vacante", tipos, (v) => tipo = v),
            _input("Teléfono", telefono),
            _input("Correo", correo),
            _input("Sitio web", sitio),
            _largeInput("Descripción", descripcion),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : guardarYEnviar,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF01472B)),
                child: loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Guardar y Enviar a Validación", style: TextStyle(color: Colors.white)),
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
          labelStyle: const TextStyle(color: Color(0xFF01472B)),
          filled: true,
          fillColor: Colors.white,
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
          labelStyle: const TextStyle(color: Color(0xFF01472B)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _dropdown(String label, List<String> items, Function(String?) onChange) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF01472B)),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChange,
      ),
    );
  }
}
