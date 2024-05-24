import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sistema_inventario/http/Proveedores.dart';
import 'package:sistema_inventario/http/response.dart';

class proveedorPage extends StatefulWidget {
  const proveedorPage({Key? key}) : super(key: key);
  @override
  State<proveedorPage> createState() => _proveedorPageState();
}

class _proveedorPageState extends State<proveedorPage> {
  String des = "todo";
  late List<dynamic> listaProveedores = [];

  TextEditingController _controllerCB = TextEditingController();
  TextEditingController _nombreProveedor = TextEditingController();

  TextEditingController _nombreProveedorEditar = TextEditingController();
  String _idProveedorEditar = "";
  String _idProveedorEliminar = "";

  bool cargando = true;

  late Size size;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.listarProveedores();
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar : false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          padding: const EdgeInsets.only(left: 30),
          child: const Text("Proveedores"),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 4, left: 23, bottom: 4),
                  width: size.width * 0.70,
                  child: TextField(
                      controller: _controllerCB,
                      decoration: const InputDecoration(labelText: 'Buscar proveedor', 
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
                    ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8, right: 15),
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 87, 28, 134),
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 87, 28, 134)), // Change the color here
                  ),
                  onPressed: () { 
                    setState(() {
                      des = _controllerCB.text;
                      if(des == ""){
                        des = "todo";
                      }
                      listarProveedores();
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.white, size: 30)
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Container(
            margin: const EdgeInsets.only(left: 23, right: 23),
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 87, 28, 134),
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(225, 86, 28, 134)), // Change the color here
              ),
              onPressed: () => modalRegistrar(context),
              child: const Row(
                children: [
                  Icon(Icons.add, color: Colors.white, size: 30),
                  SizedBox(width: 20),
                  Text(
                    "Agregar nueva proveedor",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
          height: 530,
          padding: EdgeInsets.all(16.0),
          color: Color.fromARGB(0, 250, 250, 250),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  cargando == false ? SizedBox(
                    width: size.width,
                    child: listaProveedores.isNotEmpty
                      ? Container (
                        padding: const EdgeInsets.all(20),
                        child: DataTable(
                          headingRowColor: WidgetStateColor.resolveWith((states) => const Color.fromARGB(255, 226, 159, 226)),
                          columns: const [
                            DataColumn(label: Text('Nombre', style: TextStyle( fontFamily: 'Poppins', fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Opciones', style: TextStyle( fontFamily: 'Poppins', fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                          ],
                          rows: listaProveedores
                              .map(
                                (producto) => DataRow(
                                  cells: [
                                    DataCell(Text(producto['nombre'][0].toString().toUpperCase()+producto['nombre'].toString().substring(1), style: const TextStyle( fontFamily: 'Poppins'))),
                                    DataCell(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _idProveedorEliminar = producto['id'].toString();
                                              });
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('Confirmación'),
                                                    content: const Text('¿Está seguro que desea eliminar el proveedor?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: const Text('No'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                          setState(() {
                                                            _idProveedorEliminar = '';
                                                          });
                                                        },
                                                        style: TextButton.styleFrom(
                                                          backgroundColor: Colors.red,
                                                          foregroundColor: Colors.white
                                                        ),
                                                      ),
                                                      TextButton(
                                                        child: const Text('Sí'),
                                                        onPressed: () {
                                                          _eliminarProveedor(context);
                                                        },
                                                        style: TextButton.styleFrom(
                                                          backgroundColor: Colors.green,
                                                          foregroundColor: Colors.white
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Icon(Icons.delete_rounded, color: Colors.red),
                                          ),
                                          const SizedBox(width: 20),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _idProveedorEditar = producto['id'].toString();
                                                _nombreProveedorEditar.text = producto['nombre'].toString();
                                                modalEditar(context);
                                              });
                                            },
                                            child: const Icon(Icons.edit, color: Colors.orange),
                                          )
                                        ],
                                      )
                                    ),
                                  ],
                                )
                              )
                              .toList(),
                        )
                      ) : const Center(
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage('assets/sin_productos.png')
                            ),
                            SizedBox(height: 10),
                            Text(
                              "No se encontraron proveedores",
                              style: TextStyle(
                                color: Color(0xFF755DC1),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        )
                      ),
                  ) : SizedBox(
                    width: size.width,
                    height: 400,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Color(0xFF755DC1)),
                        backgroundColor: Color.fromARGB(255, 160, 159, 159),
                        strokeWidth: 7,
                      ),
                    ),
                  ) 
                ],
              ),  
            )
          )      
        ],
      )
    );
  }

  void modalRegistrar(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 400,
            height: 250,
            child:  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Registrar nuevo proveedor',
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
                      labelText: 'Nombre del proveedor', 
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
                    controller: _nombreProveedor,
                    enabled: true,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 16, 83, 7)), // Change the color here
                        ),
                        onPressed: () => _registrarProveedor(context),
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
                          backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 177, 10, 10)), // Change the color here
                        ),
                        onPressed: () {
                          setState(() {
                            _nombreProveedor.text = '';
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

  void modalEditar(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 400,
            height: 250,
            child:  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Editar proveedor',
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
                      labelText: 'Nombre del proveedor', 
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
                    controller: _nombreProveedorEditar,
                    enabled: true,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 16, 83, 7)), // Change the color here
                        ),
                        onPressed: () => _editarProveedor(context),
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
                          backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 177, 10, 10)), // Change the color here
                        ),
                        onPressed: () {
                          setState(() {
                            _idProveedorEditar = "";
                            _nombreProveedorEditar.text = '';
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

  void listarProveedores() async {
    setState(() {
      cargando = true;
      listaProveedores = [];
    });
    
    ProveedoresHTTP request = ProveedoresHTTP();
    dynamic response = await request.listarProveedores(des);
    setState(() {
      listaProveedores = response;
      cargando = false;
    });
  }

  Future<void> _registrarProveedor(BuildContext context) async{ 
    mostrarDialogo(context);
    ProveedoresHTTP proveedoresHTTP = ProveedoresHTTP();
    ResponseHttp response =  await proveedoresHTTP.registrarProveedor(_nombreProveedor.text);
    cerrarDialogo(context);
    if(response.success == 1){
      setState(() {
        _nombreProveedor.text = '';
      });
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 100,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.check_circle, size: 50, color: Colors.green),
                    const SizedBox(height: 20),
                    Text(
                      response.mensaje,
                       style: const TextStyle(
                          color: Color(0xFF755DC1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold
                        ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      );

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop(); 
        Navigator.of(context).pop(); 
        setState(() {
          listarProveedores();
        });
      });
      
    }else{
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.error, size: 50, color: Colors.red),
                    const SizedBox(height: 20),
                    Text(
                      'Ocurrió un error: ${response.mensaje}',
                      style: const TextStyle(
                        color: Color(0xFF755DC1),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold
                      ),
                    ),
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

  Future<void> _editarProveedor(BuildContext context) async{ 
    mostrarDialogo(context);
    ProveedoresHTTP proveedoresHTTP = ProveedoresHTTP();
    ResponseHttp response =  await proveedoresHTTP.editarProveedor(_idProveedorEditar, _nombreProveedorEditar.text);
    cerrarDialogo(context);
    if(response.success == 1){
      setState(() {
        _idProveedorEditar = '';
        _nombreProveedorEditar.text = '';
      });
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 100,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.check_circle, size: 50, color: Colors.green),
                    const SizedBox(height: 20),
                    Text(
                      response.mensaje,
                       style: const TextStyle(
                          color: Color(0xFF755DC1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold
                        ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); 
        Navigator.of(context).pop(); 
        setState(() {
          listarProveedores();
        });
      });
      
    }else{
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.error, size: 50, color: Colors.red),
                    const SizedBox(height: 20),
                    Text(
                      'Ocurrió un error: ${response.mensaje}',
                      style: const TextStyle(
                        color: Color(0xFF755DC1),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold
                      ),
                    ),
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

  Future<void> _eliminarProveedor(BuildContext context) async{ 
    ProveedoresHTTP proveedoresHTTP = ProveedoresHTTP();
    ResponseHttp response =  await proveedoresHTTP.eliminar(_idProveedorEliminar);
    setState(() {
      _idProveedorEliminar = '';
    });
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 150,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  response.success == 1 ? 
                    const Icon(Icons.warning, size: 50, color: Colors.green)
                  : const Icon(Icons.close, size: 50, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    response.mensaje,
                     style: const TextStyle(
                        color: Color(0xFF755DC1),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold
                      ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); 
      Navigator.of(context).pop(); 
      setState(() {
        if(response.success == 1){
          listarProveedores();
        }
      });
    });
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
                  Text('Guardando datos...'),
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