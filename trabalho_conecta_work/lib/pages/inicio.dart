import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  // Lista de banners (imagens)
  final List<String> banners = [
    'assets/imagens/banner1.jpg',
    'assets/imagens/banner4.jpg',
    'assets/imagens/banner3.jpg',
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
      backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carrossel de banners com fundo azul e bordas arredondadas
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                ),
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150,
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
                            width: _currentIndex == index ? 12 : 8,
                            height: _currentIndex == index ? 12 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? const Color(0xFF004AAD)
                                  : Colors.grey,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Seção "Serviços Populares" com fundo azul, bordas arredondadas
              Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      color: Color.fromARGB(255, 235, 235, 235), // Cor da linha
                      thickness: 3, // Espessura da linha
                    ),
                    Text(
                      'Serviços Populares',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color.fromARGB(255, 0, 0, 0), // Cor do texto
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
                          return Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF004AAD),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: FaIcon(
                                      servico['icone'],
                                      size: 40,
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255), // Cor do ícone
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  servico['nome'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(
                                        255, 0, 0, 0), // Cor do nome do serviço
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Divider(
                                  color: Color.fromARGB(
                                      255, 235, 235, 235), // Cor da linha
                                  thickness: 3, // Espessura da linha
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: const Color(0xFF004AAD),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Demandas Próximas',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color.fromARGB(255, 255, 255, 255),
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
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                demanda['distancia'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
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
