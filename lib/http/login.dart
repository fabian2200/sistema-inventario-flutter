import 'package:shared_preferences/shared_preferences.dart';

class Login {
  String usuario;
  String password;

  Login(this.usuario, this.password);

  Future<dynamic> loguear() async {
    dynamic respuesta = {};
    if (usuario == "admin" && password == "admin2024") {
      respuesta["mensaje"] = "Bienvenido";
      respuesta["success"] = 1;
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.clear();
      await pref.setInt('tipo', 1);
    } else {
      respuesta["mensaje"] = "Usuario/Contraseña Incorrecto";
      respuesta["success"] = 0;
    }
    return respuesta;
  }
}
