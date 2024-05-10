import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_inventario/components/BouncyPageRoute.dart';
import 'package:sistema_inventario/paginaInventario.dart';
import 'package:sistema_inventario/producto/stock.dart';

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);
  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verificarIP(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 234, 250),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings, size: 37),
            onPressed: () => _showMessageDialog(context),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 245, 234, 250),
      extendBodyBehindAppBar : true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Sistema de Inventario", style: TextStyle(
            color: Color(0xFF755DC1),
            fontSize: 27,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w900,
          )),
          const SizedBox(height: 70.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    BouncyPageRoute(widget: const InventarioPage())
                  );   
                },
                child: _buildSquareContainer('assets/inventario.png'),
              ),
             _buildSquareContainer('assets/clientes.png'),
            ],
          ),
          const SizedBox(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSquareContainer('assets/proveedores.png'),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    BouncyPageRoute(widget: const stockPage())
                  );   
                },
                child: _buildSquareContainer('assets/stock.png'),
              ),
            ],
          ),
          const SizedBox(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSquareContainer('assets/ventas.png'),
              _buildSquareContainer('assets/salir.png'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSquareContainer(String imagePath) {
    return Container(
      width: 150.0,
      height: 150.0,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 116, 115, 115).withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 1,
            offset: const Offset(3, 4),
          ),
        ],
      ),
      child: Image.asset(
        imagePath,
        width: 10.0,
        height: 10.0,
      ),
    );
  }

  void verificarIP(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var ip =  pref.getString('ip');
    if(ip == null){
      _showMessageDialog(context);
    }
  }

   void _showMessageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _buildMessageDialog(context);
      },
    );
  }

  Widget _buildMessageDialog(context) {
    TextEditingController _controllerIp = TextEditingController();
    
    return AlertDialog(
      title: const Text('Agregar IP del servidor'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _controllerIp,
            decoration: const InputDecoration(labelText: 'IP del servidor'),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () async {
            String ipAddress = _controllerIp.text;
            if (isValidIP(ipAddress)) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('ip', ipAddress);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Ip guardada correctamente', style: TextStyle(color: Colors.white)),
                  duration: Duration(seconds: 2),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('La dirección IP ingresada no es válida.', style: TextStyle(color: Colors.white)),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  bool isValidIP(String ipAddress) {
    // Expresión regular para validar la IP
    RegExp regExp = RegExp(
      r'^([0-9]{1,3}\.){3}[0-9]{1,3}$',
      caseSensitive: false,
      multiLine: false,
    );

    if (!regExp.hasMatch(ipAddress)) {
      return false; // No coincide con el formato básico de la IP
    }

    // Verificar cada parte de la IP
    List<String> parts = ipAddress.split('.');
    for (var part in parts) {
      int? value = int.tryParse(part);
      if (value == null || value < 0 || value > 255) {
        return false; // Parte de la IP no es un número válido entre 0 y 255
      }
    }

    return true; // La IP es válida
  }
}