import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto/views/Splash1.dart';

void main() {
  runApp(const MyApp());
}

//classe inicial da aplicação
class MyApp extends StatelessWidget {
  //construtor padrão da aplicação
  const MyApp({super.key});
  //método responsável por construir uma interface não alterável, neste caso a moldura em branco do app
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Open Sans"),
      home: Splash1(), //chamando a tela de splash
    );
  }
}
