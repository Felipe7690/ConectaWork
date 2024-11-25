import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class DescDemanda extends StatefulWidget {
  final String objectId;

  const DescDemanda({Key? key, required this.objectId}) : super(key: key);

  @override
  State<DescDemanda> createState() => _DescDemandaState();
}

class _DescDemandaState extends State<DescDemanda> {
  final MoneyMaskedTextController _valorController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );

  final TextEditingController _dataEntregaController = TextEditingController();
  final MaskedTextController _whatsappController =
      MaskedTextController(mask: '(00) 0.0000-0000');

  ParseObject? _demanda;
  List<String> _imagens = [];
  String? _criadorNome;
  String? _criadorFoto;

  ParseObject? get proposta {
    return _demanda; // Ou outra lógica conforme sua necessidade
  }

  @override
  void initState() {
    super.initState();
    _loadDemanda();
  }

  void _loadDemanda() async {
    final QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('Demanda'))
          ..includeObject(['usuario_pointer']) // Inclui dados do criador
          ..whereEqualTo('objectId', widget.objectId);

    final ParseResponse response = await query.query();

    if (response.success &&
        response.results != null &&
        response.results!.isNotEmpty) {
      final demanda = response.results!.first as ParseObject;

      setState(() {
        _demanda = demanda;

        // Obtendo as imagens do campo array 'imagem'
        final List<dynamic>? imagensArray =
            demanda.get<List<dynamic>>('imagem');
        _imagens = imagensArray != null
            ? imagensArray.map((e) => (e as ParseFile).url!).toList()
            : [];

        // Obtendo o nome e a foto do criador
        final ParseObject? criador =
            demanda.get<ParseObject>('usuario_pointer');
        if (criador != null) {
          _criadorNome =
              criador.get<String>('username') ?? 'Criador desconhecido';
          final ParseFile? criadorFotoFile =
              criador.get<ParseFile>('profileImage');
          _criadorFoto =
              criadorFotoFile?.url; // Pega a URL da imagem do criador
        } else {
          _criadorNome = 'Criador não identificado';
          _criadorFoto = null;
        }
      });
    } else {
      debugPrint('Erro ao carregar a demanda: ${response.error?.message}');
    }
  }

  String _getTempoDecorrido() {
    final DateTime? createdAt = _demanda?.createdAt;

    if (createdAt == null) {
      return "Data desconhecida";
    }

    final Duration diferenca = DateTime.now().difference(createdAt);

    if (diferenca.inDays > 0) {
      return "À ${diferenca.inDays} dia(s)";
    } else if (diferenca.inHours > 0) {
      return "À ${diferenca.inHours} hora(s)";
    } else if (diferenca.inMinutes > 0) {
      return "À ${diferenca.inMinutes} minuto(s)";
    } else {
      return "Agora mesmo";
    }
  }

  Future<void> _enviarProposta() async {
    if (_valorController.text.isEmpty ||
        _dataEntregaController.text.isEmpty ||
        _whatsappController.text.isEmpty) {
      // Exibe mensagem de erro se algum campo não for preenchido
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Erro"),
            content: const Text("Todos os campos devem ser preenchidos."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    // Obtenha o usuário logado com 'await' para garantir que ele seja carregado
    final ParseUser? user = await ParseUser.currentUser();

    // Verifique se o usuário está logado
    if (user == null) {
      print("Usuário não logado");
      return;
    }

    // Pega o valor, a data de entrega e o número de WhatsApp
    double? valor = double.tryParse(_valorController.text
        .replaceAll('R\$', '')
        .replaceAll('.', '')
        .replaceAll(',', '.'));

    if (valor == null) {
      print("Valor inválido");
      return;
    }

    // Converte a data de entrega para DateTime
    DateTime? entrega =
        DateFormat('dd/MM/yyyy').parse(_dataEntregaController.text);

    // Criação do objeto Proposta
    final ParseObject proposta = ParseObject('Proposal')
      ..set('valor', valor) // Define o valor como numérico
      ..set('entrega', entrega) // Define a data de entrega
      ..set('telefone', _whatsappController.text) // Define o número de WhatsApp
      ..set('pointer_demanda', _demanda) // Define o ponteiro para a demanda
      ..set('pointer_user', user); // Define o ponteiro para o usuário logado

    // Salve a proposta e aguarde a resposta
    final ParseResponse response = await proposta.save();

    if (response.success) {
      print("Proposta enviada com sucesso!");
      // Exibe uma mensagem de sucesso
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sucesso"),
            content: const Text("Proposta enviada com sucesso."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      print("Erro ao enviar a proposta: ${response.error?.message}");
      // Exibe uma mensagem de erro
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Erro"),
            content:
                Text("Erro ao enviar a proposta: ${response.error?.message}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    if (_demanda == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Carregando..."),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildImageCarousel(screenWidth),
            _buildDescricao(),
            _buildDescricaoCompleta(),
            _buildEnviarPropostaButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF004AAD)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 16.0),
            child: Image.asset(
              'assets/imagens/logo.png',
              width: 60,
              height: 60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(double screenWidth) {
    return _imagens.isNotEmpty
        ? SafeArea(
            top: false,
            child: SizedBox(
              height: screenWidth,
              width: screenWidth,
              child: PageView.builder(
                itemCount: _imagens.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    _imagens[index],
                    fit: BoxFit.cover,
                    width: screenWidth,
                    height: screenWidth,
                  );
                },
              ),
            ),
          )
        : const SizedBox(
            height: 200,
            child: Center(child: Text("Nenhuma imagem disponível")),
          );
  }

  Widget _buildDescricao() {
    // Obtém o valor da demanda, formatando como moeda
    final num? valor = _demanda?.get<num>('valor'); // Suporta int e double
    final String valorFormatado = valor != null
        ? NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(valor)
        : 'Valor não informado';

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: _criadorFoto != null
                    ? NetworkImage(_criadorFoto!)
                    : const AssetImage('assets/imagens/default_avatar.png')
                        as ImageProvider,
                radius: 30,
              ),
              const SizedBox(width: 10),
              Text(
                _criadorNome ?? 'Criador desconhecido',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004AAD),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _demanda?.get<String>('titulo') ?? 'Sem título',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Text(
            valorFormatado,
            style: const TextStyle(fontSize: 16, color: Colors.green),
          ),
          const SizedBox(height: 8),
          Text(
            "${_getTempoDecorrido()} | ${_demanda?.get<String>('localizacao') ?? 'Localização desconhecida'}",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildDescricaoCompleta() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Descrição:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              _demanda?.get<String>('descricao') ?? 'Sem descrição',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnviarPropostaButton() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: const BoxDecoration(color: Colors.white),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: ElevatedButton.icon(
            onPressed: () => _showConfirmationDialog(context),
            icon: const Icon(
              Icons.send,
              color: Colors.white,
            ),
            label: const Text(
              "Enviar Proposta",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Enviar Proposta"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _valorController,
                  decoration: const InputDecoration(
                    labelText: "Valor",
                    prefixIcon: Icon(
                      Icons.monetization_on,
                      color: Color(0xFF004AAD),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Color(0xFF004AAD),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF004AAD)),
                    ),
                  ),
                  cursorColor: Color(0xFF004AAD),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _dataEntregaController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Data de Entrega",
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: Color(0xFF004AAD),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Color(0xFF004AAD),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF004AAD)),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: Colors.white,
                            colorScheme: ColorScheme.light(
                              primary: Color(0xFF004AAD),
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: Colors.black,
                            ),
                            dialogBackgroundColor: Colors.white,
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                      setState(() {
                        _dataEntregaController.text = formattedDate;
                      });
                    }
                  },
                ),
                TextField(
                  controller: _whatsappController,
                  decoration: const InputDecoration(
                    labelText: "WhatsApp",
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Color(0xFF004AAD),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Color(0xFF004AAD),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF004AAD)),
                    ),
                  ),
                  cursorColor: Color(0xFF004AAD),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  color: Color(0xFF004AAD),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                _enviarProposta(); // Chama a função para enviar a proposta
              },
              child: const Text(
                "Enviar",
                style: TextStyle(
                  color: Color(0xFF004AAD),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
              ),
            ),
          ],
        );
      },
    );
  }
}
