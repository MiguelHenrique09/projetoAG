import 'package:flutter/material.dart';
import 'package:projeto/model/classes/carro.dart';

class CarroLista extends StatelessWidget {
  const CarroLista({
    super.key,
    required this.carro,
    required this.onTap,
    required this.onEditar,
    required this.onExcluir,
  });

  final Carro carro;
  final VoidCallback onTap;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.08),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const SizedBox(width: 4),
                        Text(
                          carro.anoFabricacao.toString(),
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
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == "editar") onEditar();
                },
                itemBuilder: (menuContext) {
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
                    PopupMenuItem(
                      enabled: false,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onLongPress: () {
                          Navigator.pop(menuContext);
                          onExcluir();
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              "Excluir",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
