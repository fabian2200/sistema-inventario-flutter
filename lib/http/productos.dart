// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_inventario/http/response.dart';


class ProductosHTTP {
  Future<List<dynamic>> listarProductos(int page, int perpage, String des) async {
    List<dynamic> productos = [];

    SharedPreferences pref = await SharedPreferences.getInstance();
    var ip =  pref.getString('ip');

    final link = Uri.parse("http://"+ip.toString()+":8000/productos-paginados?page="+page.toString()+"&perpage="+perpage.toString()+"&des="+des+"");
    final response = await http.get(link);
    if (response.statusCode != 200) {
      productos = [];
    } else {
      var json = convert.jsonDecode(response.body);
      final length = json.length;
      if (length > 0) {
        productos = json;
      }
    }
    return productos;
  }

  Future<dynamic> buscarProducto(int id) async {
    dynamic producto;

    SharedPreferences pref = await SharedPreferences.getInstance();
    var ip =  pref.getString('ip');
    final link = Uri.parse("http://"+ip.toString()+":8000/producto-id?id="+id.toString());
    final response = await http.get(link);
    var json = convert.jsonDecode(response.body);
    producto = json;
    return producto;
  }

  Future<List<String>> listarCategorias() async {
    List<String> categorias = [''];
    SharedPreferences pref = await SharedPreferences.getInstance();
    var ip =  pref.getString('ip');
    final link = Uri.parse("http://"+ip.toString()+":8000/listar-categorias");
    final response = await http.get(link);
    var json = convert.jsonDecode(response.body);
    for (var item in json) {
      categorias.add(item["nombre"]);
    }
    return categorias;
  }

  Future<ResponseHttp> EditarProducto(id, codigo_barras, descripcion, categoria, precio_compra, precio_venta, existencia, unidad_medida, imagen) async {
    Dio dio = Dio();

    ResponseHttp responseHttp = ResponseHttp("", 0);

    Map<String, dynamic> datos = {
      'id': id,
      'codigo_barras': codigo_barras,
      'descripcion': descripcion,
      'categoria': categoria,
      'precio_compra': precio_compra,
      'precio_venta': precio_venta,
      'existencia': existencia,
      'unidad_medida': unidad_medida,
      'imagen': imagen
    };

    SharedPreferences pref = await SharedPreferences.getInstance();
    var ip =  pref.getString('ip');
    final link = "http://"+ip.toString()+":8000/editar-producto-movil";

    await dio.post(
      link, data: datos,
      options: Options(
        contentType: 'application/json',
      ),
    ).then((value) {
      var json = convert.jsonDecode(value.toString());
      responseHttp.mensaje = json["mensaje"];
      responseHttp.success = json["success"];
    }).onError((error, stackTrace) {
      responseHttp.mensaje = error.toString();
      responseHttp.success = 0;
    });

    return responseHttp;
  }

  Future<dynamic> buscarProductoCB(String cb) async {
    dynamic producto;

    SharedPreferences pref = await SharedPreferences.getInstance();
    var ip =  pref.getString('ip');
    final link = Uri.parse("http://"+ip.toString()+":8000/producto-cb?cb="+cb.toString());
    final response = await http.get(link);
    var json = convert.jsonDecode(response.body);
    producto = json;
    return producto;
  }

  Future<ResponseHttp> EditarInventarioProducto(existencia, precio_compra, precio_venta, existencia2, controllerCB) async {
    Dio dio = Dio();

    ResponseHttp responseHttp = ResponseHttp("", 0);

    Map<String, dynamic> datos = {
      'cantidad_disponible': existencia,
      'precio_compra': precio_compra,
      'precio_venta': precio_venta,
      'nueva_cantidad': existencia2,
      'codigo_producto': controllerCB
    };

    SharedPreferences pref = await SharedPreferences.getInstance();
    var ip =  pref.getString('ip');
    final link = "http://"+ip.toString()+":8000/editar-inventario-movil";

    await dio.post(
      link, data: datos,
      options: Options(
        contentType: 'application/json',
      ),
    ).then((value) {
      var json = convert.jsonDecode(value.toString());
      responseHttp.mensaje = json["mensaje"];
      responseHttp.success = json["success"];
    }).onError((error, stackTrace) {
      responseHttp.mensaje = error.toString();
      responseHttp.success = 0;
    });

    return responseHttp;
  }

  Future<ResponseHttp> registrarProducto(codigo_barras, descripcion, categoria, precio_compra, precio_venta, existencia, unidad_medida, imagen) async {
    Dio dio = Dio();

    ResponseHttp responseHttp = ResponseHttp("", 0);

    Map<String, dynamic> datos = {
      'codigo_barras': codigo_barras,
      'descripcion': descripcion,
      'categoria': categoria,
      'precio_compra': precio_compra,
      'precio_venta': precio_venta,
      'existencia': existencia,
      'unidad_medida': unidad_medida,
      'imagen': imagen
    };

    SharedPreferences pref = await SharedPreferences.getInstance();
    var ip =  pref.getString('ip');
    final link = "http://"+ip.toString()+":8000/registrar-producto-movil";

    await dio.post(
      link, data: datos,
      options: Options(
        contentType: 'application/json',
      ),
    ).then((value) {
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