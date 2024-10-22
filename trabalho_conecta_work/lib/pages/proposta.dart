import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trabalho_conecta_work/components/my_app_bar.dart';

class Proposta extends StatefulWidget {
  const Proposta({super.key});

  @override
  State<Proposta> createState() => _PropostaState();
}

class _PropostaState extends State<Proposta>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: MyAppBar(),
      body: Column(
        children: [
          Container(
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white, // Cor do fundo do indicador
                borderRadius: BorderRadius.circular(5), // Bordas arredondadas
              ),
              indicatorPadding: EdgeInsets.symmetric(horizontal: 2),
              labelColor: Color(0xFF004AAD), // Cor do texto da aba selecionada
              unselectedLabelColor:
                  Colors.white, // Cor do texto das abas não selecionadas
              tabs: [
                Tab(
                  icon: FaIcon(FontAwesomeIcons.arrowUpRightFromSquare),
                  text: 'Enviadas',
                ),
                Tab(
                  icon: FaIcon(FontAwesomeIcons.box),
                  text: 'Recebidas',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Propostas Enviadas
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: const [
                    ListTile(
                      title: Text('Proposta 1 - Enviada'),
                      subtitle: Text('Detalhes da proposta enviada'),
                    ),
                    ListTile(
                      title: Text('Proposta 2 - Enviada'),
                      subtitle: Text('Detalhes da proposta enviada'),
                    ),
                  ],
                ),
                // Propostas Recebidas
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: const [
                    ListTile(
                      title: Text('Proposta 1 - Recebida'),
                      subtitle: Text('Detalhes da proposta recebida'),
                    ),
                    ListTile(
                      title: Text('Proposta 2 - Recebida'),
                      subtitle: Text('Detalhes da proposta recebida'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
