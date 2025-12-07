// lib/ui/student/home_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_job_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  // endpoint (asegúrate que devuelve JSON con "error":false, "vacantes":[...])
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
      final res = await http.get(Uri.parse(apiListUrl)).timeout(const Duration(seconds: 10));
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
      } catch (e) {
        setState(() {
          loading = false;
          errorMsg = "Respuesta inválida del servidor";
        });
        return;
      }

      if (data is Map && data["error"] == true) {
        setState(() {
          loading = false;
          errorMsg = data["mensaje"] ?? "Error en API";
        });
        return;
      }

      final raw = data["vacantes"] ?? [];
      // Convertir a List<Map<String,String>>
      allJobs = List.from(raw).map<Map<String, String>>((r) {
        final map = <String, String>{};
        (r as Map).forEach((k, v) {
          map[k.toString()] = v?.toString() ?? "";
        });
        return map;
      }).toList();

      // Aplicar solo vacantes aprobadas por seguridad (si tu API ya filtra, está bien)
      allJobs = allJobs.where((j) => (j["estado"] ?? "").toLowerCase() == "aprobada").toList();

      applyFilters(); // filtrado inicial
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        errorMsg = "Error: ${e.toString()}";
      });
    }
  }

  void applyFilters() {
    setState(() {
      filtered = allJobs.where((job) {
        final tv = (job["titulo"] ?? "") + " " + (job["empresa"] ?? "");
        final matchesSearch = searchQuery.trim().isEmpty ||
            tv.toLowerCase().contains(searchQuery.toLowerCase());

        final catOk = selectedCategoria == null || job["categoria"] == selectedCategoria;
        final modOk = selectedModalidad == null || job["modalidad"] == selectedModalidad;
        final horOk = selectedHorario == null || job["horario"] == selectedHorario;
        final ubiOk = selectedUbicacion == null || job["ubicacion"] == selectedUbicacion;
        final tipOk = selectedTipo == null || job["tipo"] == selectedTipo;

        return matchesSearch && catOk && modOk && horOk && ubiOk && tipOk;
      }).toList();
    });
  }

  // abre modal con filtros (dropdowns poblados con valores únicos presentes)
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
      builder: (_) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              color: const Color(0xFFF3E5C1),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text("Filtros", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF01472B))),
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

                  _buildDropdownInModal("Categoría", categorias.toList(), selectedCategoria, (v) {
                    setModalState(() => selectedCategoria = v);
                  }),
                  _buildDropdownInModal("Modalidad", modalidades.toList(), selectedModalidad, (v) {
                    setModalState(() => selectedModalidad = v);
                  }),
                  _buildDropdownInModal("Horario", horarios.toList(), selectedHorario, (v) {
                    setModalState(() => selectedHorario = v);
                  }),
                  _buildDropdownInModal("Ubicación", ubicaciones.toList(), selectedUbicacion, (v) {
                    setModalState(() => selectedUbicacion = v);
                  }),
                  _buildDropdownInModal("Tipo", tipos.toList(), selectedTipo, (v) {
                    setModalState(() => selectedTipo = v);
                  }),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            applyFilters();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF01472B)),
                          child: const Text("Aplicar"),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildDropdownInModal(String label, List<String> items, String? value, Function(String?) onChanged) {
    final sorted = items.toList()..sort();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: DropdownButton<String>(
          value: value,
          hint: Text(label, style: const TextStyle(color: Color(0xFF01472B))),
          isExpanded: true,
          underline: const SizedBox(),
          items: sorted.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _jobCard(Map<String, String> job) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF7D1A21), width: 3),
      ),
      child: Row(
        children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(color: const Color(0xFFDFAE3B), borderRadius: BorderRadius.circular(12)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(job["titulo"] ?? job["title"] ?? "", style: const TextStyle(color: Color(0xFF01472B), fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(job["empresa"] ?? job["company"] ?? ""),
              const SizedBox(height: 6),
              Text("${job["modalidad"] ?? ""} | ${job["horario"] ?? ""}"),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5C1),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Color(0xFF01472B)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text("Oportunidades Laborales", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                      onPressed: openFilterPanel,
                      icon: const Icon(Icons.menu, color: Colors.white),
                      tooltip: "Filtros",
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 50,
                  decoration: BoxDecoration(color: const Color(0xFFA5C99B), borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    onChanged: (v) {
                      searchQuery = v;
                      applyFilters();
                    },
                    decoration: const InputDecoration(border: InputBorder.none, prefixIcon: Icon(Icons.search, color: Colors.black), hintText: "Buscar vacante"),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 10),
            if (loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (errorMsg.isNotEmpty)
              Expanded(child: Center(child: Text(errorMsg, style: const TextStyle(color: Colors.red))))
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: fetchVacantes,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final job = filtered[i];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => JobDetailPage(job: job)));
                        },
                        child: _jobCard(job),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
