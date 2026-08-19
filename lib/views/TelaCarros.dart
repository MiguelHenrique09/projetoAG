import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto/controller/CarroController.dart';
import 'package:projeto/model/classes/carro.dart';

class TelaCarros extends StatefulWidget {
  const TelaCarros({super.key, required this.title});

  final String title;

  @override
  State<TelaCarros> createState() => _TelaCarrosState();
}

class _TelaCarrosState extends State<TelaCarros> {
  final TextEditingController tecID = TextEditingController();
  final TextEditingController tecNome = TextEditingController();
  final TextEditingController tecPreco = TextEditingController();
  final TextEditingController tecMarca = TextEditingController();
  final TextEditingController tecAnoFabricacao = TextEditingController();

  final TextEditingController tecNomeEditar = TextEditingController();
  final TextEditingController tecPrecoEditar = TextEditingController();
  final TextEditingController tecMarcaEditar = TextEditingController();
  final TextEditingController tecAnoEditar = TextEditingController();

  List<Carro> _carros = [];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  @override
  void dispose() {
    tecID.dispose();
    tecNome.dispose();
    tecPreco.dispose();
    tecMarca.dispose();
    tecAnoFabricacao.dispose();

    tecNomeEditar.dispose();
    tecPrecoEditar.dispose();
    tecMarcaEditar.dispose();
    tecAnoEditar.dispose();

    super.dispose();
  }

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

  void inserirDado() async {
    if (tecNome.text.trim().isEmpty ||
        tecPreco.text.trim().isEmpty ||
        tecMarca.text.trim().isEmpty ||
        tecAnoFabricacao.text.trim().isEmpty) {
      mostrarMensagem("Preencha todos os campos.");
      return;
    }

    final double? preco = double.tryParse(tecPreco.text.replaceAll(',', '.'));

    final int? ano = int.tryParse(tecAnoFabricacao.text);

    if (preco == null || preco < 0) {
      mostrarMensagem("Digite um preço válido");
      return;
    }

    if (ano == null || ano < 1000) {
      mostrarMensagem("Digite um ano de fabricação válido");
      return;
    }

    int id = _carros.isEmpty
        ? 1
        : _carros.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;

    String nome = tecNome.text.trim();
    String marca = tecMarca.text.trim();

    try {
      await ListaCarroController.inserirCarro(id, nome, preco, marca, ano);

      await carregarDados();

      tecNome.clear();
      tecPreco.clear();
      tecMarca.clear();
      tecAnoFabricacao.clear();

      mostrarMensagem("Carro cadastrado");
    } catch (e) {
      mostrarMensagem("Erro ao cadastrar");
    }
  }

  Future<void> deletarDado(int id) async {
    try {
      await ListaCarroController.deletarCarro(id);

      await carregarDados();

      mostrarMensagem("Carro removido com sucesso!");
    } catch (e) {
      mostrarMensagem("Erro ao remover carro.");
      await carregarDados();
    }
  }

  // ============================================================
  // EDITAR CARRO
  // ============================================================

