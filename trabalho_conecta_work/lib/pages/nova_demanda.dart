import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:trabalho_conecta_work/components/my_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:google_place/google_place.dart';

class NovaDemanda extends StatefulWidget {
  const NovaDemanda({super.key});

  @override
  _NovaDemandaState createState() => _NovaDemandaState();
}

class _NovaDemandaState extends State<NovaDemanda> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  List<XFile>? _imageFiles;
  List<ParseObject> _categorias = [];
  String? selectedValue;
  String? selectedCategoryId;
  String? selectedLocation;
  double? selectedLatitude;
  double? selectedLongitude;

  final String _titlePlaceholder = 'Título da demanda';
  final String _valuePlaceholder = 'Valor';
  final String _descriptionPlaceholder = 'Descrição do serviço';
  final String _locationPlaceholder = 'Digite o local';

  GooglePlace? _googlePlace;
  List<AutocompletePrediction> _placePredictions = [];

  // Fetch categories from the database
  Future<void> _fetchCategorias() async {
    final query = QueryBuilder<ParseObject>(ParseObject('Categoria'));
    final response = await query.query();

    if (response.success) {
      setState(() {
        _categorias = response.results!.cast<ParseObject>();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Erro ao buscar categorias: ${response.error?.message}')),
      );
    }
  }

  // Create a new demand
  Future<void> criarDemanda() async {
    if (_titleController.text.isEmpty ||
        _valueController.text.isEmpty ||
        selectedCategoryId == null ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        selectedLatitude == null ||
        selectedLongitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não autenticado')),
      );
      return;
    }

    final demanda = ParseObject('Demanda')
      ..set('titulo', _titleController.text)
      ..set('descricao', _descriptionController.text)
      ..set('status', 'novo')
      ..set('valor', double.parse(_valueController.text.replaceAll(',', '.')))
      ..set('localizacao', _locationController.text)
      ..set('usuario_pointer', currentUser)
      ..set('categoria_pointer',
          ParseObject('Categoria')..set('objectId', selectedCategoryId));

    // Use apenas 'coordenadas' como GeoPoint para armazenar a localização
    final geoPoint = ParseGeoPoint(
        latitude: selectedLatitude!, longitude: selectedLongitude!);
    demanda.set('coordenada', geoPoint);

    if (_imageFiles != null && _imageFiles!.isNotEmpty) {
      final List<ParseFile> parseFiles = [];
      for (var image in _imageFiles!) {
        ParseFile parseImage = ParseFile(File(image.path));
        ParseACL acl = ParseACL();
        acl.setPublicWriteAccess(allowed: true);
        acl.setPublicReadAccess(allowed: true);
        parseImage.setACL(acl);

        final saveResponse = await parseImage.save();
        if (saveResponse.success) {
          parseFiles.add(parseImage);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Erro ao salvar a imagem: ${saveResponse.error?.message}')),
          );
        }
      }
      demanda.set('imagem', parseFiles);
    }

    final response = await demanda.save();

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demanda criada com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${response.error?.message}')),
      );
    }
  }

  // Fetch place suggestions based on user input
  Future<void> _fetchPlaceSuggestions(String query) async {
    if (_googlePlace != null) {
      final response = await _googlePlace!.autocomplete.get(query);

      if (response != null && response.predictions != null) {
        setState(() {
          _placePredictions = response.predictions!;
        });
      } else {
        setState(() {
          _placePredictions = [];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _googlePlace = GooglePlace(
        'AIzaSyAqEpiuZYAYvCKRVeXydjsRVo1KL6nBPRw'); // Replace with your API key
    _fetchCategorias();
  }

  // Build editable field for input
  Widget _buildEditableField(
      String placeholder, TextEditingController controller,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        height: 80,
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
            hintText: placeholder,
            border: InputBorder.none,
            prefixText: isNumeric ? 'R\$ ' : null,
          ),
          keyboardType: isNumeric
              ? TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          onChanged: (value) {
            if (placeholder == _locationPlaceholder) {
              _fetchPlaceSuggestions(value);
            }
          },
        ),
      ),
    );
  }

  // Select images from the device
  Future<void> _selectImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? selectedImages = await picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _imageFiles = selectedImages;
      });
    }
  }

  // Show image preview
  Widget _buildImagePreview() {
    if (_imageFiles == null || _imageFiles!.isEmpty) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Wrap(
        spacing: 8.0,
        children: _imageFiles!.map((image) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(image.path),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          );
        }).toList(),
      ),
    );
  }

  // Show location suggestions based on user input
  Widget _buildLocationSuggestions() {
    if (_placePredictions.isEmpty) {
      return Container();
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _placePredictions.length,
      itemBuilder: (context, index) {
        final prediction = _placePredictions[index];
        return ListTile(
          title: Text(prediction.description ?? ''),
          onTap: () async {
            setState(() {
              selectedLocation = prediction.description;
              _locationController.text = prediction.description ?? '';
            });

            final placeDetails =
                await _googlePlace!.details.get(prediction.placeId!);

            if (placeDetails != null && placeDetails.result != null) {
              setState(() {
                selectedLatitude = placeDetails.result!.geometry!.location!.lat;
                selectedLongitude =
                    placeDetails.result!.geometry!.location!.lng;
              });
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
      appBar: const MyAppBar(showAddIcon: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.chevronLeft),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildEditableField(_titlePlaceholder, _titleController),
            _buildEditableField(_valuePlaceholder, _valueController,
                isNumeric: true),
            const SizedBox(height: 12),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton2<String>(
                value: selectedCategoryId,
                hint: const Text('Selecione uma categoria'),
                items: _categorias.map((ParseObject categoria) {
                  return DropdownMenuItem<String>(
                    value: categoria.objectId,
                    child: Text(categoria.get<String>('nome') ?? 'Categoria'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategoryId = value;
                  });
                },
                buttonStyleData: ButtonStyleData(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200, // Altura do dropdown
                  width: MediaQuery.of(context).size.width *
                      0.8, // Largura do dropdown
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  offset: const Offset(
                      0, 8), // Deslocamento para garantir que desça
                ),
                menuItemStyleData: MenuItemStyleData(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 8.0),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildEditableField(
                _descriptionPlaceholder, _descriptionController),
            const SizedBox(height: 12),
            _buildEditableField(_locationPlaceholder, _locationController),
            _buildLocationSuggestions(),
            _buildImagePreview(),
            ElevatedButton(
              onPressed: _selectImages,
              child: const Text('Selecionar Imagens'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: criarDemanda,
              child: const Text('Criar Demanda'),
            ),
          ],
        ),
      ),
    );
  }
}
