import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:trabalho_conecta_work/components/my_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class NovaDemanda extends StatefulWidget {
  const NovaDemanda({super.key});

  @override
  _NovaDemandaState createState() => _NovaDemandaState();
}

class _NovaDemandaState extends State<NovaDemanda> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<XFile>? _imageFiles;

  final String _titlePlaceholder = 'Selecione título da demanda';
  final String _valuePlaceholder = 'Valor';
  final String _descriptionPlaceholder = 'Descrição do serviço';

  final List<String> items = [
    'Rubiataba',
    'Ceres',
  ];

  String? selectedValue;

  // Função para criar e salvar a demanda no banco de dados
  Future<void> criarDemanda() async {
    if (_titleController.text.isEmpty ||
        _valueController.text.isEmpty ||
        selectedValue == null ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    // Verificar se o usuário está autenticado
    ParseUser? currentUser = await ParseUser.currentUser();
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não autenticado')),
      );
      return;
    }

    // Criação de objeto Parse
    final demanda = ParseObject('Demanda')
      ..set('titulo', _titleController.text)
      ..set('descricao', _descriptionController.text)
      ..set('status', 'novo')
      ..set('localizacao', selectedValue)
      ..set('valor', double.parse(_valueController.text.replaceAll(',', '.')));

    // Salvando imagens e pegando os links
    if (_imageFiles != null && _imageFiles!.isNotEmpty) {
      final List<ParseFile> parseFiles = []; // Para armazenar os arquivos Parse
      for (var image in _imageFiles!) {
        // Criando ParseFile a partir da imagem
        ParseFile parseImage = ParseFile(File(image.path));

        // Definindo a ACL para permitir leitura e escrita
        ParseACL acl = ParseACL();
        acl.setPublicWriteAccess(allowed: true);
        acl.setPublicReadAccess(allowed: true);
        parseImage.setACL(acl);

        // Salvando o ParseFile no servidor (fazendo o upload)
        final saveResponse = await parseImage.save();

        // Verificando se o arquivo foi salvo com sucesso
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

      // Associando os arquivos de imagem ao objeto demanda
      demanda.set('imagem', parseFiles);
    }

    // Salvando a demanda no banco de dados
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
            if (isNumeric) {
              controller.value = TextEditingValue(
                text: value.replaceAll(RegExp(r'[^\d]'), ''),
                selection: TextSelection.collapsed(offset: value.length),
              );
            }
          },
          onEditingComplete: () {
            if (isNumeric) {
              String text = controller.text;
              if (text.isNotEmpty) {
                double parsedValue = double.parse(text) / 100;
                String formattedValue =
                    parsedValue.toStringAsFixed(2).replaceAll('.', ',');
                controller.value = TextEditingValue(
                  text: formattedValue,
                  selection:
                      TextSelection.collapsed(offset: formattedValue.length),
                );
              }
            }
          },
        ),
      ),
    );
  }

  // Função para selecionar imagens
  Future<void> _selectImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? selectedImages = await picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _imageFiles = selectedImages;
      });
    }
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
                  icon: const FaIcon(FontAwesomeIcons.chevronLeft,
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
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            _buildEditableField(_titlePlaceholder, _titleController),
            _buildEditableField(_valuePlaceholder, _valueController,
                isNumeric: true),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: const Row(
                      children: [
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Cidade',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: items
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black26),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(Icons.arrow_forward_ios_outlined),
                      iconSize: 16,
                      iconEnabledColor: Color.fromRGBO(0, 0, 0, 1),
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _buildEditableField(
                _descriptionPlaceholder, _descriptionController),
            GestureDetector(
              onTap: _selectImages,
              child: Container(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.camera_alt_outlined, color: Colors.black54),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Clique aqui para adicionar imagem',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
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
