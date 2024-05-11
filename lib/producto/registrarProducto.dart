import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:sistema_inventario/http/productos.dart';
import 'package:sistema_inventario/http/response.dart';
import 'package:image/image.dart' as img;


class registrarProducto extends StatefulWidget {
  const registrarProducto({Key? key}) : super(key: key);
  @override
  State<registrarProducto> createState() => _registrarProductoState();
}

class _registrarProductoState extends State<registrarProducto> {

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

  @override
  void initState() {
    super.initState();
    _fetchCategorias();
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
    return Scaffold(
      extendBodyBehindAppBar : false,
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
            child: const Text("Registrar producto"),
          ),
        ),
      body: Padding(
          padding: const EdgeInsets.all(26.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  _getImageFromCamera();
                },
                child: Center( 
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75), 
                    child: Container(
                      height: 150,
                      width: 150,
                      color: const Color.fromARGB(255, 236, 194, 227),
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
                decoration: InputDecoration(labelText: 'Código de Barras', 
                  labelStyle: const TextStyle(
                    color: Color(0xFF755DC1),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFF837E93),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFF9F7BFF),
                    ),
                  ),
                  suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code, color: Color.fromARGB(255, 107, 61, 233)),
                  onPressed: () async {
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SimpleBarcodeScannerPage(),
                      ));
                      setState(() {
                        if (res is String) {
                          _codigo_baras.text = res;
                        }
                      });
                    }
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
                  });
                },
              ),
              const SizedBox(height: 10),
              const Text("Categoría", style: TextStyle(color: Color(0xFF755DC1), fontWeight: FontWeight.w800, fontSize: 12)),
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
                  onPressed: () => _registrarProducto(context),
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
            ]
          )
      )
    );
  }

  Future<void> _registrarProducto(BuildContext context) async{ 
    mostrarDialogo(context);

    ProductosHTTP productosHTTP = ProductosHTTP();
    ResponseHttp response =  await productosHTTP.registrarProducto(_codigo_baras.text, _descripcion.text, selectedCategory, _precio_compra.text, _precio_venta.text, _existencia.text, selectedUnidad, _base64Image);
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