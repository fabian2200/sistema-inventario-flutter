import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:sistema_inventario/http/productos.dart';
import 'package:sistema_inventario/http/response.dart';
import 'package:sistema_inventario/producto/registrarProducto.dart';

class stockPage extends StatefulWidget {
  const stockPage({Key? key}) : super(key: key);
  @override
  State<stockPage> createState() => __stockPageState();
}

class __stockPageState extends State<stockPage> {
  
  late Size size;
  TextEditingController _controllerCB = TextEditingController();
  TextEditingController nombre = TextEditingController();
  TextEditingController existencia = TextEditingController();
  TextEditingController precio_compra = TextEditingController();
  TextEditingController precio_venta = TextEditingController();
  TextEditingController existencia2 = TextEditingController();

  double cantidad_actual = 0;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 245, 234, 250),
      extendBodyBehindAppBar : true,
      appBar: AppBar(
         elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          padding: EdgeInsets.only(left: 30),
          child: Text(""),
        ),
      ),
      body:GestureDetector(
        onTap: () async {
          var res = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SimpleBarcodeScannerPage(),
          ));
          setState(() {
            if (res is String) {
              _controllerCB.text = res;
              buscarProductoCB(context);
            }
          });
        },    
        child:  Container(
          padding: const EdgeInsets.all(30),
          width: size.width,
          height: size.height,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.qr_code, size: 170, color: Color.fromARGB(255, 131, 66, 143)),
              SizedBox(height: 30),
              Text(
                "Toque la pantalla para escanear el código de barras",
                style:  TextStyle(
                  color: Color(0xFF755DC1),
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
      )
    );
  }

  void buscarProductoCB(BuildContext context) async {
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
                  Text('Buscando el producto...'),
                ],
              ),
            ),
          ),
        );
      }
    );

    ProductosHTTP request = ProductosHTTP();
    dynamic response = await request.buscarProductoCB(_controllerCB.text);
    setState(() {
      if(response != null){
        setState(() {
          nombre.text = response["descripcion"];
          existencia.text = response["existencia"]+" "+response["unidad_medida"];
          precio_compra.text = response["precio_compra"];
          precio_venta.text = response["precio_venta"];
          cantidad_actual = double.parse(response["existencia"]);
          Navigator.of(context).pop(); 
          abrirModal(context);
        });
      }else{
        Navigator.of(context).pop(); 
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                height: 400,
                child:  Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.error, size: 140, color: Color.fromARGB(255, 216, 120, 113)),
                      const SizedBox(height: 20),
                      const Text(
                        'No se encontró un producto asociado a ese código de barras',
                        style:  TextStyle(
                          color: Color(0xFF755DC1),
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '¿Desea registrarlo?',
                        style:  TextStyle(
                          color: Color(0xFF755DC1),
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 16, 83, 7)), // Change the color here
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(); 
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (BuildContext context) => registrarProducto()),
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check, color: Colors.white),
                                SizedBox(width: 5),
                                Text("Si", style: TextStyle(color: Colors.white, fontFamily: 'Poppins',))
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 177, 10, 10)), // Change the color here
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(); 
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.close, color: Colors.white),
                                SizedBox(width: 5),
                                Text("No", style: TextStyle(color: Colors.white, fontFamily: 'Poppins',))
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        );
      }
    });
  }


  void abrirModal(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 400,
            height: 570,
            child:  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                 
                  const Text(
                    'Producto encontrado',
                    style:  TextStyle(
                      color: Color(0xFF755DC1),
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del producto', 
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
                    controller: nombre,
                    enabled: false,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad disponible', 
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
                    controller: existencia,
                    enabled: false,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Precio de compra', 
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
                    controller: precio_compra,
                    enabled: true,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Precio de venta', 
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
                    controller: precio_venta,
                    enabled: true,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '¿Cantidad que desea agregar?', 
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
                    controller: existencia2,
                    enabled: true,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 16, 83, 7)), // Change the color here
                        ),
                        onPressed: () => _editarInventarioProducto(context),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save, color: Colors.white),
                            SizedBox(width: 5),
                            Text("Guardar", style: TextStyle(color: Colors.white, fontFamily: 'Poppins',))
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 177, 10, 10)), // Change the color here
                        ),
                        onPressed: () {
                          setState(() {
                            existencia2.text = '';
                          });
                          Navigator.of(context).pop(); 
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.close, color: Colors.white),
                            SizedBox(width: 5),
                            Text("Cancelar", style: TextStyle(color: Colors.white, fontFamily: 'Poppins',))
                          ],
                        ),
                      ),
                    ],
                  )
                ]
              ),
            ),
          ),
        );
      }
    );
  }

  Future<void> _editarInventarioProducto(BuildContext context) async{ 
    if(existencia2.text != ""){
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
                    Text('Guardando datos...'),
                  ],
                ),
              ),
            ),
          );
        }
      );

      ProductosHTTP productosHTTP = ProductosHTTP();
      ResponseHttp response =  await productosHTTP.EditarInventarioProducto(cantidad_actual, precio_compra.text, precio_venta.text, existencia2.text, _controllerCB.text);
      Navigator.of(context).pop();
      if(response.success == 1){
        Future.delayed(const Duration(milliseconds: 300), () {
          mostrarDialogoInfo(context, response.mensaje, Icons.check_circle, Colors.green);
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              existencia2.text = '';
            });
            Navigator.of(context).pop(); 
          });
        });
      }else{
        Future.delayed(const Duration(milliseconds: 300), () {
          mostrarDialogoInfo(context, 'Ocurrió un error: ${response.mensaje}', Icons.error, Colors.red);       
        });
      }
    }else{
      mostrarDialogoInfo(context, "Debe ingresar la cantidad que desea agregar al producto", Icons.error, Colors.red);
    }
  }

  mostrarDialogoInfo(BuildContext context, String texto, IconData icono, Color colorf){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 200,
            child:  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(icono, size: 50, color: colorf),
                  const SizedBox(height: 20),
                  Text(texto, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,),
                ],
              ),
            ),
          ),
        );
      }
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); 
    });
  }
}