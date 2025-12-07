import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminUserEdit extends StatefulWidget {
  final bool isEditing;
  final Map<String, String>? user;

  const AdminUserEdit({super.key, required this.isEditing, this.user});

  @override
  State<AdminUserEdit> createState() => _AdminUserEditState();
}

class _AdminUserEditState extends State<AdminUserEdit> {
  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController correoCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  // roles fijos — si el servidor devuelve otro rol, lo añadimos dinámicamente
  final List<String> roles = ["Estudiante", "Publicador", "Validador", "Administrador"];
  String rolSeleccionado = "Estudiante";

  final String apiUrl = "http://192.168.0.92/bolsa_api/api.php?endpoint=usuarios&action=";

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.user != null) {
      nombreCtrl.text = widget.user!["nombre"] ?? "";
      correoCtrl.text = widget.user!["correo"] ?? "";
      String r = widget.user!["rol"] ?? "Estudiante";

      // Si el rol recibido no está en la lista, lo agregamos (evita errores de Dropdown)
      if (!roles.contains(r)) {
        roles.add(r);
      }
      rolSeleccionado = r;
    }
  }

  bool _validarEmailInstitucional(String email) {
    final pattern = RegExp(r'^[\w\.-]+@alumno\.ipn\.mx$');
    return pattern.hasMatch(email);
  }

  Future<void> guardarUsuario() async {
    final nombre = nombreCtrl.text.trim();
    final correo = correoCtrl.text.trim();
    final password = passwordCtrl.text;

    // Validaciones cliente
    if (nombre.isEmpty || correo.isEmpty || (!widget.isEditing && password.isEmpty)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Todos los campos obligatorios")));
      return;
    }

    if (!_validarEmailInstitucional(correo)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("El correo debe ser *@alumno.ipn.mx")));
      return;
    }

    final uri = Uri.parse(apiUrl + (widget.isEditing ? "update" : "create"));

    final body = <String, String>{
      "nombre": nombre,
      "correo": correo,
      "rol": rolSeleccionado,
    };

    if (!widget.isEditing || password.isNotEmpty) {
      body["password"] = password;
    }

    if (widget.isEditing) {
      // id obligatorio para update — convertir a string vacía si es null (servidor lo validará)
      body["id"] = widget.user?["id"]?.toString() ?? "";
    }

    try {
      final res = await http.post(uri, body: body).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error HTTP: ${res.statusCode}")));
        return;
      }

      // Intentamos decodificar JSON; si falla, mostramos la respuesta cruda para depuración
      dynamic data;
      try {
        data = jsonDecode(res.body);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Respuesta inesperada del servidor: ${res.body}")));
        return;
      }

      // Mostrar mensaje y cerrar si éxito
      final mensaje = data["mensaje"] ?? "Respuesta recibida";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));

      if (data["error"] == false) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error de conexión: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5C1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF01472B),
        title: Text(widget.isEditing ? "Editar Usuario" : "Nuevo Usuario",
            style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _input("Nombre completo", nombreCtrl),
            const SizedBox(height: 15),
            _input("Correo institucional (@alumno.ipn.mx)", correoCtrl),
            const SizedBox(height: 15),
            _input("Contraseña", passwordCtrl,
                obscure: true,
                hintText: widget.isEditing ? "Dejar vacío para no cambiar" : null),
            const SizedBox(height: 20),
            _roleDropdown(),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: guardarUsuario,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF01472B), padding: const EdgeInsets.all(15)),
                child: const Text("Guardar",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF01472B), width: 2),
      ),
      child: DropdownButton<String>(
        value: rolSeleccionado,
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: const SizedBox(),
        items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
        onChanged: (v) {
          if (v == null) return;
          setState(() => rolSeleccionado = v);
        },
      ),
    );
  }

  Widget _input(String label, TextEditingController controller,
      {bool obscure = false, String? hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 16, color: Color(0xFF01472B), fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
