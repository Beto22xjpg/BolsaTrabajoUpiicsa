import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'validator_detail_page.dart';

class ValidatorHomePage extends StatefulWidget {
  const ValidatorHomePage({super.key});

  @override
  State<ValidatorHomePage> createState() => _ValidatorHomePageState();
}

class _ValidatorHomePageState extends State<ValidatorHomePage> {
  List<dynamic> vacantes = [];
  bool loading = true;
  String errorMsg = "";

  final String apiBase =
      "http://192.168.0.92/bolsa_api/api.php?endpoint=vacantes&action=list_pending";

  @override
  void initState() {
    super.initState();
    cargarPendientes();
  }

  Future<void> cargarPendientes() async {
    setState(() {
      loading = true;
      errorMsg = "";
    });

    final url = Uri.parse(apiBase);

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
          errorMsg = data["mensaje"] ?? "Error del servidor";
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
        title: const Text("Vacantes Pendientes", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: cargarPendientes,
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg.isNotEmpty
              ? Center(child: Text(errorMsg, style: const TextStyle(color: Colors.red)))
              : vacantes.isEmpty
                  ? const Center(child: Text("No hay vacantes pendientes", style: TextStyle(fontSize: 18)))
                  : RefreshIndicator(
                      onRefresh: cargarPendientes,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(), 
                        padding: const EdgeInsets.all(20),
                        itemCount: vacantes.length,
                        itemBuilder: (_, i) {
                          final v = vacantes[i] as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => ValidatorDetailPage(vacante: v)),
                              );
                              if (result == true) cargarPendientes();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.orange, width: 3),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(v["titulo"] ?? "", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF01472B))),
                                        const SizedBox(height: 6),
                                        Text("Empresa: ${v["empresa"] ?? ""}"),
                                        Text("Ubicación: ${v["ubicacion"] ?? ""}"),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right, size: 30),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
