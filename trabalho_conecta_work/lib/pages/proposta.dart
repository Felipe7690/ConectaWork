import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ProposalScreen extends StatefulWidget {
  @override
  _ProposalScreenState createState() => _ProposalScreenState();
}

class _ProposalScreenState extends State<ProposalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ParseObject> sentProposals = [];
  List<ParseObject> receivedProposals = [];
  bool isLoading = true; // Estado de carregamento

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeProposals(); // Inicializa as propostas assim que o usuário logar
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Função para criar propostas vazias no banco assim que o usuário logar
  Future<void> _initializeProposals() async {
  // Verifica se o usuário está autenticado corretamente
  final currentUser = ParseUser.currentUser();

  if (currentUser == null) {
    // Se não estiver autenticado, exibe uma mensagem ou redireciona para login
    print('Usuário não autenticado!');
    return;
  }

  // Se o usuário estiver autenticado, cria as propostas vazias
  await _createEmptyProposals(currentUser as ParseUser);

  // Após garantir que as propostas vazias foram criadas, carrega as propostas
  _fetchProposals();
}


  // Função para criar propostas vazias
  Future<void> _createEmptyProposals(ParseUser currentUser) async {
    // Criação de proposta enviada vazia
    final sentProposal = ParseObject('Proposal')
      ..set('type', 'sent')
      ..set('user', currentUser)
      ..set('title', '')
      ..set('detail', '');
    
    // Criação de proposta recebida vazia
    final receivedProposal = ParseObject('Proposal')
      ..set('type', 'received')
      ..set('user', currentUser)
      ..set('title', '')
      ..set('detail', '');

    // Envia as propostas para o Parse Server
    await sentProposal.save();
    await receivedProposal.save();
  }

  // Função para buscar as propostas enviadas e recebidas do banco
  Future<void> _fetchProposals() async {
    setState(() {
      isLoading = true; // Ativa o estado de carregamento
    });

    // Consulta para buscar propostas enviadas
    QueryBuilder<ParseObject> sentQuery = QueryBuilder<ParseObject>(ParseObject('Proposal'))
      ..whereEqualTo('type', 'sent')
      ..whereEqualTo('user', ParseUser.currentUser()!); // Filtro para o usuário logado

    // Consulta para buscar propostas recebidas
    QueryBuilder<ParseObject> receivedQuery = QueryBuilder<ParseObject>(ParseObject('Proposal'))
      ..whereEqualTo('type', 'received')
      ..whereEqualTo('user', ParseUser.currentUser()!); // Filtro para o usuário logado

    try {
      // Realiza as requisições
      final ParseResponse sentResponse = await sentQuery.query();
      final ParseResponse receivedResponse = await receivedQuery.query();

      // Verifica se as requisições foram bem-sucedidas
      if (sentResponse.success && receivedResponse.success) {
        setState(() {
          // Fazendo o cast para List<ParseObject> explicitamente
          sentProposals = List<ParseObject>.from(sentResponse.results ?? []);
          receivedProposals = List<ParseObject>.from(receivedResponse.results ?? []);
          isLoading = false; // Desativa o estado de carregamento
        });
      } else {
        // Caso a consulta falhe
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('Failed to fetch proposals.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('An error occurred: $e');
    }
  }

  // Função para exibir um diálogo de erro
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proposals'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Sent'),
            Tab(text: 'Received'),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Exibe o indicador de carregamento
          : TabBarView(
              controller: _tabController,
              children: [
                _buildProposalList(sentProposals, 'No proposals sent'),
                _buildProposalList(receivedProposals, 'No proposals received'),
              ],
            ),
    );
  }

  // Função que retorna o layout das propostas (lista)
  Widget _buildProposalList(List<ParseObject> proposals, String emptyMessage) {
    if (proposals.isEmpty) {
      return Center(child: Text(emptyMessage));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: proposals.length,
      itemBuilder: (context, index) {
        final proposal = proposals[index];
        final title = proposal.get<String>('title') ?? 'No title'; // Usando a coluna 'title'
        final details = proposal.get<String>('detail') ?? 'No details'; // Usando a coluna 'detail'

        return ListTile(
          title: Text(title),
          subtitle: Text(details),
        );
      },
    );
  }
}
