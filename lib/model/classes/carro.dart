import 'dart:convert';

class Carro {
  final int id;
  final String nome;
  final String marca;
  final int anoFabricacao;
  final double preco;
  //construtor da classe que recer cada um de seus atributos
  Carro({
    required this.id,
    required this.nome,
    required this.marca,
    required this.anoFabricacao,
    required this.preco,
  });

  // Converte o objeto para um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'marca': marca,
      'anoFabricacao': anoFabricacao,
      'preco': preco,
    };
  }

  // Cria um objeto a partir de un Map
  factory Carro.fromMap(Map<String, dynamic> map) {
    return Carro(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      marca: map['marca'] ?? '',
      anoFabricacao: map['anoFabricacao'] ?? 0,
      preco: (map['preco'] ?? 0.0).toDouble(),
    );
  }

  // Facilita a conversão de uma lista de objetos para uma String JSON
  static String encode(List<Carro> carros) =>
      json.encode(carros.map<Map<String, dynamic>>((c) => c.toMap()).toList());

  // Facilita a conversão de uma String JSON para uma lista de objetos
  static List<Carro> decode(String carrosJson) =>
      (json.decode(carrosJson) as List<dynamic>)
          .map<Carro>((item) => Carro.fromMap(item))
          .toList();
}
