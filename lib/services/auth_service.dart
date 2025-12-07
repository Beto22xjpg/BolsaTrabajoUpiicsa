// Servicio simple para mantener la sesión en memoria durante la ejecución.
// No usa persistent storage (por ahora). Puedes expandirlo con SharedPreferences si quieres.

class AuthService {
  AuthService._();

  static int? userId;
  static String? role;
  static String? name;
  static String? token; // si luego usas JWT

  static void clear() {
    userId = null;
    role = null;
    name = null;
    token = null;
  }

  static bool get isLogged => userId != null;
}
