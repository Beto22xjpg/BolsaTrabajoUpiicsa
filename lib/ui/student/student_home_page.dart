// lib/ui/student/student_home_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_job_detail_page.dart';
import '../student/student_profile_page.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  List<Map<String, String>> allJobs = [];
  List<Map<String, String>> filtered = [];
  bool loading = true;
  String errorMsg = "";

  // filtros
  String? selectedCategoria;
  String? selectedModalidad;
  String? selectedHorario;
  String? selectedUbicacion;
  String? selectedTipo;
  String searchQuery = "";

  final String apiListUrl =
      "http://192.168.0.92/bolsa_api/api.php?endpoint=vacantes&action=list";

  @override
  void initState() {
    super.initState();
    fetchVacantes();
  }

  Future<void> fetchVacantes() async {
    setState(() {
      loading = true;
      errorMsg = "";
    });

    try {
      final res =
          await http.get(Uri.parse(apiListUrl)).timeout(const Duration(seconds: 10));

      if (res.statusCode != 200) {
        setState(() {
          loading = false;
          errorMsg = "Error HTTP: ${res.statusCode}";
        });
        return;
      }

      dynamic data;
      try {
        data = json.decode(res.body);
      } catch (_) {
        setState(() {
          loading = false;
          errorMsg = "Respuesta inválida del servidor";
        });
        return;
      }

      if (data["error"] == true) {
        setState(() {
          loading = false;
          errorMsg = data["mensaje"] ?? "Error en API";
        });
        return;
      }

      final raw = data["vacantes"] ?? [];

      allJobs = List.from(raw).map<Map<String, String>>((r) {
        final map = <String, String>{};
        (r as Map).forEach((k, v) {
          map[k.toString()] = v?.toString() ?? "";
        });
        return map;
      }).toList();

      // Filtrar aprobadas
      allJobs = allJobs
          .where((j) => (j["estado"] ?? "").toLowerCase() == "aprobada")
          .toList();

      applyFilters();
      setState(() => loading = false);
    } catch (e) {
      setState(() {
        loading = false;
        errorMsg = "Error: $e";
      });
    }
  }

  void applyFilters() {
    setState(() {
      filtered = allJobs.where((job) {
        final text = "${job["titulo"] ?? ""} ${job["empresa"] ?? ""}";
        final searchOk = searchQuery.isEmpty ||
            text.toLowerCase().contains(searchQuery.toLowerCase());

        final c = selectedCategoria == null || job["categoria"] == selectedCategoria;
        final m = selectedModalidad == null || job["modalidad"] == selectedModalidad;
        final h = selectedHorario == null || job["horario"] == selectedHorario;
        final u = selectedUbicacion == null || job["ubicacion"] == selectedUbicacion;
        final t = selectedTipo == null || job["tipo"] == selectedTipo;

        return searchOk && c && m && h && u && t;
      }).toList();
    });
  }

  // PANEL DE FILTROS
  void openFilterPanel() {
    final categorias = <String>{};
    final modalidades = <String>{};
    final horarios = <String>{};
    final ubicaciones = <String>{};
    final tipos = <String>{};

    for (final j in allJobs) {
      if ((j["categoria"] ?? "").isNotEmpty) categorias.add(j["categoria"]!);
      if ((j["modalidad"] ?? "").isNotEmpty) modalidades.add(j["modalidad"]!);
      if ((j["horario"] ?? "").isNotEmpty) horarios.add(j["horario"]!);
      if ((j["ubicacion"] ?? "").isNotEmpty) ubicaciones.add(j["ubicacion"]!);
      if ((j["tipo"] ?? "").isNotEmpty) tipos.add(j["tipo"]!);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF3E5C1),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text("Filtros",
                        style: TextStyle(
                            color: Color(0xFF01472B),
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          selectedCategoria = null;
                          selectedModalidad = null;
                          selectedHorario = null;
                          selectedUbicacion = null;
                          selectedTipo = null;
                        });
                      },
                      child: const Text("Limpiar"),
                    )
                  ],
                ),
                _dropdown("Categoría", categorias.toList(), selectedCategoria,
                    (v) => setModalState(() => selectedCategoria = v)),
                _dropdown("Modalidad", modalidades.toList(), selectedModalidad,
                    (v) => setModalState(() => selectedModalidad = v)),
                _dropdown("Horario", horarios.toList(), selectedHorario,
                    (v) => setModalState(() => selectedHorario = v)),
                _dropdown("Ubicación", ubicaciones.toList(), selectedUbicacion,
                    (v) => setModalState(() => selectedUbicacion = v)),
                _dropdown("Tipo", tipos.toList(), selectedTipo,
                    (v) => setModalState(() => selectedTipo = v)),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF01472B)),
                  onPressed: () {
                    applyFilters();
                    Navigator.pop(context);
                  },
                  child: const Text("Aplicar"),
                )
              ],
            ),
          );
        });
      },
    );
  }

  Widget _dropdown(String label, List<String> items, String? value,
      Function(String?) onChanged) {
    items.sort();
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: DropdownButton<String>(
        value: value,
        hint: Text(label),
        isExpanded: true,
        underline: const SizedBox(),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  // CARD DE VACANTE
  Widget _jobCard(job) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF01472B), width: 2),
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                color: const Color(0xFFDFAE3B),
                borderRadius: BorderRadius.circular(12)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job["titulo"] ?? "",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF01472B))),
                const SizedBox(height: 5),
                Text(job["empresa"] ?? ""),
                const SizedBox(height: 5),
                Text("${job["modalidad"] ?? ""} - ${job["ubicacion"] ?? ""}",
                    style: const TextStyle(fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ===============================================
  //                   UI
  // ===============================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5C1),
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF01472B),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text("Oportunidades Laborales",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                          onPressed: openFilterPanel,
                          icon: const Icon(Icons.filter_list,
                              color: Colors.white),
                          tooltip: "Filtros"),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const StudentProfilePage()),
                          );
                        },
                        icon:
                            const Icon(Icons.person, color: Colors.white, size: 28),
                        tooltip: "Perfil",
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: const Color(0xFFA5C99B),
                        borderRadius: BorderRadius.circular(14)),
                    child: TextField(
                      onChanged: (v) {
                        searchQuery = v;
                        applyFilters();
                      },
                      decoration: const InputDecoration(
                          hintText: "Buscar vacante",
                          border: InputBorder.none,
                          prefixIcon:
                              Icon(Icons.search, color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMsg.isNotEmpty
                      ? Center(
                          child: Text(errorMsg,
                              style: const TextStyle(color: Colors.red)))
                      : RefreshIndicator(
                          onRefresh: fetchVacantes,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            itemCount: filtered.length,
                            itemBuilder: (_, i) {
                              final job = filtered[i];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              JobDetailPage(job: job)));
                                },
                                child: _jobCard(job),
                              );
                            },
                          ),
                        ),
            )
          ],
        ),
      ),
    );
  }
}
