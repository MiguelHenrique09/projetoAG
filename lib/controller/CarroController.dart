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
    //buscando e removendo item da lista
    for (Carro c in lista) if (c.id == id) lista.remove(c);
    //salvando carro na lista persistida
    await LocalStorageService.salvarCarros(lista);
  }

  // static Future<void> favoritar(Carro car) async {
  //   late Carro carFavorito;
  //   if (car.favorito)
  //     carFavorito = new Carro(
  //       id: car.id,
  //       nome: car.nome,
  //       preco: car.preco,
  //       favorito: false,
  //     );
  //   else
  //     carFavorito = new Carro(
  //       id: car.id,
  //       nome: car.nome,
  //       preco: car.preco,
  //       favorito: true,
  //     );
  //   await atualizarCarro(carFavorito);
  // }

  static Future<void> atualizarCarro(Carro car) async {
    //busco lista persistida
    List<Carro> lista = await LocalStorageService.carregarCarros();

    //buscando e removendo item da lista
    int index = 0;
    for (Carro c in lista) {
      if (c.id == car.id) lista.removeAt(index);
      index += 1;
    }
    lista.add(car);

    //salvando carro  na lista persistida
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
