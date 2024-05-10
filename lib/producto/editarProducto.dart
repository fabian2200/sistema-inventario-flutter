import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sistema_inventario/http/productos.dart';
import 'package:sistema_inventario/http/response.dart';
import 'package:sistema_inventario/models/producto.dart';
import 'package:image/image.dart' as img;


class editarProducto extends StatefulWidget {
  final int productId;
  editarProducto({required this.productId});
  @override
  _editarProductoState createState() => _editarProductoState();
}

class _editarProductoState extends State<editarProducto> {
  
  late Producto producto =  Producto(0,"","","",0,0,0,"","");

  List<String> categorias = [];
  List<String> unidades = ["", "Unidades", "Gramos", "Libras", "Kilos"];
  late String selectedCategory = "";
  late String selectedUnidad = "";


  final ImagePicker _picker = ImagePicker();
  late String _base64Image = "";
  bool _imageSelected = false;

  TextEditingController _codigo_baras = TextEditingController();
  TextEditingController _descripcion = TextEditingController();
  TextEditingController _precio_compra = TextEditingController();
  TextEditingController _precio_venta = TextEditingController();
  TextEditingController _existencia = TextEditingController();

  bool cargando = true;
  @override
  void initState() {
    super.initState();
    _fetchCategorias();
    _fetchProducto(widget.productId);
  }

