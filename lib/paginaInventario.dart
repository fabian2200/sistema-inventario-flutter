import 'package:flutter/material.dart';
import 'package:sistema_inventario/components/BouncyPageRoute.dart';
import 'package:sistema_inventario/producto/editarProducto.dart';
import 'package:sistema_inventario/http/productos.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';


class InventarioPage extends StatefulWidget {
  const InventarioPage({Key? key}) : super(key: key);
  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  int page = 1;
  int perpage = 10;
  String des = "todo";
  late List<dynamic> listaProductos = [];

  TextEditingController _controllerCB = TextEditingController();

  bool cargando = true;

  late Size size;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.listarProductos();
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
          child: const Text("Inventario"),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               GestureDetector(
                onTap: () async {
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SimpleBarcodeScannerPage(),
                      ));
                      setState(() {
                        if (res is String) {
                          _controllerCB.text = res;
                        }
                      });
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  padding: const EdgeInsets.only(top: 4, left: 10, bottom: 4),
                  child: const Icon(Icons.qr_code, color: Colors.purple, size: 40,),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 4, left: 3, bottom: 4),
                  width: size.width * 0.55,
                  child: TextField(
                      controller: _controllerCB,
                      decoration: const InputDecoration(labelText: 'Código de barras', 
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
                      page = 1;
                      des = _controllerCB.text;
                      if(des == ""){
                        des = "todo";
                      }
                      listarProductos();
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
          Row(
            children: [
              cargando == false ? Container(
                width: size.width,
                child: listaProductos.isNotEmpty
                  ? Container (
                    padding: const EdgeInsets.all(10),
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith((states) => Color.fromARGB(255, 226, 159, 226)),
                      columns: const [
                        DataColumn(label: Text('Descripción', style: TextStyle( fontFamily: 'Poppins', fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Existencia', style: TextStyle( fontFamily: 'Poppins', fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('', style: TextStyle( fontFamily: 'Poppins', fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                      ],
                      rows: listaProductos
                          .map(
                            (producto) => DataRow(
                              cells: [
                                DataCell(Text(producto['descripcion'], style: const TextStyle( fontFamily: 'Poppins'))),
                                DataCell(Text(producto['existencia'].toString()+" "+producto['unidad_medida'].toString(), style: const TextStyle( fontFamily: 'Poppins'))),
                                DataCell(
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.delete_rounded, color: Colors.red),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          child: const Icon(Icons.edit, color: Colors.orange),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              BouncyPageRoute(widget: editarProducto(productId: producto['id']))
                                            );
                                          },
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
                          "No se encontraron productos",
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
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 179, 44, 202)), // Change the color here
                  ),
                  onPressed: () { 
                    setState(() {
                      if(page > 1){
                        page = page - 1;
                        listarProductos();
                      }
                    });
                  },
                  child: const Icon(Icons.arrow_left, color: Colors.white, size: 40,),
                ),
              ),
               Container(
                margin: const EdgeInsets.all(10),
                child: Text("Pagina $page", style: const TextStyle(fontFamily: 'Poppins', color: Colors.purple, fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 179, 44, 202)), // Change the color here
                  ),
                  onPressed: () { 
                    setState(() {
                      page = page + 1;
                      listarProductos();
                    });
                  },
                  child: const Icon(Icons.arrow_right, color: Colors.white, size: 40,),
                ),
              )
            ],
          )
        ],
      )
    );
  }

  void listarProductos() async {
    setState(() {
      cargando = true;
      listaProductos = [];
    });
    
    ProductosHTTP request = ProductosHTTP();
    dynamic response = await request.listarProductos(page, perpage, des);
    setState(() {
      listaProductos = response;
      cargando = false;
    });
  }
}