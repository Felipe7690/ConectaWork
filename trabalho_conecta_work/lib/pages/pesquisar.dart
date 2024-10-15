import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Pesquisar extends StatefulWidget {
  @override
  _PesquisarState createState() => _PesquisarState();
}

class _PesquisarState extends State<Pesquisar> with WidgetsBindingObserver {
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

  final List<IconData> iconesCategorias = [
    FontAwesomeIcons.boltLightning,
    FontAwesomeIcons.wrench,
    FontAwesomeIcons.paintRoller,
    FontAwesomeIcons.tree,
    FontAwesomeIcons.broom,
    FontAwesomeIcons.toolbox,
    FontAwesomeIcons.gear,
    FontAwesomeIcons.soap,
  ];

  int categoriasExibidas = 4;
  final FocusNode _focusNode = FocusNode();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Remove o foco e limpa as sugestões ao mudar de tela
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _focusNode.unfocus();
      _searchController.clear();
    }
  }

  // Filtra as categorias conforme o texto digitado
  List<SearchFieldListItem<String>> _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      return categorias
          .where((categoria) =>
              categoria.toLowerCase().contains(query.toLowerCase()))
          .map((e) => SearchFieldListItem<String>(e))
          .toList();
    }
    return [];
  }

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
                  borderRadius: BorderRadius.circular(30),
                ),
                child: SearchField<String>(
                  controller: _searchController,
                  focusNode: _focusNode,
                  suggestions: [],
                  suggestionState: Suggestion.hidden, // Inicialmente escondido
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
                  onSuggestionTap: (SearchFieldListItem<String> item) {
                    print('Categoria selecionada: ${item.item}');
                  },
                  onSearchTextChanged: (query) => _onSearchChanged(query),
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
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 10),

            // Grid de ícones de categorias
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
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
                      SizedBox(height: 7),
                      Text(
                        categorias[index],
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(0, 74, 173, 1),
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
                          categoriasExibidas = categorias.length;
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
                          categoriasExibidas = 4;
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
