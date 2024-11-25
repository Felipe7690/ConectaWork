import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trabalho_conecta_work/pages/desc_demanda.dart';
import 'package:url_launcher/url_launcher.dart';

class Demanda extends StatefulWidget {
  final String categoria;

  const Demanda({Key? key, required this.categoria}) : super(key: key);

  @override
  _DemandaState createState() => _DemandaState();
}

class _DemandaState extends State<Demanda> {
  String? userCity;
  String? userState;
  String? userCountry;
  Position? userPosition;

  List<ParseObject> demandas = [];
  bool isLoading = true;
  bool _isPermissionRequested =
      false; // Variável para controlar a solicitação de permissão

  Future<void> _checkGPSStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Se o GPS não estiver ativado, solicita ao usuário que ative o GPS.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GPS desativado. Por favor, ative-o.')),
      );

      // Opção de abrir configurações do GPS
      Geolocator.openLocationSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _fetchDemandas();
    _checkGPSStatus(); // Verifica se o GPS está ativado
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    if (_isPermissionRequested) return; // Evita solicitações duplicadas

    _isPermissionRequested =
        true; // Marca que a solicitação de permissão está em andamento

    // Solicita permissão de localização
    PermissionStatus permission = await Permission.location.request();

    if (permission.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        userPosition = position;

        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];

          if (mounted) {
            setState(() {
              userCity = place.locality ?? "Cidade não disponível";
              userState = place.administrativeArea ?? "Estado não disponível";
              userCountry = place.country ?? "País não disponível";
            });
          }
        } else {
          _setDefaultLocationValues("Localização não encontrada");
        }
      } catch (e) {
        _setDefaultLocationValues("Erro ao obter localização");
        print("Erro: $e");
      }
    } else {
      // Se a permissão não for concedida, pede para o usuário dar permissão
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Permissão para usar a localização não concedida.')),
      );
      // Você pode redirecionar o usuário para as configurações do aplicativo para dar permissão
      openAppSettings();
    }

    _isPermissionRequested =
        false; // Libera a flag após a permissão ser processada
  }

  void _setDefaultLocationValues(String errorMessage) {
    if (mounted) {
      // Verificação se o widget ainda está montado
      setState(() {
        userCity = errorMessage;
        userState = "Estado não disponível";
        userCountry = "País não disponível";
      });
    }
  }

  Future<void> _fetchDemandas() async {
    try {
      // Consulta para encontrar a categoria
      final queryCategoria = QueryBuilder<ParseObject>(ParseObject('Categoria'))
        ..whereEqualTo('nome', widget.categoria);

      final responseCategoria = await queryCategoria.query();

      if (responseCategoria.success && responseCategoria.results != null) {
        final categoria = responseCategoria.results!.first as ParseObject;
        final categoriaId = categoria.objectId!;

        // Consulta para buscar as demandas relacionadas à categoria
        final queryDemanda = QueryBuilder<ParseObject>(ParseObject('Demanda'))
          ..whereEqualTo('categoria_pointer',
              ParseObject('Categoria')..objectId = categoriaId)
          ..includeObject(['usuario_pointer']) // Incluindo o ponteiro
          ..orderByDescending('createdAt');

        final responseDemanda = await queryDemanda.query();

        if (responseDemanda.success && responseDemanda.results != null) {
          if (mounted) {
            // Verificação se o widget ainda está montado
            setState(() {
              demandas = responseDemanda.results as List<ParseObject>;
              isLoading = false;

              // Adicionar dados do criador diretamente no objeto de demanda
              for (var demanda in demandas) {
                final criador = demanda.get<ParseObject>(
                    'usuario_pointer'); // Obtém o criador da demanda
                if (criador != null) {
                  // Recupera o nome do criador
                  final criadorNome =
                      criador.get<String>('username') ?? 'Criador desconhecido';

                  // Recupera a foto do perfil, se existir
                  final fotoFile = criador.get<ParseFile>('profileImage');
                  final criadorFoto =
                      fotoFile?.url; // Obtém a URL da foto, caso exista

                  // Se não houver foto, atribui uma foto padrão
                  final fotoUrl = criadorFoto ?? '';

                  // Atribuindo à demanda
                  demanda.set<String>('criador_nome', criadorNome);
                  demanda.set<String>('criador_foto', fotoUrl);
                }
              }
            });
          }
        } else {
          if (mounted) {
            // Verificação se o widget ainda está montado
            setState(() {
              demandas = [];
              isLoading = false; // Para o carregamento
            });
          }
          print('Nenhuma demanda encontrada.');
        }
      } else {
        if (mounted) {
          // Verificação se o widget ainda está montado
          setState(() {
            demandas = [];
            isLoading = false; // Para o carregamento
          });
        }
        print('Categoria não encontrada.');
      }
    } catch (e) {
      if (mounted) {
        // Verificação se o widget ainda está montado
        setState(() {
          demandas = [];
          isLoading = false; // Para o carregamento
        });
      }
      print('Erro ao buscar demandas: $e');
    }
  }

  Future<void> _openMap() async {
    if (userPosition != null) {
      final latitude = userPosition!.latitude;
      final longitude = userPosition!.longitude;
      final googleMapsUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl),
            mode: LaunchMode.externalApplication);
      } else {
        print("Não foi possível abrir o mapa.");
      }
    } else {
      print("Coordenadas não disponíveis.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 30) / 2;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 130.0,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF004AAD),
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  widget.categoria,
                  style: const TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, left: 16),
                      child: Image.asset(
                        "assets/imagens/logo_b.png",
                        height: 60,
                        width: 60,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
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
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : demandas.isEmpty
                ? const Center(child: Text('Nenhuma demanda encontrada.'))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 25, bottom: 10, left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Demandas próximas de você',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                InkWell(
                                  onTap: _openMap,
                                  child: Text(
                                    userCity != null &&
                                            userState != null &&
                                            userCountry != null
                                        ? 'Sua localização: ${userCity ?? ''}, ${userState ?? ''}, ${userCountry ?? ''}'
                                        : 'Localização não disponível',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: isLoading
                              ? const CircularProgressIndicator() // Mostra um indicador de carregamento
                              : demandas.isEmpty
                                  ? const Text(
                                      'Nenhuma demanda encontrada') // Mostra mensagem se não houver dados
                                  : Wrap(
                                      spacing: 5,
                                      runSpacing: 5,
                                      children: demandas.map((demanda) {
                                        final titulo =
                                            demanda.get<String>('titulo') ??
                                                'Sem título';
                                        final descricao =
                                            demanda.get<String>('descricao') ??
                                                'Sem descrição';

                                        // Acessa a imagem da demanda
                                        final imagemList =
                                            demanda.get<List>('imagem');
                                        final imagemUrl = (imagemList != null &&
                                                imagemList.isNotEmpty)
                                            ? (imagemList[0] as ParseFile).url
                                            : null;

                                        // Obtendo o nome e foto do criador da demanda
                                        final criadorNome = demanda
                                                .get<String>('criador_nome') ??
                                            'Criador desconhecido';
                                        final criadorFoto =
                                            demanda.get<String>('criador_foto');

                                        return SizedBox(
                                          width: itemWidth,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DescDemanda(
                                                          objectId: demanda
                                                              .objectId!),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Container(
                                                height: 280,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Row(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundImage: criadorFoto !=
                                                                    null
                                                                ? NetworkImage(
                                                                    criadorFoto)
                                                                : const AssetImage(
                                                                        'assets/imagens/default_avatar.png')
                                                                    as ImageProvider,
                                                            radius: 15,
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Expanded(
                                                            child: Text(
                                                              criadorNome,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                    0xFF004AAD),
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    imagemUrl != null
                                                        ? ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child:
                                                                Image.network(
                                                              imagemUrl,
                                                              width: itemWidth,
                                                              height: itemWidth,
                                                              fit: BoxFit.cover,
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return Container(
                                                                  width:
                                                                      itemWidth,
                                                                  height:
                                                                      itemWidth,
                                                                  color: Colors
                                                                          .grey[
                                                                      300],
                                                                  child:
                                                                      const Icon(
                                                                    Icons.error,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        : Container(
                                                            width: itemWidth,
                                                            height: itemWidth,
                                                            color: Colors
                                                                .grey[300],
                                                            child: const Icon(
                                                              Icons
                                                                  .image_not_supported,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        titulo,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Color(0xFF004AAD),
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0),
                                                      child: Text(
                                                        descricao,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black87,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
