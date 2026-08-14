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

  List<Carro> _carros = [];

  final Color corPrincipal = Color(0xFF1565C0);
  final Color corSecundaria = Color(0xFF0D47A1);
  final Color corFundo = Color(0xFFF4F6F8);

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
      mostrarMensagem("Preencha todos os campos.", Colors.orange);
      return;
    }

    final double? preco = double.tryParse(tecPreco.text.replaceAll(',', '.'));

    final int? ano = int.tryParse(tecAnoFabricacao.text);

    if (preco == null || preco <= 0) {
      mostrarMensagem("Digite um preço válido.", Colors.orange);
      return;
    }

    if (ano == null || ano < 1900 || ano > DateTime.now().year + 1) {
      mostrarMensagem("Digite um ano de fabricação válido.", Colors.orange);
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
      limparCampos();

      mostrarMensagem("Carro cadastrado com sucesso!", Colors.green);
    } catch (e) {
      mostrarMensagem("Erro ao cadastrar carro.", Colors.red);
    }
  }

  void deletarDado(int id) async {
    try {
      await ListaCarroController.deletarCarro(id);

      await carregarDados();

      mostrarMensagem("Carro removido com sucesso!", Colors.green);
    } catch (e) {
      mostrarMensagem("Erro ao remover carro.", Colors.red);
    }
  }

  void visualizarDado(Carro carro) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(21, 101, 192, 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.directions_car_rounded,
                    size: 40,
                    color: corPrincipal,
                  ),
                ),

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

                _informacaoCarro(
                  Icons.confirmation_number_outlined,
                  "ID",
                  carro.id.toString(),
                ),

                _informacaoCarro(Icons.business_outlined, "Marca", carro.marca),

                _informacaoCarro(
                  Icons.calendar_today_outlined,
                  "Ano",
                  carro.anoFabricacao.toString(),
                ),

                _informacaoCarro(
                  Icons.attach_money_rounded,
                  "Preço",
                  "R\$ ${carro.preco.toStringAsFixed(2)}",
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corPrincipal,
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

  Widget _informacaoCarro(IconData icone, String titulo, String valor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icone, color: corPrincipal, size: 22),

          const SizedBox(width: 12),

          Text("$titulo:", style: const TextStyle(fontWeight: FontWeight.w600)),

          const Spacer(),

          Flexible(
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void limparCampos() {
    setState(() {
      tecAnoFabricacao.clear();
      tecNome.clear();
      tecPreco.clear();
      tecMarca.clear();
    });
  }

  void mostrarMensagem(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              cor == Colors.green ? Icons.check_circle : Icons.warning_rounded,
              color: Colors.white,
            ),

            const SizedBox(width: 10),

            Expanded(child: Text(mensagem)),
          ],
        ),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  InputDecoration estiloCampo({
    required String label,
    required IconData icone,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,

      prefixIcon: Icon(icone, color: corPrincipal),

      filled: true,
      fillColor: Colors.grey.shade50,

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: corPrincipal, width: 2),
      ),

      floatingLabelStyle: TextStyle(
        color: corPrincipal,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corFundo,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: corSecundaria,
        foregroundColor: Colors.white,

        title: Row(
          children: [
            const Icon(Icons.directions_car_rounded, size: 28),

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
            // CABEÇALHO

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: BoxDecoration(
                color: corSecundaria,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Cadastro de veículos",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Cadastre e gerencie seus carros",
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.80),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // CONTEÚDO
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // CARD DE CADASTRO

                    Card(
                      elevation: 3,

                      shadowColor: Color.fromRGBO(0, 0, 0, 0.12),

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
                                Container(
                                  padding: const EdgeInsets.all(10),

                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(21, 101, 192, 0.10),

                                    borderRadius: BorderRadius.circular(12),
                                  ),

                                  child: Icon(
                                    Icons.add_circle_outline,
                                    color: corPrincipal,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Novo carro",
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

                            // MARCA
                            TextField(
                              controller: tecMarca,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,

                              decoration: estiloCampo(
                                label: "Marca",
                                hint: "Ex: Toyota",
                                icone: Icons.business_outlined,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // NOME
                            TextField(
                              controller: tecNome,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,

                              decoration: estiloCampo(
                                label: "Nome do carro",
                                hint: "Ex: Corolla",
                                icone: Icons.directions_car_outlined,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // ANO E PREÇO
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: tecAnoFabricacao,

                                    keyboardType: TextInputType.number,

                                    textInputAction: TextInputAction.next,

                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,

                                      LengthLimitingTextInputFormatter(4),
                                    ],

                                    decoration: estiloCampo(
                                      label: "Ano",
                                      hint: "2024",
                                      icone: Icons.calendar_today_outlined,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: TextField(
                                    controller: tecPreco,

                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),

                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*[,.]?\d{0,2}'),
                                      ),
                                    ],

                                    decoration: estiloCampo(
                                      label: "Preço",
                                      hint: "0,00",
                                      icone: Icons.attach_money_rounded,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // BOTÕES
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: inserirDado,

                                    icon: const Icon(Icons.add),

                                    label: const Text("Cadastrar carro"),

                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: corPrincipal,

                                      foregroundColor: Colors.white,

                                      elevation: 0,

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

                                OutlinedButton(
                                  onPressed: limparCampos,

                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: corPrincipal,

                                    side: BorderSide(color: corPrincipal),

                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 16,
                                    ),

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),

                                  child: const Icon(
                                    Icons.cleaning_services_outlined,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // TÍTULO DA LISTA
                    Row(
                      children: [
                        const Text(
                          "Carros cadastrados",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          decoration: BoxDecoration(
                            color: Color.fromRGBO(21, 101, 192, 0.10),

                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Text(
                            "${_carros.length}",
                            style: TextStyle(
                              color: corPrincipal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // LISTA VAZIA
                    if (_carros.isEmpty)
                      Container(
                        width: double.infinity,

                        padding: const EdgeInsets.all(35),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(20),

                          border: Border.all(color: Colors.grey.shade200),
                        ),

                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),

                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),

                              child: Icon(
                                Icons.directions_car_outlined,
                                size: 45,
                                color: Colors.grey.shade500,
                              ),
                            ),

                            const SizedBox(height: 16),

                            const Text(
                              "Nenhum carro cadastrado",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Cadastre seu primeiro veículo usando o formulário acima.",
                              textAlign: TextAlign.center,

                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    // LISTA COM CARROS
                    else
                      ListView.builder(
                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        itemCount: _carros.length,

                        itemBuilder: (context, index) {
                          final carro = _carros[index];

                          return Dismissible(
                            key: Key(carro.id.toString()),

                            direction: DismissDirection.startToEnd,

                            background: Container(
                              margin: const EdgeInsets.only(bottom: 10),

                              decoration: BoxDecoration(
                                color: Colors.red.shade600,

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

                            confirmDismiss: (direction) async {
                              return await showDialog<bool>(
                                context: context,

                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),

                                    title: const Row(
                                      children: [
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.red,
                                        ),

                                        SizedBox(width: 10),

                                        Text("Excluir carro"),
                                      ],
                                    ),

                                    content: Text(
                                      'Deseja realmente excluir o carro "${carro.nome}"?',
                                    ),

                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),

                                        child: const Text("Cancelar"),
                                      ),

                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,

                                          foregroundColor: Colors.white,
                                        ),

                                        child: const Text("Excluir"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },

                            onDismissed: (direction) {
                              deletarDado(carro.id);
                            },

                            child: Card(
                              elevation: 2,

                              shadowColor: Color.fromRGBO(0, 0, 0, 0.08),

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
                                      // ÍCONE

                                      Container(
                                        width: 58,
                                        height: 58,

                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(
                                            21,
                                            101,
                                            192,
                                            0.10,
                                          ),

                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),

                                        child: Icon(
                                          Icons.directions_car_rounded,
                                          color: corPrincipal,
                                          size: 30,
                                        ),
                                      ),

                                      const SizedBox(width: 14),

                                      // INFORMAÇÕES
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

                                            const SizedBox(height: 5),

                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.business_outlined,
                                                  size: 14,
                                                  color: Colors.grey.shade600,
                                                ),

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

                                                Icon(
                                                  Icons.calendar_today_outlined,
                                                  size: 13,
                                                  color: Colors.grey.shade600,
                                                ),

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

                                              style: TextStyle(
                                                color: corPrincipal,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // SETA
                                      Container(
                                        padding: const EdgeInsets.all(8),

                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,

                                          shape: BoxShape.circle,
                                        ),

                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 15,
                                          color: Colors.grey.shade600,
                                        ),
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

                    // DICA
                    if (_carros.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Icon(
                            Icons.swipe_right_alt_rounded,
                            size: 18,
                            color: Colors.grey.shade500,
                          ),

                          const SizedBox(width: 6),

                          Flexible(
                            child: Text(
                              "Deslize um carro para a direita para excluir",

                              textAlign: TextAlign.center,

                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
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
