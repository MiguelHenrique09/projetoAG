import 'package:flutter/material.dart';
import 'package:projeto/controller/AuthController.dart';
import 'package:projeto/model/classes/auth.dart';
import 'package:projeto/views/Splash2.dart';

class TelaLogin extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<TelaLogin> {
  // Chave utilizada para controlar e validar o formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Controle da senha
  bool _mostrarSenha = false;

  // Controle do carregamento do login
  bool _carregando = false;

  // Cor principal do aplicativo
  static const Color azulPrincipal = Color(0xFF3483FA);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Evento do botão entrar
  void _enviarFormulario() async {
    // Validação do formulário
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Esconde o teclado
    FocusScope.of(context).unfocus();

    // Ativa o carregamento
    setState(() {
      _carregando = true;
    });

    // Preparo do objeto para autenticação
    Auth auth = Auth(
      usuario: _emailController.text.trim(),
      senha: _passwordController.text,
      token_autorizacao: '',
    );

    try {
      // Verifica usuário e senha na API
      if (await AuthController.verificaAutorizacaoOnline(auth)) {
        if (!mounted) return;

        // Feedback de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Usuário autenticado: ${auth.usuario}'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Vai para a próxima tela
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Splash2()),
        );
      } else {
        if (!mounted) return;

        // Feedback de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Usuário ou senha incorretos.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      // Erro de comunicação com a API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Não foi possível realizar o login. Tente novamente.',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),

            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),

                  // =====================================================
                  // LOGO
                  // =====================================================
                  Container(
                    width: 85,
                    height: 85,

                    decoration: BoxDecoration(
                      color: azulPrincipal,
                      borderRadius: BorderRadius.circular(24),

                      boxShadow: [
                        BoxShadow(
                          color: azulPrincipal.withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: const Icon(
                      Icons.directions_car_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =====================================================
                  // NOME DO APLICATIVO
                  // =====================================================
                  const Text(
                    'Carros',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Encontre o carro ideal para você',
                    textAlign: TextAlign.center,

                    style: TextStyle(fontSize: 15, color: Color(0xFF777777)),
                  ),

                  const SizedBox(height: 35),

                  // =====================================================
                  // CARD DE LOGIN
                  // =====================================================
                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(24),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(18),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // =================================================
                          // TÍTULO
                          // =================================================

                          const Text(
                            'Entrar',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF222222),
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            'Digite seus dados para continuar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF888888),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // =================================================
                          // E-MAIL
                          // =================================================
                          const Text(
                            'E-mail',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _emailController,

                            keyboardType: TextInputType.emailAddress,

                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              hintText: 'Digite seu e-mail',

                              hintStyle: const TextStyle(
                                color: Color(0xFFAAAAAA),
                              ),

                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Color(0xFF777777),
                              ),

                              filled: true,

                              fillColor: const Color(0xFFF7F7F7),

                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: BorderSide.none,
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: BorderSide.none,
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: const BorderSide(
                                  color: azulPrincipal,
                                  width: 2,
                                ),
                              ),

                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1,
                                ),
                              ),

                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                            ),

                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Digite seu e-mail';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // =================================================
                          // SENHA
                          // =================================================
                          const Text(
                            'Senha',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _passwordController,

                            obscureText: !_mostrarSenha,

                            textInputAction: TextInputAction.done,

                            onFieldSubmitted: (_) {
                              if (!_carregando) {
                                _enviarFormulario();
                              }
                            },

                            decoration: InputDecoration(
                              hintText: 'Digite sua senha',

                              hintStyle: const TextStyle(
                                color: Color(0xFFAAAAAA),
                              ),

                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF777777),
                              ),

                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _mostrarSenha = !_mostrarSenha;
                                  });
                                },

                                icon: Icon(
                                  _mostrarSenha
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,

                                  color: const Color(0xFF777777),
                                ),
                              ),

                              filled: true,

                              fillColor: const Color(0xFFF7F7F7),

                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: BorderSide.none,
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: BorderSide.none,
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: const BorderSide(
                                  color: azulPrincipal,
                                  width: 2,
                                ),
                              ),

                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1,
                                ),
                              ),

                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Digite sua senha';
                              }

                              if (value.length < 6) {
                                return 'A senha deve ter pelo menos 6 caracteres';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 30),

                          // =================================================
                          // BOTÃO ENTRAR
                          // =================================================
                          SizedBox(
                            width: double.infinity,
                            height: 54,

                            child: ElevatedButton(
                              onPressed: _carregando ? null : _enviarFormulario,

                              style: ElevatedButton.styleFrom(
                                backgroundColor: azulPrincipal,

                                foregroundColor: Colors.white,

                                disabledBackgroundColor: azulPrincipal
                                    .withOpacity(0.5),

                                elevation: 0,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),

                              child: _carregando
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,

                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,

                                      children: [
                                        Icon(Icons.login_rounded, size: 21),

                                        SizedBox(width: 10),

                                        Text(
                                          'Entrar',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =====================================================
                  // RODAPÉ
                  // =====================================================
                  const Text(
                    'Encontre seu próximo carro',
                    style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
