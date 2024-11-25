import 'package:flutter/material.dart';
import 'package:trabalho_conecta_work/pages/demanda.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final List<String> banners = [
    'assets/imagens/banner1.jpg',
    'assets/imagens/banner3.jpg',
  ];

  List<Map<String, dynamic>> servicosPopulares = []; // Lista vazia inicialmente

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

  int _currentIndex = 0;

  final Map<String, IconData> categoryIcons = {
    'teste': Icons.assignment,
    'segurança': Icons.security,
    'vendas': Icons.shopping_cart,
    'eventos': Icons.event,
    'transporte': Icons.directions_car,
    'limpeza': Icons.cleaning_services,
    'consultoria': Icons.support_agent,
    'design': Icons.design_services,
    'marketing': Icons.campaign,
    'educação': Icons.school,
    'saúde': Icons.local_hospital,
    'construção': Icons.construction,
    'tecnologia': Icons.computer,
  };

  IconData _getIconForCategory(String nome) {
    final lowerCaseName = nome.toLowerCase().trim();
    return categoryIcons[lowerCaseName] ?? Icons.help_outline; // Ícone genérico
  }

  Future<void> _fetchCategorias() async {
    final query = QueryBuilder(ParseObject('Categoria'));
    final response = await query.query();

    if (response.success && response.results != null) {
      List<Map<String, dynamic>> categoriasList = [];
      for (var item in response.results!) {
        final nome = item.get<String>('nome') ?? 'Desconhecida';
        categoriasList.add({
          'nome': nome,
          'icone': _getIconForCategory(nome), // Ícone baseado no mapa
        });
      }

      setState(() {
        servicosPopulares = categoriasList;
      });
    } else {
      print('Erro ao buscar categorias: ${response.error?.message}');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 40),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 170,
                        child: PageView.builder(
                          itemCount: banners.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                  ? const Color(0xFFFFFFFF)
                                  : Colors.grey,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
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
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: servicosPopulares.length,
                        itemBuilder: (context, index) {
                          final servico = servicosPopulares[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Demanda(categoria: servico['nome']),
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
                                          blurRadius: 2,
                                          offset: const Offset(4, 4),
                                        )
                                      ],
                                      color: const Color(0xFFF7F7F7),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        servico['icone'],
                                        size: 40,
                                        color: const Color(0xFF004AAD),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    servico['nome'],
                                    style: const TextStyle(fontSize: 15),
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
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Demandas Próximas',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                                'Distância: ${demanda['distancia']}',
                                style: const TextStyle(
                                  fontSize: 14,
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
