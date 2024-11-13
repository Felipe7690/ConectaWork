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
      print('Error: Não há usuário logado');
      return;
    }

    // Consulta para buscar propostas enviadas
    QueryBuilder<ParseObject> sentQuery = QueryBuilder<ParseObject>(ParseObject('Proposal'))
      ..whereEqualTo('type', 'sent')
      ..whereEqualTo('user', currentUser);

    // Consulta para buscar propostas recebidas
    QueryBuilder<ParseObject> receivedQuery = QueryBuilder<ParseObject>(ParseObject('Proposal'))
      ..whereEqualTo('type', 'received')
      ..whereEqualTo('user', currentUser);

    try {
      final ParseResponse sentResponse = await sentQuery.query();
      final ParseResponse receivedResponse = await receivedQuery.query();

      if (sentResponse.success && receivedResponse.success) {
        setState(() {
          sentProposals = List<ParseObject>.from(sentResponse.results ?? []);
          receivedProposals = List<ParseObject>.from(receivedResponse.results ?? []);
        });
      }
    } catch (e) {
      print('Erro ao buscar propostas $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Propostas'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Enviadas'),
            Tab(text: 'Recebidas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProposalList(sentProposals),
          _buildProposalList(receivedProposals),
        ],
      ),
    );
  }

  //Retorna o Conteúdo
  Widget _buildProposalList(List<ParseObject> proposals) {
    if (proposals.isEmpty) {
      return Container();
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: proposals.length,
      itemBuilder: (context, index) {
        final proposal = proposals[index];
        final title = proposal.get<String>('title') ?? 'Sem titulo';
        final details = proposal.get<String>('detail') ?? 'Sem detalhes';

        return ListTile(
          title: Text(title),
          subtitle: Text(details),
        );
      },
    );
  }
}
