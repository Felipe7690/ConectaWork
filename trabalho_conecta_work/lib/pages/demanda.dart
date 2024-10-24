import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Demanda extends StatelessWidget {
  final String categoria;

  const Demanda({Key? key, required this.categoria}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              // Texto que fica após o título da demanda
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Text(
                    'Essas são as demandas próximas de você',
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Exibição das demandas
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 10, // Espaçamento horizontal
                  runSpacing: 20, // Espaçamento vertical
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width - 40) / 2,
                      child: Column(
                        children: [
                          // Imagem para cada demanda
                          Container(
                            height: 150, // Altura fixa
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[300],
                            ),
                            child: Image.asset(
                              "assets/imagens/eletrico.jpg", // Verifique o caminho da imagem
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
                              },
                            ),
                          ),
                          // Texto abaixo da imagem
                          Padding(
                            padding: const EdgeInsets.only(left: 2, top: 8),
                            child: Text(
                              "Demanda ${index + 1}",
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
