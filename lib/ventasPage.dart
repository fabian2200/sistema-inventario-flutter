// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:sistema_inventario/http/response.dart';
import 'package:sistema_inventario/http/ventas.dart';
import 'package:intl/intl.dart';

class ventasPage extends StatefulWidget {
  const ventasPage({Key? key}) : super(key: key);
  @override
  State<ventasPage> createState() => _ventasPageState();
}

class _ventasPageState extends State<ventasPage> {
  
  String des = "todo";
  late List<dynamic> listaVentas = [];
  TextEditingController _controllerCB = TextEditingController();
  bool cargando = true;
  late Size size;

  final formatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.listarVentas();
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
          padding: EdgeInsets.only(left: 30),
          child: Text("Ventas Realizadas"),
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
                padding: const EdgeInsets.only(top: 4, left: 35, bottom: 4),
                  width: size.width * 0.65,
                  child: TextField(
                      controller: _controllerCB,
                      decoration: const InputDecoration(labelText: '#Factura o Cliente', 
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
                margin: const EdgeInsets.only(left: 8, right: 35),
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
                      listarVentas();
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
          const SizedBox(height: 20),
          Container(
          height: 680,
          padding: const EdgeInsets.all(16.0),
          color: const Color.fromARGB(0, 250, 250, 250),
            child: cargando == false ? SizedBox(
              width: size.width,
              child: listaVentas.isNotEmpty ?
                ListView.builder(
                  itemCount: listaVentas.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(10,10,10,0),
                      margin: EdgeInsets.only(bottom: 10),
                      height: 200,
                      width: double.maxFinite,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Color.fromARGB(255, 101, 45, 145),
                        elevation: 5,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 232, 220, 248),
                              borderRadius: BorderRadius.vertical(
                                bottom : Radius.circular(20),
                                top: Radius.circular(20)
                              )
                          ), 
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Stack(children: <Widget>[
                              Align(
                                alignment: Alignment.centerRight,
                                child: Stack(
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.only(left: 10, top: 5),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                cryptoNameSymbol("Factura #", listaVentas[index]["id"].toString()),
                                                Spacer(),
                                                 ElevatedButton(
                                                  onPressed: () => _imprimirFactura(context, listaVentas[index]["id"].toString()),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color.fromARGB(255, 71, 45, 121),
                                                    fixedSize: Size(60, 60),
                                                    shape: RoundedRectangleBorder( // Define la forma del botón
                                                      borderRadius: BorderRadius.circular(10), // Radio de borde cero para forma cuadrada
                                                    ),
                                                  ),
                                                  child: Icon(
                                                      Icons.print, 
                                                      size: 22, 
                                                      color: Colors.white
                                                    )
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                )
                                              ],
                                            ),
                                            cryptoNameSymbol("Fecha: ", listaVentas[index]["fecha"].toString()),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                cryptoAmount(listaVentas[index]["total"], listaVentas[index]["cliente"]),
                                              ],
                                            )
                                           
                                          ],
                                        ))
                                  ],
                                ),
                              )
                            ]
                          )
                          )
                        )
                      )
                    );
                  }
                ) : const Center(
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage('assets/sin_productos.png')
                      ),
                      SizedBox(height: 10),
                      Text(
                        "No se encontraron facturas con esa información",
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
          )
        ]
      )
    );
  }

  void listarVentas() async {
    setState(() {
      cargando = true;
      listaVentas = [];
    });
      
    ventasHTTP request = ventasHTTP();
    dynamic response = await request.listarVentas(des);
    setState(() {
      listaVentas = response;
      cargando = false;
    });
  }

  Widget cryptoNameSymbol(principal ,id) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: principal,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: id,
                style: TextStyle(
                    color: const Color.fromARGB(255, 99, 98, 98),
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

 
  Future<void> _imprimirFactura(BuildContext context, id) async{ 
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 80,
            child: Center(
              child: 
                  Text(
                    "Imprimiendo...",
                    style: const TextStyle(
                        color: Color(0xFF755DC1),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold
                      ),
                  ),
            ),
          ),
        );
      }
    );

    ventasHTTP ventaste = ventasHTTP();
    dynamic response = await ventaste.imprimir(id, '192.168.1.222');

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
                  response['success'] == 1 ? 
                    const Icon(Icons.warning, size: 50, color: Colors.green)
                  : const Icon(Icons.close, size: 50, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    response['mensaje'],
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
    });
  }

  Widget cryptoAmount(monto, cliente) {
    return Container(
        padding: EdgeInsets.only(left: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Text(
                    "Cliente: ",
                    style: TextStyle(
                      color: Color.fromARGB(255, 34, 34, 34),
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    )
                ),
                Text(
                    cliente,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 82, 82, 82),
                      fontSize: 20,
                    )
                ),
              ],
            ),
             Row(
              children: [
                Text(
                    "Total: ",
                    style: TextStyle(
                      color: Color.fromARGB(255, 138, 26, 172),
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    )
                ),
                Text(
                  formatter.format(monto),
                  style: TextStyle(
                    color: const Color.fromARGB(255, 82, 82, 82),
                    fontSize: 20,
                  )
                )
              ],
            ),
            
          ],
        ),
      );
  }
}