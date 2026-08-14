//classe inicial da tela
import 'package:flutter/material.dart';
import 'package:projeto/controller/AuthController.dart';
import 'package:projeto/model/classes/auth.dart';
import 'package:projeto/views/Splash2.dart';
import 'package:projeto/views/TelaLogin.dart';

class TelaLogin extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

//classe altualizavel da tela
class _LoginState extends State<TelaLogin> {
  // 1. Definição da FormKey para controlar a validação do formulário
  final _formKey = GlobalKey<FormState>();

  // 2. Definição dos Controladores para capturar e manipular o texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // IMPORTANTE: Sempre limpe os controladores para evitar vazamento de memória
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /**
   * Evento do botão entrar
   */
  void _enviarFormulario() async {
    // 3. Validação do formulário usando a _formKey
    if (_formKey.currentState!.validate()) {
      // Se for válido, acessa o texto através dos controladores

      //preparo o objeto para verificar autenticação
      Auth auth = new Auth(
        usuario: _emailController.text,
        senha: _passwordController.text,
        token_autorizacao: '',
      );

      //verifico se o usuário e senha estão autenticados na API WEB
      if (await AuthController.verificaAutorizacaoOnline(auth)) {
        //envio um feedback ao usuário informando que o mesmo está autenticado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário autenticado: ${auth.usuario}')),
        );

        //passa para a proxima tela
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Splash2()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Usuário não autentcado!!!')));
      }
    }
  }

  ///////////////////////////////////////////
  //método de inicialização da tela
  @override
  void initState() {
    super.initState();
  }

  //método de construção da interface da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.amber,
      appBar: AppBar(title: Text("Aplicativo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              // O widget Form engloba os campos e usa a chave global
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Exemplo de TextField simples (apenas captura de texto, sem validação nativa)
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      //decoração do textField
                      decoration: const InputDecoration(
                        labelText: 'E-mail (TextField)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Exemplo de TextFormField (ideal para formulários pois possui o parâmetro validator)
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      //decoração do textField
                      decoration: const InputDecoration(
                        labelText: 'Senha (TextFormField)',
                        border: OutlineInputBorder(),
                      ),

                      // Lógica de validação do campo
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha';
                        }
                        if (value.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null; // Retorna null se o campo for válido
                      },
                    ),

                    //dá um espaço
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _enviarFormulario,
                      child: const Text('Entrar'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
