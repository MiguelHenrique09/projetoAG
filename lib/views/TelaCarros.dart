import 'package:flutter/material.dart';
import 'package:projeto/controller/CarroController.dart';
import 'package:projeto/model/classes/carro.dart';
import 'package:projeto/funcoes/carroFormulario.dart';
import 'package:projeto/funcoes/carroWidget.dart';
import 'package:projeto/funcoes/carroLista.dart';

class TelaCarros extends StatefulWidget {
  const TelaCarros({super.key, required this.title});

  final String title;

  @override
  State<TelaCarros> createState() => _TelaCarrosState();
}

class _TelaCarrosState extends State<TelaCarros> {
  final tecNome = TextEditingController();
  final tecPreco = TextEditingController();
  final tecMarca = TextEditingController();
  final tecAnoFabricacao = TextEditingController();

  List<Carro> _carros = [];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  @override
  void dispose() {
    tecNome.dispose();
    tecPreco.dispose();
    tecMarca.dispose();
    tecAnoFabricacao.dispose();
    super.dispose();
  }

  Future<void> carregarDados() async {
    try {
      final dados = await ListaCarroController.listarCarros();
      setState(() => _carros = dados);
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

    final preco = double.tryParse(tecPreco.text.replaceAll(',', '.'));
    final ano = int.tryParse(tecAnoFabricacao.text);

    if (preco == null || preco < 0) {
      mostrarMensagem("Digite um preço válido");
      return;
    }
    if (ano == null || ano < 1000) {
      mostrarMensagem("Digite um ano de fabricação válido");
      return;
    }

    final id = _carros.isEmpty
        ? 1
        : _carros.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;

    try {
      await ListaCarroController.inserirCarro(
        id,
        tecNome.text.trim(),
        preco,
        tecMarca.text.trim(),
        ano,
      );
      await carregarDados();
      tecNome.clear();
      tecPreco.clear();
      tecMarca.clear();
      tecAnoFabricacao.clear();
    } catch (e) {
      mostrarMensagem("Erro ao cadastrar");
    }
  }

  Future<void> deletarDado(int id) async {
    try {
      await ListaCarroController.deletarCarro(id);
      await carregarDados();
    } catch (e) {
      mostrarMensagem("Erro ao remover carro.");
      await carregarDados();
    }
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
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CarroFormulario(
                tecMarca: tecMarca,
                tecNome: tecNome,
                tecAnoFabricacao: tecAnoFabricacao,
                tecPreco: tecPreco,
                onCadastrar: inserirDado,
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Text(
                    "Carros cadastrados",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_carros.isEmpty)
                const Text(
                  "Nenhum carro cadastrado",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                )
              else
                ListView.builder(
                  itemCount: _carros.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final carro = _carros[index];
                    return CarroLista(
                      carro: carro,
                      onTap: () => mostrarDialogoVisualizar(context, carro),
                      onEditar: () => mostrarDialogoEditar(
                        context,
                        carro: carro,
                        onSalvar: (atualizado) async {
                          await ListaCarroController.atualizarCarro(atualizado);
                          await carregarDados();
                        },
                        onErro: mostrarMensagem,
                      ),
                      onExcluir: () {
                        setState(
                          () => _carros.removeWhere((c) => c.id == carro.id),
                        );
                        deletarDado(carro.id);
                      },
                    );
                  },
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
