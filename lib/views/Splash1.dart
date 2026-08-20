//classe inicial da tela
import 'package:flutter/material.dart';
import 'package:projeto/views/TelaCarros.dart';

class Splash1 extends StatefulWidget {
  @override
  _Splash1State createState() => _Splash1State();
}

//classe altualizavel da tela
class _Splash1State extends State<Splash1> {
  //FUNÇÃO de inicialização da tela
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TelaCarros(title: "Cadastre e gerencie seus carros"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D47A1), // azul
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_filled_rounded,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              "Meus Carros",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
