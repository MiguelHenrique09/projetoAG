import 'package:projeto/model/classes/carro.dart';
import 'package:projeto/model/localstorage.dart';

/**
 * Classe controle responsável por gerenciar a persistência de carros.
 * aqui serão encontrados todos os métodos responsáveis por gerenciar a
 * listagem persistida de carros
 */
class ListaCarroController {
  static Future<void> inserirCarro(
    int id,
    String nome,
    double preco,
    String marca,
    int anoFabricacao,
  ) async {
    //busco lista persistida
    List<Carro> lista = await LocalStorageService.carregarCarros();
    //inserindo carro na lista (voátil)
    lista.add(
      new Carro(
        id: id,
        nome: nome,
        preco: preco,
        marca: marca,
        anoFabricacao: anoFabricacao,
      ),
    );
    //salvando carro na lista persistida
    await LocalStorageService.salvarCarros(lista);
  }

  static Future<void> deletarCarro(int id) async {
    //busco lista persistida
    List<Carro> lista = await LocalStorageService.carregarCarros();
    //removendo item da lista com o id correspondente
    lista.removeWhere((c) => c.id == id);
    //salvando carro na lista persistida
    await LocalStorageService.salvarCarros(lista);
  }

  static Future<void> atualizarCarro(Carro car) async {
    // Busca a lista salva
    List<Carro> lista = await LocalStorageService.carregarCarros();

    // Procura o carro pelo ID
    int index = lista.indexWhere((c) => c.id == car.id);

    // Se encontrou, substitui pelos novos dados
    if (index != -1) {
      lista[index] = car;
    }

    // Salva a lista novamente
    await LocalStorageService.salvarCarros(lista);
  }

  static Future<void> buscarCarro(int id) async {
    //...
  }

  static Future<List<Carro>> listarCarros() async {
    //busca listagem persistida
    return await LocalStorageService.carregarCarros();
  }
}
