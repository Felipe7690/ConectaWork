import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Pesquisar extends StatefulWidget {
  @override
  _PesquisarState createState() => _PesquisarState();
}

class _PesquisarState extends State<Pesquisar> {
  // Lista de categorias de exemplo
  final List<String> categorias = [
    'Eletricista',
    'Encanador',
    'Pintor',
    'Jardinagem',
    'Faxina',
    'Reparos Gerais',
    'Serviços de Montagem',
    'Limpeza Pós-Obra',
  ];

  // Ícones para as categorias
  final List<IconData> iconesCategorias = [
    FontAwesomeIcons.boltLightning, // Ícone de Eletricista
    FontAwesomeIcons.wrench, // Ícone de Encanador
    FontAwesomeIcons.paintRoller, // Ícone de Pintor
    FontAwesomeIcons.tree, // Ícone de Jardinagem
    FontAwesomeIcons.broom, // Ícone de Faxina
    FontAwesomeIcons.toolbox, // Ícone de Reparos Gerais
    FontAwesomeIcons.gear, // Ícone de Serviços de Montagem
    FontAwesomeIcons.soap, // Ícone de Limpeza Pós-Obra
  ];

  // Número de categorias exibidas
  int categoriasExibidas = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de pesquisa
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: SearchField(
                  suggestions:
                      categorias.map((e) => SearchFieldListItem(e)).toList(),
                  suggestionState: Suggestion.expand,
                  hint: 'Procurar',
                  searchInputDecoration: SearchInputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color.fromRGBO(0, 74, 173, 1),
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(0, 74, 173, 1),
                      ),
                    ),
                  ),
                  itemHeight: 50,
                  onSuggestionTap: (SearchFieldListItem<dynamic> item) {
                    print('Categoria selecionada: ${item.item}');
                  },
                ),
              ),
            ),

            // Texto informativo centralizado
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Escolha a categoria de serviço desejado',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                  textAlign: TextAlign.center, // Centraliza o texto
                ),
              ),
            ),

            SizedBox(height: 10), // Espaço entre o texto e a grid

            // Grid de ícones de categorias
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 colunas
                  crossAxisSpacing: 8, // Espaçamento horizontal entre os ícones
                  mainAxisSpacing: 8, // Espaçamento vertical entre os ícones
                  childAspectRatio: 1.5,
                ),
                itemCount: categoriasExibidas,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        iconesCategorias[index],
                        size: 40,
                        color: Color.fromRGBO(0, 74, 173, 1),
                      ),
                      SizedBox(
                          height: 7), // Espaçamento entre o ícone e o texto
                      Text(
                        categorias[index],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),

            // Botão "Ver mais" ou "Ver menos"
            Center(
              child: categoriasExibidas < categorias.length
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          categoriasExibidas =
                              categorias.length; // Exibir todas as categorias
                        });
                      },
                      child: Text(
                        'Ver mais categorias',
                        style: TextStyle(color: Color.fromRGBO(0, 74, 173, 1)),
                      ),
                    )
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          categoriasExibidas = 4; // Reduz para o número inicial
                        });
                      },
                      child: Text(
                        'Ver menos categorias',
                        style: TextStyle(color: Color.fromRGBO(0, 74, 173, 1)),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
