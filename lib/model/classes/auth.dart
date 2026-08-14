import 'dart:convert';

class Auth {
  final String usuario;
  final String senha;
  final String token_autorizacao;

  //construtor da classe que recer cada um de seus atributos
  Auth({
    required this.usuario,
    required this.senha,
    required this.token_autorizacao,
  });

  // Converte o objeto para um Map
  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'senha': senha,
      'token_autorizacao': token_autorizacao,
    };
  }

  // Cria um obje to a partir de un Map
  factory Auth.fromMap(Map<String, dynamic> map) {
    return Auth(
      usuario: map['usuario'] ?? '',
      senha: map['senha'] ?? '',
      token_autorizacao: map['token_autorizacao'] ?? '',
    );
  }

  // Facilita a conversão de uma lista de objetos para uma String JSON
  static String encode(List<Auth> Auths) =>
      json.encode(Auths.map<Map<String, dynamic>>((p) => p.toMap()).toList());

  // Facilita a conversão de uma String JSON para uma lista de objetos
  static List<Auth> decode(String AuthsJson) =>
      (json.decode(AuthsJson) as List<dynamic>)
          .map<Auth>((item) => Auth.fromMap(item))
          .toList();
}
