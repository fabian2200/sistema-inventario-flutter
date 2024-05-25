// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';


class ventasHTTP {
  Future<List<dynamic>> listarVentas(String des) async {
    List<dynamic> ventas = [];

    SharedPreferences pref = await SharedPreferences.getInstance();
    var ip =  pref.getString('ip');

    final link = Uri.parse("http://"+ip.toString()+":8000/listar-ventas-movil?des="+des);
    final response = await http.get(link);
    if (response.statusCode != 200) {
      ventas = [];
    } else {
      var json = convert.jsonDecode(response.body);
      final length = json.length;
      if (length > 0) {
        ventas = json;
      }
    }
    return ventas;
  }


  Future<dynamic> imprimir(String id, String ip_impresora) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var ip =  pref.getString('ip');
    final link = Uri.parse("http://"+ip.toString()+":8000/imprimir-movil?id_venta="+id+"&ip_impresora="+ip_impresora);
    dynamic response = await http.get(link);
    if (response.statusCode == 200) {
      return {
        'success': 1,
        'mensaje': 'Impresión realizada con éxito'
      };
    } else {
      String errorMessage = 'Error al realizar la impresión';
      if(response.statusCode == 404) {
        errorMessage += ': Recurso no encontrado';
      } else if(response.statusCode == 500) {
        errorMessage += ': Error interno del servidor';
      } else {
        errorMessage += ': Código de estado ' + response.statusCode.toString();
      }
      
      return {
        'success': 0,
        'mensaje': errorMessage
      };
    }
  }

  Future<List<dynamic>> listarImpresoras() async {
    List<dynamic> impresoras = [];

    SharedPreferences pref = await SharedPreferences.getInstance();
    var ip =  pref.getString('ip');

    final link = Uri.parse("http://"+ip.toString()+":8000/impresoras-movil");
    final response = await http.get(link);
    if (response.statusCode != 200) {
      impresoras = [];
    } else {
      var json = convert.jsonDecode(response.body);
      final length = json.length;
      if (length > 0) {
        impresoras = json;
      }
    }
    return impresoras;
  }

   Future<dynamic> infoVenta(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var ip =  pref.getString('ip');
    final link = Uri.parse("http://"+ip.toString()+":8000/detalle-venta-movil?id_venta="+id);
    dynamic response = await http.get(link);
    if (response.statusCode == 200) {
      return {
        'success': 1,
        'objeto': convert.jsonDecode(response.body)
      };
    } else {
      String errorMessage = 'Error, intente mas tarde';
      if(response.statusCode == 404) {
        errorMessage += ': Recurso no encontrado';
      } else if(response.statusCode == 500) {
        errorMessage += ': Error interno del servidor';
      } else {
        errorMessage += ': Código de estado ' + response.statusCode.toString();
      }
      
      return {
        'success': 0,
        'mensaje': errorMessage
      };
    }
  }
}