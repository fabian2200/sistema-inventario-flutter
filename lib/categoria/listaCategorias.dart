import 'package:flutter/material.dart';
import 'package:sistema_inventario/http/categorias.dart';
import 'package:sistema_inventario/http/response.dart';

class categoriaPage extends StatefulWidget {
  const categoriaPage({Key? key}) : super(key: key);
  @override
  State<categoriaPage> createState() => _categoriaPageState();
}

class _categoriaPageState extends State<categoriaPage> {
  String des = "todo";
  late List<dynamic> listaCategorias = [];

  TextEditingController _controllerCB = TextEditingController();
  TextEditingController _nombreCategoria = TextEditingController();


  bool cargando = true;

  late Size size;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.listarCategorias();
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
          child: const Text("Categorias"),
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
                      decoration: const InputDecoration(labelText: 'Buscar categoria', 
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
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 87, 28, 134)), // Change the color here
                  ),
                  onPressed: () { 
                    setState(() {
                      des = _controllerCB.text;
                      if(des == ""){
                        des = "todo";
                      }
                      listarCategorias();
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
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(225, 86, 28, 134)), // Change the color here
              ),
              onPressed: () => modalRegistrar(context),
              child: const Row(
                children: [
                  Icon(Icons.add, color: Colors.white, size: 30),
                  SizedBox(width: 20),
                  Text(
                    "Agregar nueva categoria",
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
          Row(
            children: [
              cargando == false ? Container(
                width: size.width,
                child: listaCategorias.isNotEmpty
                  ? Container (
                    padding: const EdgeInsets.all(20),
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith((states) => Color.fromARGB(255, 226, 159, 226)),
                      columns: const [
                        DataColumn(label: Text('Nombre', style: TextStyle( fontFamily: 'Poppins', fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Opciones', style: TextStyle( fontFamily: 'Poppins', fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                      ],
                      rows: listaCategorias
                          .map(
                            (producto) => DataRow(
                              cells: [
                                DataCell(Text(producto['nombre'][0].toString().toUpperCase()+producto['nombre'].toString().substring(1), style: const TextStyle( fontFamily: 'Poppins'))),
                                const DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.delete_rounded, color: Colors.red),
                                      SizedBox(width: 20),
                                      Icon(Icons.edit, color: Colors.orange)
                                    ],
                                  )
                                ),
                              ],
                              onLongPress: () {}
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
                          "No se encontraron categorías",
                          style: TextStyle(
                            color: Color(0xFF755DC1),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    )
                  ),
              ) : Container(
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
                    'Registrar nueva categoria',
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
                      labelText: 'Nombre de la categoria', 
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
                    controller: _nombreCategoria,
                    enabled: true,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 16, 83, 7)), // Change the color here
                        ),
                        onPressed: () => _registrarCategoria(context),
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
                            _nombreCategoria.text = '';
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

  void listarCategorias() async {
    setState(() {
      cargando = true;
      listaCategorias = [];
    });
    
    CategoriasHTTP request = CategoriasHTTP();
    dynamic response = await request.listarCategorias(des);
    setState(() {
      listaCategorias = response;
      cargando = false;
    });
  }

  Future<void> _registrarCategoria(BuildContext context) async{ 
    mostrarDialogo(context);
    CategoriasHTTP categoriasHTTP = CategoriasHTTP();
    ResponseHttp response =  await categoriasHTTP.registrarCategoria(_nombreCategoria.text);
    cerrarDialogo(context);
    if(response.success == 1){
      setState(() {
        _nombreCategoria.text = '';
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
                    Text(response.mensaje),
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
          listarCategorias();
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