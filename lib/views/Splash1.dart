//classe inicial da tela
import 'package:flutter/material.dart';
import 'package:projeto/controller/AuthController.dart';
import 'package:projeto/views/TelaLogin.dart';
import 'package:projeto/views/Splash2.dart';

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
    /**
     * mostra 2 segundos de splash antes de tomar alguma atitude
     * em seguida, verifica se já foi logado antes
     */
    Future.delayed(Duration(seconds: 2), () async {
      await verificaLogin();
    });
  }

  Future<bool> verificaLogin() async {
    print("[FEEDBACK] Verificando se já foi logado alguma vez");
    //testa se existe login salvo
    if (await AuthController.verificaAutorizacaoOffline()) {
      print("[FEEDBACK] Já foi logado!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Splash2()),
      );
    } else {
      print("[FEEDBACK] Não foi logado!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TelaLogin()),
      );
    }
    return false;
  }

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
