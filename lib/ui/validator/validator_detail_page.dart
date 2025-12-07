import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/auth_service.dart';

class ValidatorDetailPage extends StatefulWidget {
  final Map<String, dynamic> vacante;
  const ValidatorDetailPage({super.key, required this.vacante});

  @override
  State<ValidatorDetailPage> createState() => _ValidatorDetailPageState();
}

class _ValidatorDetailPageState extends State<ValidatorDetailPage> {
  final TextEditingController rechazoController = TextEditingController();
  bool loading = false;
  String errorMsg = "";

  final String apiBase = "http://192.168.0.92/bolsa_api/api.php?endpoint=vacantes&action=";

  Future<void> aprobar() async {
    final id = widget.vacante["id"]?.toString();
    final idValidador = AuthService.userId;
    if (id == null || idValidador == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Faltan datos para aprobar")));
      return;
    }

    setState((){ loading = true; errorMsg = ""; });

    final uri = Uri.parse("${apiBase}approve");
    try {
      final res = await http.post(uri, body: {"id": id, "id_validador": idValidador.toString()});
      setState(()=>loading=false);
      if (res.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error HTTP: ${res.statusCode}")));
        return;
      }
      final data = jsonDecode(res.body);
      if (data["error"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vacante aprobada")));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["mensaje"] ?? "Error servidor")));
      }
    } catch (e) {
      setState(()=>loading=false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Excepción: $e")));
    }
  }

  Future<void> rechazar() async {
    final id = widget.vacante["id"]?.toString();
    final idValidador = AuthService.userId;
    final motivo = rechazoController.text.trim();

    if (id == null || idValidador == null || motivo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Proporcione un motivo para el rechazo")));
      return;
    }

    setState((){ loading = true; errorMsg = ""; });

    final uri = Uri.parse("${apiBase}reject");
    try {
      final res = await http.post(uri, body: {"id": id, "id_validador": idValidador.toString(), "motivo": motivo});
      setState(()=>loading=false);
      if (res.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error HTTP: ${res.statusCode}")));
        return;
      }
      final data = jsonDecode(res.body);
      if (data["error"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vacante rechazada y motivo registrado")));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["mensaje"] ?? "Error servidor")));
      }
    } catch (e) {
      setState(()=>loading=false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Excepción: $e")));
    }
  }

  void mostrarDialogoRechazo() {
    rechazoController.text = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Motivo del rechazo"),
        content: TextField(
          controller: rechazoController,
          maxLines: 4,
          decoration: const InputDecoration(hintText: "Describa el motivo"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(onPressed: () {
            Navigator.pop(context);
            rechazar();
          }, child: const Text("Enviar rechazo")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.vacante;

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5C1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF01472B),
        title: Text("Validar: ${job["titulo"] ?? job["titulo"]}", style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job["titulo"] ?? "", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF01472B))),
            const SizedBox(height: 8),
            Text("Empresa: ${job["empresa"] ?? ""}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            _infoCard("Ubicación", job["ubicacion"] ?? ""),
            _infoCard("Descripción", job["descripcion"] ?? ""),
            const SizedBox(height: 18),
            if (loading) const Center(child: CircularProgressIndicator()),
            if (!loading)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: aprobar,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(14)),
                      child: const Text("Aprobar", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: mostrarDialogoRechazo,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.all(14)),
                      child: const Text("Rechazar", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),

            if (errorMsg.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(errorMsg, style: const TextStyle(color: Colors.red)),
            ]
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF01472B), width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF01472B))),
          const SizedBox(height: 6),
          Text(value),
        ],
      ),
    );
  }
}
