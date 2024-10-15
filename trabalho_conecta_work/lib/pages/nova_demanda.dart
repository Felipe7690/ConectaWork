import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trabalho_conecta_work/components/my_app_bar.dart';
import 'package:image_picker/image_picker.dart';

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

  final String _titlePlaceholder = 'Selecione título da demanda';
  final String _valuePlaceholder = 'Valor';
  final String _locationPlaceholder = 'Localização';
  final String _descriptionPlaceholder = 'Descrição do serviço';
  final String _imagePlaceholder = 'Adicionar Imagens';

<<<<<<< HEAD
  Widget _buildEditableField(
      String placeholder, TextEditingController controller,
      {bool isNumeric = false}) {
=======
  Widget _buildEditableField(String placeholder, TextEditingController controller, {bool isNumeric = false}) {
>>>>>>> 6b20ffa5d0c7f2b93cff3ff610afda26c2092ea2
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
<<<<<<< HEAD
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
=======
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
>>>>>>> 6b20ffa5d0c7f2b93cff3ff610afda26c2092ea2
        ),
        child: Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus && controller.text.isEmpty) {
<<<<<<< HEAD
              controller.text =
                  ''; // Retorna ao texto original se não houver alteração
            } else if (!hasFocus && controller.text.isNotEmpty) {
              controller.text =
                  controller.text; // Mantém o texto se foi alterado
=======
              controller.text = '';
            } else if (!hasFocus && controller.text.isNotEmpty) {
              controller.text = controller.text;
>>>>>>> 6b20ffa5d0c7f2b93cff3ff610afda26c2092ea2
            }
          },
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
<<<<<<< HEAD
              labelText: controller.text.isEmpty
                  ? placeholder
                  : '', // Esconde o texto original ao editar
              border: InputBorder.none, // Remove a borda padrão
=======
              labelText: controller.text.isEmpty ? placeholder : '',
              border: InputBorder.none,
>>>>>>> 6b20ffa5d0c7f2b93cff3ff610afda26c2092ea2
              prefixText: isNumeric ? 'R\$ ' : null,
            ),
            keyboardType: isNumeric
                ? TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            onTap: () {
              if (controller.text == placeholder) {
                controller.clear();
              }
            },
            onChanged: (value) {
              if (isNumeric) {
<<<<<<< HEAD
                // Formata o valor para real
                value = value.replaceAll(
                    RegExp(r'[^\d]'), ''); // Remove tudo que não for dígito
                if (value.isNotEmpty) {
                  double parsedValue =
                      double.parse(value) / 100; // Converte para real
                  controller.text = parsedValue
                      .toStringAsFixed(2)
                      .replaceAll('.', ','); // Formata como moeda
                  controller.selection = TextSelection.fromPosition(
                      TextPosition(
                          offset: controller
                              .text.length)); // Move o cursor para o final
=======
                value = value.replaceAll(RegExp(r'[^\d]'), '');
                if (value.isNotEmpty) {
                  double parsedValue = double.parse(value) / 100;
                  controller.text = parsedValue.toStringAsFixed(2).replaceAll('.', ',');
                  controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
>>>>>>> 6b20ffa5d0c7f2b93cff3ff610afda26c2092ea2
                } else {
                  controller.text = '';
                }
              } else if (value.isEmpty) {
<<<<<<< HEAD
                controller.text =
                    placeholder; // Se o campo estiver vazio, redefine para o placeholder
=======
                controller.text = placeholder;
>>>>>>> 6b20ffa5d0c7f2b93cff3ff610afda26c2092ea2
              }
            },
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
=======
>>>>>>> 6b20ffa5d0c7f2b93cff3ff610afda26c2092ea2
      appBar: const MyAppBar(showAddIcon: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
<<<<<<< HEAD
                  icon: const FaIcon(FontAwesomeIcons.chevronLeft,
                      color: Colors.black), // Ícone de voltar
=======
                  icon: const FaIcon(FontAwesomeIcons.chevronLeft, color: Colors.black),
>>>>>>> 6b20ffa5d0c7f2b93cff3ff610afda26c2092ea2
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
<<<<<<< HEAD

            _buildEditableField(_titlePlaceholder, _titleController),
            _buildEditableField(_valuePlaceholder, _valueController,
                isNumeric: true),
            _buildEditableField(_locationPlaceholder, _locationController),
            _buildEditableField(
                _descriptionPlaceholder, _descriptionController),

            Padding(
              padding: const EdgeInsets.only(
                  bottom:
                      20.0), // Aumenta ainda mais o espaçamento abaixo do campo de imagens
=======
            _buildEditableField(_titlePlaceholder, _titleController),
            _buildEditableField(_valuePlaceholder, _valueController, isNumeric: true),
            _buildEditableField(_locationPlaceholder, _locationController),
            _buildEditableField(_descriptionPlaceholder, _descriptionController),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
>>>>>>> 6b20ffa5d0c7f2b93cff3ff610afda26c2092ea2
              child: GestureDetector(
                onTap: _selectImages,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
<<<<<<< HEAD
                  padding: const EdgeInsets.all(
                      12.0), // Aumenta o padding para um botão mais evidente
                  decoration: BoxDecoration(
                    color: Colors.white, // Cor de fundo leve
                    borderRadius:
                        BorderRadius.circular(8.0), // Bordas arredondadas
=======
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
>>>>>>> 6b20ffa5d0c7f2b93cff3ff610afda26c2092ea2
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
<<<<<<< HEAD
                            'Toque para adicionar imagens',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey), // Texto de instrução
=======
                            'Toque para adicionar várias imagens',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
>>>>>>> 6b20ffa5d0c7f2b93cff3ff610afda26c2092ea2
                          ),
                        ],
                      ),
                      const FaIcon(FontAwesomeIcons.camera),
                    ],
                  ),
                ),
              ),
            ),
            if (_imageFiles != null && _imageFiles!.isNotEmpty)
              Wrap(
                spacing: 8.0,
                children: _imageFiles!.map((image) {
                  return Image.file(
<<<<<<< HEAD
                    File(
                        image.path), // A classe File deve ser reconhecida agora
=======
                    File(image.path),
>>>>>>> 6b20ffa5d0c7f2b93cff3ff610afda26c2092ea2
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
