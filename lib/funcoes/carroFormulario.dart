import 'package:flutter/material.dart';

class CarroFormulario extends StatelessWidget {
  const CarroFormulario ({
    super.key,
    required this.tecMarca,
    required this.tecNome,
    required this.tecAnoFabricacao,
    required this.tecPreco,
    required this.onCadastrar,
  });

  final TextEditingController tecMarca;
  final TextEditingController tecNome;
  final TextEditingController tecAnoFabricacao;
  final TextEditingController tecPreco;
  final VoidCallback onCadastrar;

  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Insira os dados do novo carro",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text(
                  "Preencha os dados abaixo",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 22),
            TextField(
              controller: tecMarca,
              textInputAction: TextInputAction.next,
              decoration: _decoration("Marca"),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: tecNome,
              textInputAction: TextInputAction.next,
              decoration: _decoration("Nome do carro"),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: tecAnoFabricacao,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: _decoration("Ano de fabricação"),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: tecPreco,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.done,
              decoration: _decoration("Preço"),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onCadastrar,
                icon: const Icon(Icons.add),
                label: const Text("Cadastrar carro"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
