// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_inventario/http/response.dart';


class ProveedoresHTTP {
  Future<List<dynamic>> listarProveedores(String des) async {
    List<dynamic> proveedores = [];

    SharedPreferences pref = await SharedPreferences.getInstance();
    var ip =  pref.getString('ip');

    final link = Uri.parse("http://"+ip.toString()+":8000/listar-proveedores?des="+des);
    final response = await http.get(link);
    if (response.statusCode != 200) {
      proveedores = [];
    } else {
      var json = convert.jsonDecode(response.body);
      final length = json.length;
      if (length > 0) {
        proveedores = json;
      }
    }
    return proveedores;
  }

  Future<ResponseHttp> registrarProveedor(nombreProveedor) async {
    Dio dio = Dio();
    ResponseHttp responseHttp = ResponseHttp("", 0);
    SharedPreferences pref = await SharedPreferences.getInstance();
    
    var ip =  pref.getString('ip');
    final link = "http://"+ip.toString()+":8000/registrar-proveedor-movil";

    Map<String, dynamic> data = {
      "nombre": nombreProveedor
    };

    try {
      Response response = await dio.post(
        link,
        data: convert.jsonEncode(data),
        options: Options(
          headers: {
            "Content-Type": "application/json; charset=UTF-8"
          }
        )
      );
      
      var json = convert.jsonDecode(response.toString());
      responseHttp.mensaje = json["mensaje"];
      responseHttp.success = json["success"];
    } catch (error) {
      responseHttp.mensaje = error.toString();
      responseHttp.success = 0;
    }

    return responseHttp;
  }

  Future<ResponseHttp> editarProveedor(id, nombreProveedor) async {
    Dio dio = Dio();
    ResponseHttp responseHttp = ResponseHttp("", 0);
    SharedPreferences pref = await SharedPreferences.getInstance();
    
    var ip =  pref.getString('ip');
    final link = "http://"+ip.toString()+":8000/editar-proveedor-movil";

    Map<String, dynamic> data = {
      "id": id,
      "nombre": nombreProveedor
    };

    try {
      Response response = await dio.post(
        link,
        data: convert.jsonEncode(data),
        options: Options(
          headers: {
            "Content-Type": "application/json; charset=UTF-8"
          }
        )
      );
      
      var json = convert.jsonDecode(response.toString());
      responseHttp.mensaje = json["mensaje"];
      responseHttp.success = json["success"];
    } catch (error) {
      responseHttp.mensaje = error.toString();
      responseHttp.success = 0;
    }

    return responseHttp;
  }

  Future<ResponseHttp> eliminar(id) async {
    Dio dio = Dio();
    ResponseHttp responseHttp = ResponseHttp("", 0);
    SharedPreferences pref = await SharedPreferences.getInstance();
    
    var ip =  pref.getString('ip');
    final link = "http://"+ip.toString()+":8000/eliminar-proveedor-movil?id="+id;

    
    try {
      Response response = await dio.get(link);
      var json = convert.jsonDecode(response.toString());
      responseHttp.mensaje = json["mensaje"];
      responseHttp.success = json["success"];
    } catch (error) {
      responseHttp.mensaje = error.toString();
      responseHttp.success = 0;
    }

    return responseHttp;
  }
}