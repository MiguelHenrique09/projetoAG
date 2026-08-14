import 'package:shared_preferences/shared_preferences.dart';
import 'package:projeto/model/classes/auth.dart';
import 'package:projeto/model/classes/carro.dart';
import 'dart:convert';

class LocalStorageService {
  //Constantes que indical a chava shared em que o dado será presistido
  static const String LISTA_CARROS = 'lista_carros';
  static const String AUTORIZACAO = 'autorizacao';

  // Salvar a lista
  static Future<void> salvarAutorizacao(Auth auth) async {
    //instancia a classe sp
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //converte a lista de produtos em string
    final String encodedData = json.encode(auth.toMap());
    //Persiste o dadop
    await prefs.setString(AUTORIZACAO, encodedData);
  }

  // Salvar a lista
  static Future<void> desgravarAutorizacao() async {
    //instancia a classe sp
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(AUTORIZACAO);
  }

  // Recuperar a lista
  static Future<Auth?> carregarAutorizacao() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authJson = prefs.getString(AUTORIZACAO);

    if (authJson == null) return null;

    //RETORNA LISTA DE PRODUTOS
    return Auth.fromMap(json.decode(authJson));
  }

  // Salvar a lista
  static Future<void> salvarCarros(List<Carro> lista) async {
    //instancia a classe sp
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //converte a lista de produtos em string
    final String encodedData = Carro.encode(lista);
    //Persiste o dadop
    await prefs.setString(LISTA_CARROS, encodedData);
  }

  // Recuperar a lista
  static Future<List<Carro>> carregarCarros() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? carrosJson = prefs.getString(LISTA_CARROS);

    if (carrosJson == null) return [];

    //RETORNA LISTA DE CARROS
    return Carro.decode(carrosJson);
  }
}
