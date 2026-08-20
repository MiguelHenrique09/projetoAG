import 'package:flutter/material.dart';
import 'package:projeto/model/classes/carro.dart';

void mostrarDialogoVisualizar(BuildContext context, Carro carro) {
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
        Text("$titulo : ", style: const TextStyle(fontWeight: FontWeight.w600)),
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

Future<void> mostrarDialogoEditar(
  BuildContext context, {
  required Carro carro,
  required Future<void> Function(Carro carroAtualizado) onSalvar,
  required void Function(String mensagem) onErro,
}) {
  return showDialog(
    context: context,
    builder: (context) =>
        _CarroEdita(carro: carro, onSalvar: onSalvar, onErro: onErro),
  );
}

class _CarroEdita extends StatefulWidget {
  const _CarroEdita({
    required this.carro,
    required this.onSalvar,
    required this.onErro,
  });

  final Carro carro;
  final Future<void> Function(Carro carroAtualizado) onSalvar;
  final void Function(String mensagem) onErro;

  @override
  State<_CarroEdita> createState() => _CarroEditaState();
}

class _CarroEditaState extends State<_CarroEdita> {
  late final tecNome = TextEditingController(text: widget.carro.nome);
  late final tecPreco = TextEditingController(
    text: widget.carro.preco.toString(),
  );
  late final tecMarca = TextEditingController(text: widget.carro.marca);
  late final tecAno = TextEditingController(
    text: widget.carro.anoFabricacao.toString(),
  );

  @override
  void dispose() {
    tecNome.dispose();
    tecPreco.dispose();
    tecMarca.dispose();
    tecAno.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              controller: tecMarca,
              decoration: const InputDecoration(labelText: "Marca"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tecNome,
              decoration: const InputDecoration(labelText: "Nome do carro"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tecAno,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Ano de fabricação"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tecPreco,
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
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () async {
            final preco = double.tryParse(tecPreco.text.replaceAll(',', '.'));
            final ano = int.tryParse(tecAno.text);

            if (tecNome.text.trim().isEmpty ||
                tecMarca.text.trim().isEmpty ||
                preco == null ||
                ano == null) {
              widget.onErro("Preencha todos os campos corretamente.");
              return;
            }

            final carroAtualizado = Carro(
              id: widget.carro.id,
              nome: tecNome.text.trim(),
              preco: preco,
              marca: tecMarca.text.trim(),
              anoFabricacao: ano,
            );

            try {
              await widget.onSalvar(carroAtualizado);
              if (context.mounted) Navigator.pop(context);
            } catch (e) {
              widget.onErro("Erro ao atualizar carro.");
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
  }
}
