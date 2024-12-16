import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class LocalizacaoUsuario extends StatefulWidget {
  final Function(String) onCityDetected;

  const LocalizacaoUsuario({Key? key, required this.onCityDetected})
      : super(key: key);

  @override
  _LocalizacaoUsuarioState createState() => _LocalizacaoUsuarioState();
}

class _LocalizacaoUsuarioState extends State<LocalizacaoUsuario> {
  String? userCity;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    // Solicita permissão para acessar a localização
    PermissionStatus permission = await Permission.location.request();

    if (permission.isGranted) {
      // Obtém a posição atual do usuário
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Chama a função para buscar a cidade usando a API OpenCage
      await fetchCityFromOpenCage(position.latitude, position.longitude);
    } else {
      // Caso a permissão não seja concedida, avisa o usuário
      setState(() {
        userCity = "Permissão de localização não concedida";
        isLoading = false;
      });
      widget.onCityDetected("Permissão de localização não concedida");
    }
  }

  Future<void> fetchCityFromOpenCage(double latitude, double longitude) async {
    const String apiKey =
        'adb471e58a924c9e91022922a3be7975'; // Substitua pela sua chave da OpenCage
    final String url =
        'https://api.opencagedata.com/geocode/v1/json?q=$latitude,+$longitude&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'];

        if (results != null && results.isNotEmpty) {
          String? city;

          // Percorre todos os componentes do endereço para encontrar a cidade
          for (var component in results[0]['components']) {
            if (component.containsKey('city')) {
              city = component['city'];
              break;
            }
          }

          if (city != null) {
            setState(() {
              userCity = city;
              isLoading = false;
            });
            widget.onCityDetected(city);
          } else {
            setState(() {
              userCity = "Cidade não encontrada";
              isLoading = false;
            });
            widget.onCityDetected("Cidade não encontrada");
          }
        } else {
          setState(() {
            userCity = "Localização não encontrada";
            isLoading = false;
          });
          widget.onCityDetected("Localização não encontrada");
        }
      } else {
        setState(() {
          userCity = "Erro ao consultar API";
          isLoading = false;
        });
        widget.onCityDetected("Erro ao consultar API");
        print('Erro na API do OpenCage: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        userCity = "Erro ao buscar local";
        isLoading = false;
      });
      widget.onCityDetected("Erro ao buscar local");
      print('Erro ao acessar a API do OpenCage: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading)
          const CircularProgressIndicator()
        else
          Text(
            'Cidade: $userCity',
            style: const TextStyle(fontSize: 16),
          ),
      ],
    );
  }
}
