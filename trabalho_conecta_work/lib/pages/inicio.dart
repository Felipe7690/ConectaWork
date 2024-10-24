import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trabalho_conecta_work/pages/demanda.dart'; // Importe a página Demanda

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  // Lista de banners (imagens)
  final List<String> banners = [
    'assets/imagens/banner1.jpg',
    'assets/imagens/banner3.jpg',
  ];

  final List<String> categorias = [
    'Eletricista',
    'Encanador',
    'Pintor',
    'Jardinagem',
    'Faxina',
    'Reparos Gerais',
    'Montagem',
    'Limpeza Pós-Obra',
  ];

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

  final List<Map<String, dynamic>> demandasProximas = const [
    {
      'titulo': 'Reparo de encanamento',
      'localizacao': 'Centro, Cidade A',
      'distancia': '2 km'
    },
    {
      'titulo': 'Instalação elétrica',
      'localizacao': 'Bairro B, Cidade A',
      'distancia': '5 km'
    },
    {
      'titulo': 'Pintura de apartamento',
      'localizacao': 'Bairro C, Cidade A',
      'distancia': '7 km'
    },
    {
      'titulo': 'Jardinagem',
      'localizacao': 'Bairro D, Cidade B',
      'distancia': '10 km'
    },
  ];

  int _currentIndex = 0; // Índice atual da página no carrossel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 0), // Remover o espaço superior
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                top: false, // Mantém o SafeArea se necessário
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 40, // Mantém o espaçamento inferior
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 170,
                        child: PageView.builder(
                          itemCount: banners.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex =
                                  index; // Atualiza o indicador de página
                            });
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10), // Espaço entre as imagens
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  banners[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Indicador de pontos para o carrossel
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(banners.length, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentIndex == index ? 8 : 6,
                            height: _currentIndex == index ? 8 : 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? const Color(
                                      0xFFFFFFFF) // Cor branca para o ponto ativo
                                  : Colors.grey,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),

              // Seção "Serviços Populares" com fundo branco
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: const Text(
                        'Serviços Populares',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 0, 0), // Cor do texto
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: servicosPopulares
                            .length, // Quantidade de serviços populares
                        itemBuilder: (context, index) {
                          final servico = servicosPopulares[index];
                          return GestureDetector(
                            onTap: () {
                              // Navega para a página de Demanda e passa a categoria selecionada
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Demanda(categoria: categorias[index]),
                                ),
                              );
                            },
                            child: Container(
                              width: 120,
                              margin: const EdgeInsets.only(right: 2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 0,
                                          blurRadius: 2,
                                          offset: const Offset(4, 4),
                                        )
                                      ],
                                      color: const Color.fromARGB(
                                          255, 251, 251, 251),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: FaIcon(
                                        servico['icone'],
                                        size: 40,
                                        color: const Color(
                                            0xFF004AAD), // Cor do ícone
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    servico['nome'],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 0, 0,
                                          0), // Cor do nome do serviço
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

              // Outras seções da página
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Demandas Próximas',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Feed de demandas próximas
                    ListView.builder(
                      shrinkWrap:
                          true, // Permite que o ListView seja usado dentro de uma coluna
                      physics:
                          const NeverScrollableScrollPhysics(), // Evita rolagem interna
                      itemCount: demandasProximas.length,
                      itemBuilder: (context, index) {
                        final demanda = demandasProximas[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3), // Mudança da sombra
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                demanda['titulo'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF004AAD),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                demanda['localizacao'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                demanda['distancia'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
