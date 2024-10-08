import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class Pesquisar extends StatelessWidget {
  // Lista de categorias de exemplo
  final List<String> categorias = [
    'Eletricista',
    'Encanador',
    'Pintor',
    'Jardinagem',
    'Faxina',
    'Reparos Gerais',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 248, 248, 1),
      body: Column(
        children: [
          // Container para empurrar o campo de busca abaixo da AppBar
          Container(
            height: 56.0, // Altura padrão da AppBar
            color: Colors.transparent, // Pode ser transparente ou outra cor
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchField(
              suggestions:
                  categorias.map((e) => SearchFieldListItem(e)).toList(),
              suggestionState: Suggestion.expand,
              hint: 'Procurar',
              searchInputDecoration: SearchInputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              itemHeight: 50,
              onSuggestionTap: (SearchFieldListItem<dynamic> item) {
                // Lógica ao selecionar uma categoria
                print('Categoria selecionada: ${item.item}');
              },
            ),
          ),
        ],
      ),
    );
  }
}
