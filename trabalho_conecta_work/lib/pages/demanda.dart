import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      userPosition = position;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        if (mounted) {
          // Verifica se o widget ainda está montado
          setState(() {
            userCity = place.locality ?? "Cidade não disponível";
            userState = place.administrativeArea ?? "Estado não disponível";
            userCountry = place.country ?? "País não disponível";
          });
        }

        print(
            "Cidade: $userCity, Estado: $userState, País: $userCountry, Coordenadas: ${position.latitude}, ${position.longitude}");
      } else {
        _setDefaultLocationValues("Localização não encontrada");
      }
    } catch (e) {
      _setDefaultLocationValues("Erro ao obter localização");
      print("Erro: $e");
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(color: Colors.white),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 10, left: 5),
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
                child: GestureDetector(
                  onTap: () {
                    // Navega para a página de Demanda e passa a categoria selecionada
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DescDemanda(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: itemWidth,
                          child: Column(
                            children: [
                              Container(
                                height: 280,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 15,
                                            backgroundImage: NetworkImage(
                                                'https://avatars.githubusercontent.com/u/116851523?v=4'),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              "Douglas Cássio",
                                              style: TextStyle(
                                                color: Color(0xFF004AAD),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Image.asset(
                                        "assets/imagens/eletrico.jpg",
                                        fit: BoxFit.cover,
                                        height: 150,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons.error);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: const Text(
                                        "Contratamos eletricista com experiência para serviços de manutenção e instalação elétrica.",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
