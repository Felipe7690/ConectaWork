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

  bool _isLoading = false;

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
            borderRadius: BorderRadius.circular(8),
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

  Future<File> _saveTempFile(List<int> bytes) async {
    final tempDir = await Directory.systemTemp.createTemp();
    final tempFile = File('${tempDir.path}/image.png');
    return tempFile.writeAsBytes(bytes);
  }

  String normalizeFileName(String fileName) {
    String normalizedName = '';

    // Itera sobre cada caractere do nome do arquivo
    fileName.split('').forEach((char) {
      // Verifica se o caractere é válido
      if (RegExp(r'[a-zA-Z._-]').hasMatch(char)) {
        normalizedName += char; // Adiciona o caractere válido à string
      }
    });

    return normalizedName;
  }

  Future<void> criarDemanda() async {
    setState(() {
      _isLoading = true;
    });

    if (_titleController.text.isEmpty ||
        _valueController.text.isEmpty ||
        selectedCategoryId == null ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        selectedLatitude == null ||
        selectedLongitude == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      setState(() {
        _isLoading = false;
      });
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

    final geoPoint = ParseGeoPoint(
        latitude: selectedLatitude!, longitude: selectedLongitude!);
    demanda.set('coordenada', geoPoint);

    if (_imageFiles != null && _imageFiles!.isNotEmpty) {
      final List<ParseFile> parseFiles = [];
      for (var image in _imageFiles!) {
        String originalFileName = image.path.split('/').last;
        String normalizedFileName = normalizeFileName(
            originalFileName); // Normalizando o nome do arquivo

        ParseFile parseImage =
            ParseFile(File(image.path), name: normalizedFileName);
        ParseACL acl = ParseACL();
        acl.setPublicWriteAccess(allowed: true);
        acl.setPublicReadAccess(allowed: true);
        parseImage.setACL(acl);

        final saveResponse = await parseImage.save();
        if (saveResponse.success) {
          parseFiles.add(parseImage);
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Erro ao salvar a imagem "${normalizedFileName}": ${saveResponse.error?.message}')),
          );
          return;
        }
      }
      demanda.set('imagem', parseFiles);
    }

    final response = await demanda.save();
    setState(() {
      _isLoading = false;
    });

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demanda criada com sucesso!')),
      );

      _titleController.clear();
      _valueController.clear();
      _descriptionController.clear();
      _locationController.clear();
      setState(() {
        selectedCategoryId = null;
        selectedLocation = null;
        selectedLatitude = null;
        selectedLongitude = null;
        _imageFiles = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${response.error?.message}')),
      );
    }
  }

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
    _googlePlace = GooglePlace('AIzaSyAqEpiuZYAYvCKRVeXydjsRVo1KL6nBPRw');
    _fetchCategorias();
  }

  // Dentro do seu widget _buildEditableField
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
          minLines: placeholder == _descriptionPlaceholder ? 3 : 1,
          maxLines: placeholder == _descriptionPlaceholder ? null : 1,
          decoration: InputDecoration(
            hintText: placeholder,
            border: InputBorder.none,
            prefixText: isNumeric ? 'R\$ ' : null,
          ),
          keyboardType: isNumeric
              ? TextInputType.numberWithOptions(decimal: true)
              : TextInputType.multiline,
          onChanged: (value) {
            if (placeholder == _locationPlaceholder) {
              _fetchPlaceSuggestions(value);
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
              _placePredictions.clear();
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
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "Dados da demanda",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildEditableField(_titlePlaceholder, _titleController),
            _buildEditableField(_valuePlaceholder, _valueController,
                isNumeric: true),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Container(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.8,
                child: DropdownButton2<String>(
                  value: selectedCategoryId,
                  hint: Padding(
                    padding: EdgeInsets.only(left: 14),
                    child: Text(
                      'Selecione uma categoria',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  items: _categorias.map((ParseObject categoria) {
                    return DropdownMenuItem<String>(
                      value: categoria.objectId,
                      child: Text(
                        categoria.get<String>('nome') ?? 'Categoria',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategoryId = value;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 80,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.grey.withOpacity(0.5)),
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    offset: const Offset(0, -4),
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 8.0),
                  ),
                  underline: SizedBox.shrink(),
                ),
              ),
            ),
            _buildEditableField(
                _descriptionPlaceholder, _descriptionController),
            _buildEditableField(_locationPlaceholder, _locationController),
            _buildLocationSuggestions(),
            GestureDetector(
              onTap: _selectImages,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(12.0),
                margin: EdgeInsets.only(bottom: 10),
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
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Toque para adicionar várias imagens',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const FaIcon(FontAwesomeIcons.camera),
                  ],
                ),
              ),
            ),
            _buildImagePreview(),
            if (_imageFiles != null && _imageFiles!.isNotEmpty)
              Wrap(
                spacing: 8.0,
              ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : criarDemanda, // Desabilita o botão durante o carregamento
                  label: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Criar Demanda",
                          style: TextStyle(color: Colors.white),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
