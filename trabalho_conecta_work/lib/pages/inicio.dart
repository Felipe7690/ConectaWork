import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  // Lista de serviços populares
  final List<Map<String, dynamic>> servicosPopulares = const [
    {'nome': 'Eletricista', 'icone': FontAwesomeIcons.boltLightning},
    {'nome': 'Encanador', 'icone': FontAwesomeIcons.wrench},
    {'nome': 'Pintor', 'icone': FontAwesomeIcons.paintRoller},
    {'nome': 'Jardinagem', 'icone': FontAwesomeIcons.tree},
    {'nome': 'Faxina', 'icone': FontAwesomeIcons.broom},
    {'nome': 'Reparos Gerais', 'icone': FontAwesomeIcons.toolbox},
    {'nome': 'Montagem', 'icone': FontAwesomeIcons.gear},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner com espaçamento lateral
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20), // Espaçamento lateral
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/imagens/banner1.png',
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
              SizedBox(
                  height: 20), // Espaço entre o banner e a seção de serviços

              // Seção "Serviços Populares" com fundo azul e sem bordas nas laterais
              Container(
                padding: EdgeInsets.all(10), // Padding interno da seção
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 74, 173, 1), // Fundo azul
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título da seção "Serviços Populares" centralizado
                    Center(
                      child: Text(
                        'Serviços Populares',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Cor do texto em branco
                        ),
                        textAlign: TextAlign.center, // Centraliza o texto
                      ),
                    ),
                    SizedBox(height: 10),

                    // Carrossel horizontal de serviços populares
                    SizedBox(
                      height: 130, // Altura do carrossel
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // Direção horizontal
                        itemCount: servicosPopulares.length,
                        itemBuilder: (context, index) {
                          final servico = servicosPopulares[index];
                          return GestureDetector(
                            onTap: () {
                              // Ação ao clicar no serviço
                            },
                            child: Container(
                              width: 120, // Largura de cada item no carrossel
                              margin: EdgeInsets.only(
                                  right: 10), // Espaço entre os itens
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Contêiner para criar a bola branca
                                  Container(
                                    width: 60, // Largura da bola
                                    height: 60, // Altura da bola
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle, // Forma circular
                                      color: Colors.white, // Cor branca
                                    ),
                                    child: Center(
                                      child: Icon(
                                        servico['icone'],
                                        size: 30,
                                        color: Color.fromRGBO(
                                            0, 74, 173, 1), // Ícone azul
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    servico['nome'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors
                                          .white, // Cor do texto em branco
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
