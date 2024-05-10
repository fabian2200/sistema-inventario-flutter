import 'package:flutter/material.dart';
import 'package:sistema_inventario/components/BouncyPageRoute.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_inventario/principal.dart';
import 'package:sistema_inventario/ui/login.dart';

class Carga extends StatefulWidget {
  _CargaState createState() => _CargaState();
}


class _CargaState extends State<Carga> {

  @override
  void initState() {
    super.initState();
    _verificarSesion();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
           Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFF755DC1)),
              backgroundColor: Color.fromARGB(255, 224, 223, 223),
              strokeWidth: 7,
            ),
          )
        ],
      ),
    );
  }


  Future<void> _verificarSesion()  async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Future.delayed(Duration(seconds: 3),(){
      var tipo =  pref.getInt('tipo');
      if(tipo != null){
        Navigator.push(
          context,
          BouncyPageRoute(widget: const Principal())
        );  
      }else{
        Navigator.push(
          context,
          BouncyPageRoute(widget: const LoginView())
        ); 
      }
      
    });
  }
}
