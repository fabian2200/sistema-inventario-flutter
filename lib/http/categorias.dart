// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_inventario/http/response.dart';


class CategoriasHTTP {
  Future<List<dynamic>> listarCategorias(String des) async {
    List<dynamic> categorias = [];

    SharedPreferences pref = await SharedPreferences.getInstance();
    var ip =  pref.getString('ip');

    final link = Uri.parse("http://"+ip.toString()+":8000/listar-categorias?des="+des);
    final response = await http.get(link);
    if (response.statusCode != 200) {
      categorias = [];
    } else {
      var json = convert.jsonDecode(response.body);
      final length = json.length;
      if (length > 0) {
        categorias = json;
      }
    }
    return categorias;
  }

  Future<ResponseHttp> registrarCategoria(nombreCategoria) async {
    Dio dio = Dio();
    ResponseHttp responseHttp = ResponseHttp("", 0);
    SharedPreferences pref = await SharedPreferences.getInstance();
    
    var ip =  pref.getString('ip');
    final link = "http://"+ip.toString()+":8000/registrar-categoria-movil?nombre="+nombreCategoria;

    await dio.get(link).then((value) {
      var json = convert.jsonDecode(value.toString());
      responseHttp.mensaje = json["mensaje"];
      responseHttp.success = json["success"];
    }).onError((error, stackTrace) {
      responseHttp.mensaje = error.toString();
      responseHttp.success = 0;
    });

    return responseHttp;
  }
}