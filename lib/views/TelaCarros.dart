import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto/controller/CarroController.dart';
import 'package:projeto/model/classes/carro.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const Tela1(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

class TelaCarros extends StatefulWidget {
  const TelaCarros({super.key, required this.title});
  final String title;
  @override
  State<TelaCarros> createState() => _TelaCarrosState();
}

class _TelaCarrosState extends State<TelaCarros> {
  TextEditingController tecID = new TextEditingController();
  TextEditingController tecNome = new TextEditingController();
  TextEditingController tecPreco = new TextEditingController();
  TextEditingController tecMarca = new TextEditingController();
  TextEditingController tecAnoFabricacao = new TextEditingController();
  late List<Carro> _carros = [];

  /**
   * Inicializa  antes mesmo de desenhar a tela pela primeira vez
   */
  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  /**
   * Função responsável por recarregar dados do list view
   */
  Future<void> carregarDados() async {
    try {
      final dados = await ListaCarroController.listarCarros();
      setState(() {
        _carros = dados;
      });
    } catch (x) {
      print("Sem dados persistidos $x");
    }
  }

  /**
   * Chamada ao controlador para inserção de dados
   */
  void inserirDado() async {
    // Gera um novo ID automaticamente (maior ID atual + 1, ou 1 se lista vazia)
    int id = _carros.isEmpty
        ? 1
        : _carros.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;

    String nome = tecNome.text;
    double preco = double.parse(tecPreco.text);
    String marca = tecMarca.text;
    int anoFabricacao = int.parse(tecAnoFabricacao.text);

    await ListaCarroController.inserirCarro(
      id,
      nome,
      preco,
      marca,
      anoFabricacao,
    );
    print('Carro Inserido!');

    await carregarDados();
    limparCampos();
  }

  /**
   * Chamada ao controlador para deleção de dados
   */
  void deletarDado(int id) async {
    // Escreva o método correspondente no seu ListaCarroController
    await ListaCarroController.deletarCarro(id);
    print('Carro $id deletado!');
    await carregarDados();
  }

  /**
   * chamad a outra tela(view) para exibição detalhada de dados
   */
  void visualizarDado(Carro carro) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(carro.nome),
        content: Text(
          'ID: ${carro.id}\nPreço: R\$ ${carro.preco.toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  /**
   * Função auxiliar para a tela atual
   */
  void limparCampos() {
    setState(() {
      tecAnoFabricacao.text = "";
      tecNome.text = "";
      tecPreco.text = "";
      tecMarca.text = "";
    });
  }

  /**
   * Função que constroe a tela atual
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            // Card de Cadastro
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const Text("Marca do carro"),
                    TextField(
                      controller: tecMarca,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    const Text("Ano de fabricação do carro"),
                    TextField(
                      controller: tecAnoFabricacao,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    const Text("Nome do carro"),
                    TextField(controller: tecNome),
                    const SizedBox(height: 12),
                    const Text("Preço do carro"),
                    TextField(
                      controller: tecPreco,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: inserirDado,
                            child: const Text("Inserir"),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: limparCampos,
                            child: const Text("Limpar"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Lista de Produtos Interativa
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: _carros.isEmpty
                    ? const Center(child: Text('Nenhum carro cadastrado.'))
                    : ListView.builder(
                        itemCount: _carros.length,
                        itemBuilder: (context, index) {
                          final carro = _carros[index];

                          return Dismissible(
                            /**
                       * Evento dismissible para deleção jogando de lado
                       */
                            key: Key(carro.id.toString()),
                            direction: DismissDirection
                                .startToEnd, // Permite arrastar apenas para a direita
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              // Mostra um diálogo de confirmação na tela
                              return await showDialog<bool>(
                                context: context,
                                barrierDismissible:
                                    false, // Força o usuário a clicar em um dos botões
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirmar Exclusão'),
                                    content: Text(
                                      'Deseja mesmo deletar o carro "${carro.nome}"?',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.of(
                                          context,
                                        ).pop(false), // Retorna false (cancela)
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(
                                          context,
                                        ).pop(true), // Retorna true (confirma)
                                        child: const Text(
                                          'Deletar',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onDismissed: (direction) {
                              deletarDado(carro.id);
                              // Feedback visual opcional usando o SnackBar que aprendemos!
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${carro.nome} foi removido.'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.shopping_bag,
                                  color: Colors.blue,
                                ),
                                title: Text(carro.nome),
                                subtitle: Text(
                                  'R\$ ${carro.preco.toStringAsFixed(2)}',
                                ),
                                //evento do toque para visualização
                                onTap: () =>
                                    visualizarDado(carro), // Toque rápido
                                //evento do click longo para edição
                                // onLongPress: () =>
                                //     prepararEdicao(carro), // Toque longo
                                // trailing: Row(
                                //   mainAxisSize: MainAxisSize.min,
                                //   children: [
                                //     // IconButton(
                                //     //   icon: carro.favorito
                                //     //       ? const Icon(
                                //     //           Icons.favorite,
                                //     //           color: Colors.red,
                                //     //         )
                                //     //       : const Icon(
                                //     //           Icons.favorite,
                                //     //           color: Colors.grey,
                                //     //         ),
                                //     //   onPressed: () => favoritarDado(carro),
                                //     //   tooltip: 'Editar',
                                //     // ),
                                //   ],
                                // ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
