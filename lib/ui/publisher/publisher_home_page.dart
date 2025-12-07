import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/auth_service.dart';
import 'publisher_create_page.dart';

class PublisherHomePage extends StatefulWidget {
  const PublisherHomePage({super.key});

  @override
  State<PublisherHomePage> createState() => _PublisherHomePageState();
}

class _PublisherHomePageState extends State<PublisherHomePage> {
  List<dynamic> vacantes = [];
  bool loading = true;
  String errorMsg = "";

  final String apiBase =
      "http://192.168.0.92/bolsa_api/api.php?endpoint=vacantes&action=list_by_publisher";

  @override
  void initState() {
    super.initState();
    cargarVacantes();
  }

  Future<void> cargarVacantes() async {
    setState(() {
      loading = true;
      errorMsg = "";
    });

    final pubId = AuthService.userId;
    if (pubId == null) {
      setState(() {
        loading = false;
        errorMsg = "Error: no hay sesión de publicador. Inicia sesión nuevamente.";
      });
      return;
    }

    final url = Uri.parse("$apiBase&publisher_id=$pubId");

    try {
      final res = await http.get(url);
      if (res.statusCode != 200) {
        setState(() {
          loading = false;
          errorMsg = "Error de conexión: ${res.statusCode}";
        });
        return;
      }

      dynamic data;
      try {
        data = json.decode(res.body);
      } catch (e) {
        setState(() {
          loading = false;
          errorMsg = "Respuesta inválida del servidor";
        });
        return;
      }

      if (data["error"] == true) {
        setState(() {
          loading = false;
          errorMsg = data["mensaje"] ?? "Error servidor";
        });
        return;
      }

      setState(() {
        vacantes = data["vacantes"] ?? [];
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        errorMsg = "Excepción: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5C1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF01472B),
        title: const Text("Mis Vacantes", style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF01472B),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PublisherCreatePage()),
          ).then((_) => cargarVacantes());
        },
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg.isNotEmpty
              ? Center(
                  child: Text(
                    errorMsg,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : vacantes.isEmpty
                  ? const Center(
                      child: Text(
                        "No tienes vacantes publicadas",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: cargarVacantes,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: vacantes.length,
                        itemBuilder: (_, i) {
                          final v = vacantes[i] as Map<String, dynamic>;

                          return Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.green, width: 3),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  v["titulo"] ?? "",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF01472B),
                                  ),
                                ),

                                const SizedBox(height: 6),
                                Text("Empresa: ${v["empresa"] ?? ""}"),
                                Text("Ubicación: ${v["ubicacion"] ?? ""}"),
                                Text("Estado: ${v["estado"] ?? ""}"),

                                // 🔥🔥🔥 NUEVO: MOTIVO DEL RECHAZO (solo si existe)
                                if (v["motivo_rechazo"] != null &&
                                    v["motivo_rechazo"].toString().isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      "Motivo del rechazo: ${v["motivo_rechazo"]}",
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
