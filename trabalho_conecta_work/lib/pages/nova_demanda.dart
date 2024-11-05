import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trabalho_conecta_work/components/my_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class NovaDemanda extends StatefulWidget {
  const NovaDemanda({super.key});

  @override
  _NovaDemandaState createState() => _NovaDemandaState();
}

class _NovaDemandaState extends State<NovaDemanda> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<XFile>? _imageFiles;
  final GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey:
          'AIzaSyAqEpiuZYAYvCKRVeXydjsRVo1KL6nBPRw'); // Substitua pela sua chave de API

  final String _titlePlaceholder = 'Selecione título da demanda';
  final String _valuePlaceholder = 'Valor';
  final String _locationPlaceholder = 'Localização';
  final String _descriptionPlaceholder = 'Descrição do serviço';

  Widget _buildEditableField(
      String placeholder, TextEditingController controller,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: controller.text.isEmpty ? placeholder : '',
            border: InputBorder.none,
            prefixText: isNumeric ? 'R\$ ' : null,
          ),
          keyboardType: isNumeric
              ? TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          onChanged: (value) {
            if (isNumeric) {
              value = value.replaceAll(RegExp(r'[^\d]'), '');
              if (value.isNotEmpty) {
                double parsedValue = double.parse(value) / 100;
                controller.text =
                    parsedValue.toStringAsFixed(2).replaceAll('.', ',');
                controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length));
              } else {
                controller.text = '';
              }
            }
          },
        ),
      ),
    );
  }

  Future<void> _selectImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? selectedImages = await picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _imageFiles = selectedImages;
      });
    }
  }

  Future<void> _handleLocationSearch() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey:
          'AIzaSyAqEpiuZYAYvCKRVeXydjsRVo1KL6nBPRw', // Substitua pela sua chave de API
      mode: Mode.overlay,
      language: "pt",
      components: [
        Component(Component.country, "br")
      ], // Restringe a pesquisa ao Brasil
    );

    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      final location = detail.result.geometry!.location;
      _locationController.text = p.description ?? '';

      // Aqui você pode usar a latitude e longitude no backend
      print("Latitude: ${location.lat}, Longitude: ${location.lng}");
    }
  }

  Future<void> criarDemanda() async {
    final demanda = ParseObject('Demanda')
      ..set('titulo', _titleController.text)
      ..set('descricao', _descriptionController.text)
      ..set('valor', double.parse(_valueController.text.replaceAll(',', '.')))
      ..set(
          'localizacao',
          ParseGeoPoint(
            latitude: double.parse(_locationController.text.split(',')[0]),
            longitude: double.parse(_locationController.text.split(',')[1]),
          ));

    List<String> imageUrls = [];

    if (_imageFiles != null && _imageFiles!.isNotEmpty) {
      for (var imageFile in _imageFiles!) {
        final parseFile = ParseFile(File(imageFile.path));
        final response = await parseFile.save();
        if (response.success) {
          imageUrls.add(response.result.url);
        } else {
          print('Erro ao salvar imagem: ${response.error!.message}');
        }
      }
      demanda.set('imagens', imageUrls.join(','));
    }

    final response = await demanda.save();

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Demanda criada com sucesso!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao criar demanda: ${response.error?.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
      appBar: const MyAppBar(showAddIcon: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.arrowLeft,
                        color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 4),
                ],
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'Adicionar nova demanda específica',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              _buildEditableField(_titlePlaceholder, _titleController),
              _buildEditableField(_valuePlaceholder, _valueController,
                  isNumeric: true),
              GestureDetector(
                onTap: _handleLocationSearch,
                child: AbsorbPointer(
                  child: _buildEditableField(
                      _locationPlaceholder, _locationController),
                ),
              ),
              _buildEditableField(
                  _descriptionPlaceholder, _descriptionController),
              GestureDetector(
                onTap: _selectImages,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Adicionar Imagens',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Toque para adicionar várias imagens',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const FaIcon(FontAwesomeIcons.camera),
                    ],
                  ),
                ),
              ),
              if (_imageFiles != null && _imageFiles!.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  children: _imageFiles!.map((image) {
                    return Image.file(
                      File(image.path),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: criarDemanda,
                    icon: const Icon(Icons.send, color: Colors.white),
                    label: const Text(
                      "Criar Demanda",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
