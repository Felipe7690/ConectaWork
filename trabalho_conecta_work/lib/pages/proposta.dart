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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchProposals();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchProposals() async {
    final ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;

    if (currentUser == null) {
      print('Erro: Não há usuário logado');
      return;
    }

    try {
      // Consulta para propostas enviadas
      QueryBuilder<ParseObject> sentQuery = QueryBuilder<ParseObject>(ParseObject('Proposal'))
        ..whereEqualTo('pointer_user', currentUser)
        ..includeObject(['pointer_demanda.usuario_pointer']); // Inclui demanda e usuário responsável

      // Consulta para propostas recebidas
      QueryBuilder<ParseObject> receivedQuery = QueryBuilder<ParseObject>(ParseObject('Proposal'))
        ..whereEqualTo('pointer_demanda.usuario_pointer', currentUser)
        ..includeObject(['pointer_demanda', 'pointer_user']); // Inclui a demanda e o usuário que enviou

      // Executa as consultas em paralelo
      final responses = await Future.wait([sentQuery.query(), receivedQuery.query()]);

      final ParseResponse sentResponse = responses[0];
      final ParseResponse receivedResponse = responses[1];

      if (sentResponse.success && receivedResponse.success) {
        setState(() {
          sentProposals = List<ParseObject>.from(sentResponse.results ?? []);
          receivedProposals = List<ParseObject>.from(receivedResponse.results ?? []);
        });
      }
    } catch (e) {
      print('Erro ao buscar propostas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Propostas', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 74, 173),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Enviadas'),
            Tab(text: 'Recebidas'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProposalList(sentProposals, 'Enviada'),
          _buildProposalList(receivedProposals, 'Recebida'),
        ],
      ),
    );
  }

  Widget _buildProposalList(List<ParseObject> proposals, String type) {
    if (proposals.isEmpty) {
      return Center(
        child: Text('Nenhuma proposta $type.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: proposals.length,
      itemBuilder: (context, index) {
        final proposal = proposals[index];

        ParseObject? demandaPointer = proposal.get<ParseObject>('pointer_demanda');
        ParseObject? userPointer;

        if (type == 'Recebida') {
          userPointer = proposal.get<ParseObject>('pointer_user'); // Quem enviou a proposta
        } else if (type == 'Enviada') {
          userPointer = demandaPointer?.get<ParseObject>('usuario_pointer'); // Recebedor
        }

        final demandTitle = demandaPointer?.get<String>('titulo') ?? 'Título não disponível';
        final demandLocate = demandaPointer?.get<String>('localizacao') ?? 'Localização não informada';
        final senderName = userPointer?.get<String>('username') ?? 'Usuário desconhecido';

        final telefone = proposal.get<String>('telefone') ?? 'N/A';
        final entrega = proposal.get<DateTime>('entrega')?.toLocal().toString() ?? 'Sem data';

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text('Demanda: $demandTitle'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Localização: $demandLocate'),
                Text('Telefone: $telefone'),
                Text('Data de Entrega: $entrega'),
                if (type == 'Enviada') Text('Recebedor: $senderName'),
                if (type == 'Recebida') Text('Enviado por: $senderName'),
              ],
            ),
          ),
        );
      },
    );
  }
}
