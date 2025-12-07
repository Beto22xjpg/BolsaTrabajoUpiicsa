import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../student/student_home_page.dart'; // Estudiante
import '../publisher/publisher_layout.dart';
import '../validator/validator_layout.dart';
import '../admin/admin_layout.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  bool loading = false;
  String errorMsg = "";

  // Cambia esta URL por la de tu PC si es necesario
  final String apiUrl = "http://192.168.0.92/bolsa_api/api.php?endpoint=login";

  Future<void> login() async {
    setState(() {
      loading = true;
      errorMsg = "";
    });

    final correo = emailCtrl.text.trim();
    final password = passCtrl.text.trim();

    if (correo.isEmpty || password.isEmpty) {
      setState(() {
        loading = false;
        errorMsg = "Ingresa correo y contraseña";
      });
      return;
    }

    try {
      final url = Uri.parse(apiUrl);
      final response = await http.post(url, body: {
        "correo": correo,
        "password": password, // tu API espera "password"
      });

      if (response.statusCode != 200) {
        setState(() {
          loading = false;
          errorMsg = "Error de conexión con el servidor (${response.statusCode})";
        });
        return;
      }

      // Depuración en consola (útil)
      // print("RESPUESTA: ${response.body}");

      dynamic data;
      try {
        data = json.decode(response.body);
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
          errorMsg = data["mensaje"] ?? "Error en servidor";
        });
        return;
      }

      // Guardar sesión — aseguramos keys correctas
      final id = data["id"];
      final rol = (data["rol"] ?? "").toString();
      final nombre = (data["nombre"] ?? "").toString();

      AuthService.userId = (id is int) ? id : int.tryParse(id.toString());
      AuthService.role = rol;
      AuthService.name = nombre;

      // Redirección según rol (normalizamos a minúsculas)
      final roleLower = AuthService.role?.toLowerCase() ?? "";

      setState(() => loading = false);

      if (roleLower == "estudiante") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      } else if (roleLower == "publicador") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PublisherLayout()));
      } else if (roleLower == "validador") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ValidatorLayout()));
      } else if (roleLower == "administrador") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminLayout()));
      } else {
        setState(() => errorMsg = "Rol desconocido en el servidor: ${AuthService.role}");
      }
    } catch (e) {
      setState(() {
        loading = false;
        errorMsg = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5C1),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bolsa UPIICSA",
              style: TextStyle(
                color: Color(0xFF01472B),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            _input("Correo institucional", emailCtrl),
            const SizedBox(height: 15),
            _input("Contraseña", passCtrl, isPass: true),
            const SizedBox(height: 20),
            if (errorMsg.isNotEmpty)
              Text(errorMsg, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF01472B),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: loading ? null : login,
                child: loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Iniciar Sesión", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController controller, {bool isPass = false}) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
