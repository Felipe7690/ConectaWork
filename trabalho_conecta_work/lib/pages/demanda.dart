import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trabalho_conecta_work/pages/desc_demanda.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

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

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371000;
    final double phi1 = lat1 * (3.141592653589793 / 180);
    final double phi2 = lat2 * (3.141592653589793 / 180);
    final double deltaPhi = (lat2 - lat1) * (3.141592653589793 / 180);
    final double deltaLambda = (lon2 - lon1) * (3.141592653589793 / 180);

    final double a = (sin(deltaPhi / 2) * sin(deltaPhi / 2)) +
        cos(phi1) * cos(phi2) * (sin(deltaLambda / 2) * sin(deltaLambda / 2));
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  @override
  void initState() {
    super.initState();

    _getUserLocation().then((userPosition) {
      // Após obter a posição do usuário, carrega as demandas próximas
      _getNearbyDemandas(userPosition);
    }).catchError((e) {
      print("Erro ao obter localização: $e");
    });

    _fetchDemandas();
    _checkGPSStatus();
  }

  Future<void> fetchCityFromGoogle(double latitude, double longitude) async {
    const String apiKey = 'AIzaSyDQeC9ygvE5EYS-ac4brnHiwmMAvpuLy7s';
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=10000&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'].isNotEmpty) {
          final placeName = data['results'][0]['name'];
          print('Cidade detectada: $placeName');
          setState(() {
            userCity = placeName;
          });
        } else {
          print('Nenhum resultado encontrado na API.');
        }
      } else {
        print('Erro na API do Google: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao fazer requisição para o Google Places API: $e');
    }
  }

  Future<Position> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Localização desabilitada');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissão de localização negada');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permissão de localização permanentemente negada');
    }

    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      return Future.error('Erro ao obter a localização: $e');
    }
  }

  Future<void> _getNearbyDemandas(Position userPosition) async {
    try {
      final queryCategoria = QueryBuilder<ParseObject>(ParseObject('Categoria'))
        ..whereEqualTo('nome', widget.categoria);
      final responseCategoria = await queryCategoria.query();

      if (responseCategoria.success && responseCategoria.results != null) {
        final categoria = responseCategoria.results!.first as ParseObject;
        final categoriaId = categoria.objectId!;

        final userGeoPoint = ParseGeoPoint(
          latitude: userPosition.latitude,
          longitude: userPosition.longitude,
        );

        final queryDemandas = QueryBuilder<ParseObject>(ParseObject('Demanda'))
          ..whereWithinKilometers('coordenada', userGeoPoint, 10)
          ..whereEqualTo('categoria_pointer',
              ParseObject('Categoria')..objectId = categoriaId)
          ..includeObject(['usuario_pointer'])
          ..orderByDescending('createdAt');

        final responseDemandas = await queryDemandas.query();

        if (responseDemandas.success && responseDemandas.results != null) {
          setState(() {
            demandas = responseDemandas.results as List<ParseObject>;
            isLoading = false;

            for (var demanda in demandas) {
              final criador = demanda.get<ParseObject>('usuario_pointer');
              if (criador != null) {
                final criadorNome =
                    criador.get<String>('username') ?? 'Criador desconhecido';
                final fotoFile = criador.get<ParseFile>('profileImage');
                final criadorFoto = fotoFile?.url ?? '';

                demanda.set<String>('criador_nome', criadorNome);
                demanda.set<String>('criador_foto', criadorFoto);
              }
            }
          });
        } else {
          setState(() {
            demandas = [];
            isLoading = false;
          });
          print('Nenhuma demanda encontrada na categoria selecionada.');
        }
      } else {
        setState(() {
          demandas = [];
          isLoading = false;
        });
        print('Categoria não encontrada.');
      }
    } catch (e) {
      setState(() {
        demandas = [];
        isLoading = false;
      });
      print('Erro ao buscar demandas próximas: $e');
    }
  }

  void _setDefaultLocationValues(String errorMessage) {
    if (mounted) {
      setState(() {
        userCity = errorMessage;
        userState = "Estado não disponível";
        userCountry = "País não disponível";
      });
    }
  }

  Future<void> _fetchDemandas() async {
    if (userPosition == null) {
      print('Posição do usuário não disponível.');
      return;
    }

    try {
      final userGeoPoint = ParseGeoPoint(
        latitude: userPosition!.latitude,
        longitude: userPosition!.longitude,
      );

      final queryCategoria = QueryBuilder<ParseObject>(ParseObject('Categoria'))
        ..whereEqualTo('nome', widget.categoria);

      final responseCategoria = await queryCategoria.query();

      if (responseCategoria.success && responseCategoria.results != null) {
        final categoria = responseCategoria.results!.first as ParseObject;
        final categoriaId = categoria.objectId!;

        final queryDemanda = QueryBuilder<ParseObject>(ParseObject('Demanda'))
          ..whereEqualTo('categoria_pointer',
              ParseObject('Categoria')..objectId = categoriaId)
          ..whereWithinKilometers(
              'coordenada', userGeoPoint, 10) // Filtrar por proximidade (10 km)
          ..includeObject(['usuario_pointer']) // Inclui os dados do criador
          ..orderByDescending('createdAt');

        final responseDemanda = await queryDemanda.query();

        if (responseDemanda.success && responseDemanda.results != null) {
          if (mounted) {
            setState(() {
              demandas = responseDemanda.results as List<ParseObject>;
              isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              demandas = [];
              isLoading = false;
            });
          }
          print(
              'Nenhuma demanda encontrada para a categoria e localização especificadas.');
        }
      } else {
        print('Categoria não encontrada.');
      }
    } catch (e) {
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
                                    userCity != null
                                        ? 'Sua localização: $userCity'
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
                                                height: 300,
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
                                                              4.0),
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
                                                          horizontal: 4.0),
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
