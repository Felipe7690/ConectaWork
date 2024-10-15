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
  // Controladores para os campos de texto
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<XFile>? _imageFiles; // Armazena as imagens selecionadas

  // Títulos originais para cada campo
  final String _titlePlaceholder = 'Selecione título da demanda';
  final String _valuePlaceholder = 'Valor';
  final String _locationPlaceholder = 'Localização';
  final String _descriptionPlaceholder = 'Descrição do serviço';
  final String _imagePlaceholder = 'Adicionar Imagens';

  Widget _buildEditableField(
      String placeholder, TextEditingController controller,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
        ),
        child: Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus && controller.text.isEmpty) {
              controller.text =
                  ''; // Retorna ao texto original se não houver alteração
            } else if (!hasFocus && controller.text.isNotEmpty) {
              controller.text =
                  controller.text; // Mantém o texto se foi alterado
            }
          },
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: controller.text.isEmpty
                  ? placeholder
                  : '', // Esconde o texto original ao editar
              border: InputBorder.none, // Remove a borda padrão
              prefixText: isNumeric ? 'R\$ ' : null,
            ),
            keyboardType: isNumeric
                ? TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            onTap: () {
              // Limpa o campo ao tocar
              if (controller.text == placeholder) {
                controller.clear(); // Limpa o texto placeholder
              }
            },
            onChanged: (value) {
              // Atualiza a visibilidade do placeholder
              if (isNumeric) {
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
                } else {
                  controller.text = ''; // Limpa se vazio
                }
              } else if (value.isEmpty) {
                controller.text =
                    placeholder; // Se o campo estiver vazio, redefine para o placeholder
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
      backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
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
                  icon: const FaIcon(FontAwesomeIcons.chevronLeft,
                      color: Colors.black), // Ícone de voltar
                  onPressed: () {
                    Navigator.pop(context); // Volta para a página anterior
                  },
                ),
                const SizedBox(width: 4),
              ],
            ),
            const SizedBox(height: 4),
            const Center(
              child: Text(
                'Adicione a demanda específica',
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
            _buildEditableField(_locationPlaceholder, _locationController),
            _buildEditableField(
                _descriptionPlaceholder, _descriptionController),

            Padding(
              padding: const EdgeInsets.only(
                  bottom:
                      20.0), // Aumenta ainda mais o espaçamento abaixo do campo de imagens
              child: GestureDetector(
                onTap: _selectImages,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(
                      12.0), // Aumenta o padding para um botão mais evidente
                  decoration: BoxDecoration(
                    color: Colors.white, // Cor de fundo leve
                    borderRadius:
                        BorderRadius.circular(8.0), // Bordas arredondadas
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
                            'Toque para adicionar imagens',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey), // Texto de instrução
                          ),
                        ],
                      ),
                      const FaIcon(FontAwesomeIcons.camera), // Ícone da câmera
                    ],
                  ),
                ),
              ),
            ),
            // Exibe as imagens selecionadas
            if (_imageFiles != null && _imageFiles!.isNotEmpty)
              Wrap(
                spacing: 8.0,
                children: _imageFiles!.map((image) {
                  return Image.file(
                    File(
                        image.path), // A classe File deve ser reconhecida agora
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
