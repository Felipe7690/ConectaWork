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

  Widget _buildEditableField(String placeholder, TextEditingController controller, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(8.0),
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
        ),
        child: Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus && controller.text.isEmpty) {
              controller.text = '';
            } else if (!hasFocus && controller.text.isNotEmpty) {
              controller.text = controller.text;
            }
          },
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: controller.text.isEmpty ? placeholder : '',
              border: InputBorder.none,
              prefixText: isNumeric ? 'R\$ ' : null,
            ),
            keyboardType: isNumeric ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
            onTap: () {
              if (controller.text == placeholder) {
                controller.clear();
              }
            },
            onChanged: (value) {
              if (isNumeric) {
                value = value.replaceAll(RegExp(r'[^\d]'), '');
                if (value.isNotEmpty) {
                  double parsedValue = double.parse(value) / 100;
                  controller.text = parsedValue.toStringAsFixed(2).replaceAll('.', ',');
                  controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
                } else {
                  controller.text = '';
                }
              } else if (value.isEmpty) {
                controller.text = placeholder;
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
                  icon: const FaIcon(FontAwesomeIcons.chevronLeft, color: Colors.black),
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
            _buildEditableField(_valuePlaceholder, _valueController, isNumeric: true),
            _buildEditableField(_locationPlaceholder, _locationController),
            _buildEditableField(_descriptionPlaceholder, _descriptionController),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                onTap: _selectImages,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
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
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Adicionar Imagens',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }
}
