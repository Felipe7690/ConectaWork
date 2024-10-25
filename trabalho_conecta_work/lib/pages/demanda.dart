import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Demanda extends StatelessWidget {
  final String categoria;

  const Demanda({Key? key, required this.categoria}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 251, 251),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120.0, // Altura do topo
              floating: false,
              pinned: true, // Pinned faz com que a AppBar fique fixa ao rolar
              backgroundColor: const Color(0xFF004AAD),
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  categoria,
                  style: const TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo e botão de voltar
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16, left: 16), // Ajuste aqui
                      child: Image.asset(
                        "assets/imagens/logo_b.png",
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 16.0), // Ajuste aqui
                      child: IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 50, left: 5),
                  child: Text(
                    'Demandas próximas de você',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              // Localização do usuário
              Container(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 25, left: 5),
                  child: Text(
                    'Localização: Cidade A, Bairro B',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),

              // Exibição das demandas
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 5, // Espaçamento horizontal
                    runSpacing: 5, // Espaçamento vertical
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 25) / 2,
                        child: Column(
                          children: [
                            // Imagem e Avatar para cada demanda
                            Container(
                              height:
                                  300, // Altura fixa do container da demanda
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: Column(
                                children: [
                                  // Avatar alinhado à esquerda
                                  Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius:
                                              15, // Tamanho reduzido do avatar
                                          backgroundImage: NetworkImage(
                                              'https://avatars.githubusercontent.com/u/116851523?v=4'),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "Douglas Cássio",
                                            style: TextStyle(
                                              color: Color(0xFF004AAD),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Imagem principal da demanda
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Image.asset(
                                      "assets/imagens/eletrico.jpg",
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.error);
                                      },
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      Container(
                                        width: 160,
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "Contratamos eletricista com experiência para serviços de manutenção e instalação elétrica.",
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 16),
                                          maxLines: 3, // Limitar a 3 linhas
                                          overflow: TextOverflow
                                              .ellipsis, // Adicionar reticências
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