  void editarCarro(Carro carro) {
    tecNomeEditar.text = carro.nome;
    tecPrecoEditar.text = carro.preco.toString();
    tecMarcaEditar.text = carro.marca;
    tecAnoEditar.text = carro.anoFabricacao.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Editar carro",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tecMarcaEditar,
                  decoration: const InputDecoration(labelText: "Marca"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: tecNomeEditar,
                  decoration: const InputDecoration(labelText: "Nome do carro"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: tecAnoEditar,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Ano de fabricação",
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: tecPrecoEditar,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: "Preço"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              onPressed: () async {
                final double? preco = double.tryParse(
                  tecPrecoEditar.text.replaceAll(',', '.'),
                );

                final int? ano = int.tryParse(tecAnoEditar.text);

                if (tecNomeEditar.text.trim().isEmpty ||
                    tecMarcaEditar.text.trim().isEmpty ||
                    preco == null ||
                    ano == null) {
                  mostrarMensagem("Preencha todos os campos corretamente.");
                  return;
                }

                final carroAtualizado = Carro(
                  id: carro.id,
                  nome: tecNomeEditar.text.trim(),
                  preco: preco,
                  marca: tecMarcaEditar.text.trim(),
                  anoFabricacao: ano,
                );

                try {
                  await ListaCarroController.atualizarCarro(carroAtualizado);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }

                  await carregarDados();

                  tecNomeEditar.clear();
                  tecPrecoEditar.clear();
                  tecMarcaEditar.clear();
                  tecAnoEditar.clear();

                  mostrarMensagem("Carro atualizado com sucesso!");
                } catch (e) {
                  mostrarMensagem("Erro ao atualizar carro.");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
              ),
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // VISUALIZAR CARRO
  // ============================================================

  void visualizarDado(Carro carro) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),

                Text(
                  carro.nome,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _informacaoCarro("ID", carro.id.toString()),

                _informacaoCarro("Ano", carro.anoFabricacao.toString()),

                _informacaoCarro(
                  "Preço",
                  "R\$ ${carro.preco.toStringAsFixed(2)}",
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Fechar",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _informacaoCarro(String titulo, String valor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Text(
            "$titulo : ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Flexible(
            child: Text(
              valor,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(child: Text(mensagem)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const SizedBox(width: 10),
            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // ========================================================
                    // CADASTRO
                    // ========================================================

                    Card(
                      shadowColor: const Color.fromRGBO(0, 0, 0, 0.12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 12),

                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Insira os dados do novo carro",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(height: 2),

                                    Text(
                                      "Preencha os dados abaixo",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 22),

                            TextField(
                              controller: tecMarca,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: "Marca",
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            TextField(
                              controller: tecNome,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: "Nome do carro",
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            TextField(
                              controller: tecAnoFabricacao,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: "Ano de fabricação",
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            TextField(
                              controller: tecPreco,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                labelText: "Preço",
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: inserirDado,
                                    icon: const Icon(Icons.add),
                                    label: const Text("Cadastrar carro"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1565C0),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ========================================================
                    // TÍTULO
                    // ========================================================
                    Row(
                      children: [
                        const Text(
                          "Carros cadastrados",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ========================================================
                    // LISTA DE CARROS
                    // ========================================================
                    if (_carros.isEmpty)
                      Container(
                        child: const Column(
                          children: [
                            Text(
                              "Nenhum carro cadastrado",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        itemCount: _carros.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final carro = _carros[index];

                          return Dismissible(
                            key: Key(carro.id.toString()),
                            direction: DismissDirection.startToEnd,

                            onDismissed: (direction) {
                              setState(() {
                                _carros.removeAt(index);
                              });

                              deletarDado(carro.id);
                            },

                            background: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                    size: 28,
                                  ),

                                  SizedBox(width: 8),

                                  Text(
                                    "Excluir",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            child: Card(
                              elevation: 2,
                              shadowColor: const Color.fromRGBO(0, 0, 0, 0.08),
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),

                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),

                                onTap: () => visualizarDado(carro),

                                child: Padding(
                                  padding: const EdgeInsets.all(14),

                                  child: Row(
                                    children: [
                                      const SizedBox(width: 14),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              carro.nome,
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            Row(
                                              children: [
                                                const SizedBox(width: 4),

                                                Flexible(
                                                  child: Text(
                                                    carro.marca,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(width: 10),

                                                const SizedBox(width: 4),

                                                Text(
                                                  carro.anoFabricacao
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 7),

                                            Text(
                                              "R\$ ${carro.preco.toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                color: Color(0xFF1565C0),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // ==================================================
                                      // 3 PONTINHOS
                                      // ==================================================
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert),

                                        onSelected: (value) {
                                          if (value == "editar") {
                                            editarCarro(carro);
                                          }
                                        },

                                        itemBuilder: (context) {
                                          return [
                                            const PopupMenuItem(
                                              value: "editar",
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit_outlined),
                                                  SizedBox(width: 8),
                                                  Text("Editar"),
                                                ],
                                              ),
                                            ),
                                          ];
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 20),
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
