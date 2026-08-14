//classe inicial da tela
import 'package:flutter/material.dart';
import 'package:projeto/views/TelaCarros.dart';

class Splash2 extends StatefulWidget {
  @override
  _Splash2State createState() => _Splash2State();
}

//classe altualizavel da tela
class _Splash2State extends State<Splash2> {
  //método de inicialização da tela
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TelaCarros(title: "Carros Disponíveis"),
        ),
      );
    });
  }

  //método de construção da interface da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [CircularProgressIndicator()],
        ),
      ),
    );
  }
}
