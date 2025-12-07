import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_user_edit.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  List<Map<String, String>> users = [];
  final String apiUrl = "http://192.168.0.92/bolsa_api/api.php?endpoint=usuarios&action=";
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() => loading = true);
    try {
      final res = await http.get(Uri.parse("${apiUrl}list")).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        dynamic data;
        try {
          data = jsonDecode(res.body);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Respuesta inválida listar usuarios: ${res.body}")),
          );
          setState(() {
            users = [];
            loading = false;
          });
          return;
        }

        if (data["error"] == false && data["usuarios"] != null) {
          final raw = List.from(data["usuarios"]);
          setState(() {
            users = raw.map<Map<String, String>>((u) {
              // Convertir todos los campos a String para evitar problemas en UI
              return u.map<String, String>((k, v) => MapEntry(k.toString(), v.toString()));
            }).toList();
          });
        } else {
          setState(() => users = []);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No fue posible listar usuarios: ${data["mensaje"] ?? "Sin detalle"}")),
          );
        }
      } else {
        setState(() => users = []);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error HTTP listar usuarios: ${res.statusCode}")),
        );
      }
    } catch (e) {
      setState(() => users = []);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Excepción listar usuarios: $e")));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      final res = await http.post(Uri.parse("${apiUrl}delete"), body: {"id": id}).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        dynamic data;
        try {
          data = jsonDecode(res.body);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Respuesta inválida al eliminar: ${res.body}")));
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["mensaje"] ?? "Respuesta del servidor")));
        if (data["error"] == false) fetchUsers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error HTTP al eliminar: ${res.statusCode}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Excepción delete: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5C1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF01472B),
        title: const Text("Administración de Usuarios", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchUsers,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF01472B),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminUserEdit(isEditing: false)),
          );
          if (result == true) fetchUsers();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.group_off, size: 56, color: Colors.grey),
                      SizedBox(height: 12),
                      Text("No hay usuarios para mostrar", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchUsers,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: users.length,
                    itemBuilder: (_, i) {
                      final user = users[i];
                      return Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF01472B), width: 2),
                        ),
                        child: ListTile(
                          title: Text(user["nombre"] ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF01472B),
                                  fontSize: 18)),
                          subtitle: Text("${user["correo"] ?? ""}\nRol: ${user["rol"] ?? ""}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 28),
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AdminUserEdit(isEditing: true, user: user),
                                    ),
                                  );
                                  if (result == true) fetchUsers();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 28, color: Colors.red),
                                onPressed: () {
                                  if ((user["rol"] ?? "") == "Administrador") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("No se puede eliminar un administrador")),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("Confirmar"),
                                        content: Text("¿Desea eliminar al usuario ${user["nombre"] ?? ""}?"),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
                                          TextButton(onPressed: () {
                                            Navigator.pop(context);
                                            deleteUser(user["id"] ?? "");
                                          }, child: const Text("Eliminar")),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
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
