import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:searchfield/searchfield.dart';
import 'package:trabalho_conecta_work/pages/demanda.dart';

class Pesquisar extends StatefulWidget {
  @override
  _PesquisarState createState() => _PesquisarState();
}

class _PesquisarState extends State<Pesquisar> {
  final Color primaryColor = Color.fromRGBO(0, 74, 173, 1);

  final Map<String, IconData> categoryIcons = {
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

  List<String> categorias = [];
  int categoriasExibidas = 4;
  final TextEditingController _searchController = TextEditingController();
  bool showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _fetchCategorias();
    _searchController.addListener(_handleSearchChange);
  }

  Future<void> _fetchCategorias() async {
    try {
      final query = QueryBuilder<ParseObject>(ParseObject('Categoria'));
      final response = await query.query();

      if (mounted) {
        // Verifica se o widget ainda está montado
        if (response.success && response.results != null) {
          setState(() {
            categorias = response.results!
                .map<String>((result) => result.get<String>('nome') ?? '')
                .where((nome) => nome.isNotEmpty)
                .toList();
          });
        } else {
          _showSnackbar('Erro ao carregar categorias.');
          print('Erro ao buscar categorias: ${response.error?.message}');
        }
      }
    } catch (e) {
      if (mounted) {
        // Verifica se o widget ainda está montado
        _showSnackbar('Erro inesperado ao carregar categorias.');
      }
      print('Erro inesperado: $e');
    }
  }

  void _handleSearchChange() {
    if (mounted) {
      // Verifica se o widget ainda está montado
      setState(() {
        showSuggestions = _searchController.text.isNotEmpty;
      });
    }
  }

  List<SearchFieldListItem<String>> _getSuggestions(String query) {
    return categorias
        .where((categoria) =>
            categoria.toLowerCase().contains(query.toLowerCase()))
        .map((categoria) => SearchFieldListItem<String>(categoria))
        .toList();
  }

  void _clearSuggestions() {
    setState(() {
      showSuggestions = false;
    });
    _searchController.clear();
    FocusScope.of(context).unfocus();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: categorias.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: _clearSuggestions,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: SearchField<String>(
                          controller: _searchController,
                          hint: 'Procurar',
                          suggestions: showSuggestions
                              ? _getSuggestions(_searchController.text)
                              : [],
                          searchInputDecoration: SearchInputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: primaryColor, width: 2),
                            ),
                            hintText: 'Procurar',
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                          ),
                          onSuggestionTap: (item) {
                            final selectedCategory = item.item;
                            if (selectedCategory != null &&
                                selectedCategory.isNotEmpty) {
                              _clearSuggestions();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Demanda(categoria: selectedCategory),
                                ),
                              );
                            } else {
                              _showSnackbar('Erro ao selecionar categoria.');
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: categorias.isEmpty
                          ? Center(
                              child: Text(
                                'Sem categorias disponíveis.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1.5,
                              ),
                              itemCount: categoriasExibidas,
                              itemBuilder: (context, index) {
                                final categoryName = categorias[index];
                                final categoryIcon =
                                    categoryIcons[categoryName.toLowerCase()] ??
                                        Icons.category;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Demanda(categoria: categoryName),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        categoryIcon,
                                        size: 40,
                                        color: primaryColor,
                                      ),
                                      SizedBox(height: 7),
                                      Text(
                                        categoryName,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: primaryColor,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
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
                                style: TextStyle(color: primaryColor),
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
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
    );
  }
}