  Future<void> _fetchProducto(int productId) async {
    try {
      ProductosHTTP http = new ProductosHTTP();
      final response = await http.buscarProducto(widget.productId);
      dynamic data = response;
      setState(() {
        producto = Producto(
              data["id"],
              data["codigo_barras"],
              data["descripcion"],
              data["categoria"],
              double.parse(data["precio_compra"]),
              double.parse(data["precio_venta"]),
              double.parse(data["existencia"]),
              data["unidad_medida"],
              data["imagen"] ?? '');

        selectedCategory = data["categoria"];
        selectedUnidad = data["unidad_medida"];
        _codigo_baras.text = producto.codigo_barras;
        _descripcion.text = producto.descripcion;
        _precio_compra.text = producto.precio_compra.toString();
        _precio_venta.text = producto.precio_venta.toString();
        _existencia.text = producto.existencia.toString();
        cargando = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  _fetchCategorias() async {
    try {
      ProductosHTTP http = new ProductosHTTP();
      final response = await http.listarCategorias();
      List<String> data = response;
      setState(() {
        categorias = data;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getImageFromCamera() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
    List<int> imageBytes = await imageFile.readAsBytes();
    Uint8List uint8ImageBytes = Uint8List.fromList(imageBytes);
    img.Image? compressedImage = img.decodeImage(uint8ImageBytes);
    if (compressedImage != null) {
      img.Image smallerImage = img.copyResize(compressedImage, width: 600, height: 800);
      String compressedBase64 = base64Encode(img.encodePng(smallerImage));
      setState(() {
        _imageSelected = true;
        _base64Image = compressedBase64;
      });
    }
  }
}

  String _convertImageToBase64(String imagePath) {
    final bytes = File(imagePath).readAsBytesSync();
    return base64Encode(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 234, 250),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
          icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Container(
            padding: const EdgeInsets.only(left: 30),
            child: const Text("Información del producto"),
          ),
        ),
        body: cargando == false ? Padding(
          padding: EdgeInsets.all(26.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              producto.imagen != "" ? Center(
                child:  ClipOval(
                  child: Image.memory(
                    base64Decode(producto.imagen),
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                  ),
                )
              ) : GestureDetector(
                onTap: () {
                  _getImageFromCamera();
                },
                child: Center( 
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75), 
                    child: Container(
                      height: 150,
                      width: 150,
                      color: Color.fromARGB(255, 236, 194, 227),
                      child: _imageSelected
                          ? Image.memory(
                              Uint8List.fromList(base64Decode(_base64Image)),
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.photo_camera, size: 90, color: Color.fromARGB(255, 177, 52, 226)),
                    )
                  )
                )
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(labelText: 'Código de Barras', 
                  labelStyle: TextStyle(
                    color: Color(0xFF755DC1),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFF837E93),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFF9F7BFF),
                    ),
                  ),
                ),
                controller: _codigo_baras,
                enabled: true,
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(labelText: 'Descripción', 
                  labelStyle: TextStyle(
                    color: Color(0xFF755DC1),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFF837E93),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFF9F7BFF),
                    ),
                  ),
                ),
                controller: _descripcion,
                enabled: true,
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio de Compra',
                  labelStyle: TextStyle(
                    color: Color(0xFF755DC1),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFF837E93),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFF9F7BFF),
                    ),
                  ),
                ),
                controller: _precio_compra,
                enabled: true,
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Precio de Venta', 
                  labelStyle: TextStyle(
                    color: Color(0xFF755DC1),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFF837E93),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFF9F7BFF),
                    ),
                  ),
                ),
                controller: _precio_venta,
                enabled: true,
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Existencia', 
                  labelStyle: TextStyle(
                    color: Color(0xFF755DC1),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFF837E93),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFF9F7BFF),
                    ),
                  ),
                ),
                controller: _existencia,
                enabled: true,
              ),
              const SizedBox(height: 10),
              const Text("Unidad de medida", style: TextStyle(color: Color(0xFF755DC1), fontWeight: FontWeight.w800, fontSize: 12)),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedUnidad,
                items: unidades.map((String unidad_medida) {
                  return DropdownMenuItem<String>(
                    value: unidad_medida,
                    child: Text(unidad_medida),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedUnidad = newValue!;
                    producto.unidad_medida = selectedUnidad;
                  });
                },
              ),
              const SizedBox(height: 10),
              const Text("Categoria", style: TextStyle(color: Color(0xFF755DC1), fontWeight: FontWeight.w800, fontSize: 12)),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedCategory,
                items: categorias.map((String categoria) {
                  return DropdownMenuItem<String>(
                    value: categoria,
                    child: Text(categoria),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                    producto.categoria = selectedCategory;
                  });
                },
              ),
              Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 91, 19, 105)), // Change the color here
                  ),
                  onPressed: () => _editarProducto(context),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save, color: Colors.white),
                      SizedBox(width: 5),
                      Text("Guardar", style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              )
            ],
          ),
        ) : Container(
                width: double.infinity,
                height: 600,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(0xFF755DC1)),
                      backgroundColor: Color.fromARGB(255, 160, 159, 159),
                      strokeWidth: 7,
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Consultando el producto",
                      style:  TextStyle(
                        color: Color(0xFF755DC1),
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "espere...",
                      style:  TextStyle(
                        color: Color(0xFF755DC1),
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                )
              ) 
      ),
    );
  }

  Future<void> _editarProducto(BuildContext context) async{ 
    mostrarDialogo(context);

    ProductosHTTP productosHTTP = ProductosHTTP();
    ResponseHttp response =  await productosHTTP.EditarProducto(producto.id, _codigo_baras.text, _descripcion.text, selectedCategory, _precio_compra.text, _precio_venta.text, _existencia.text, selectedUnidad, _base64Image);
    cerrarDialogo(context);
    if(response.success == 1){
       showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 100,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.check_circle, size: 50, color: Colors.green),
                    SizedBox(height: 20),
                    Text('Producto modificado correctamente'),
                  ],
                ),
              ),
            ),
          );
        }
      );

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop(); 
      });
      
    }else{
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 500,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.error, size: 50, color: Colors.red),
                    const SizedBox(height: 20),
                    Text('Ocurrió un error: ${response.mensaje}'),
                  ],
                ),
              ),
            ),
          );
        }
      );

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop(); 
      });
    }
  }

  mostrarDialogo(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 100,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(), 
                  SizedBox(height: 20),
                  Text('Cargando...'),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  cerrarDialogo(BuildContext context){
    Navigator.of(context).pop();
  }
}