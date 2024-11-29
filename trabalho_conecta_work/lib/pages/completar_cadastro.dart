import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../components/my_app_bar.dart'; 

class CompleteProfileScreen extends StatelessWidget {
  final ParseUser user;

  CompleteProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final TextEditingController cpfController = TextEditingController();
    final TextEditingController birthdateController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController streetController = TextEditingController();
    final TextEditingController numberController = TextEditingController();
    final TextEditingController neighborhoodController = TextEditingController();
    final TextEditingController complementController = TextEditingController();
    final TextEditingController cityController = TextEditingController();

    return Scaffold(
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Breve Descrição'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Número de Telefone'),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TelefoneInputFormatter(),
              ],
            ),
            TextField(
              controller: cpfController,
              decoration: const InputDecoration(labelText: 'CPF'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CpfInputFormatter(),
              ],
            ),
            TextField(
              controller: birthdateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Data de Nascimento',
                hintText: 'dd/MM/yyyy',
              ),
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  birthdateController.text =
                      DateFormat('dd/MM/yyyy').format(pickedDate);
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Endereço',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: streetController,
              decoration: const InputDecoration(labelText: 'Rua'),
            ),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(labelText: 'Número'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            TextField(
              controller: neighborhoodController,
              decoration: const InputDecoration(labelText: 'Bairro'),
            ),
            TextField(
              controller: complementController,
              decoration: const InputDecoration(labelText: 'Complemento'),
            ),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: 'Cidade'),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    if (birthdateController.text.isEmpty ||
                        cpfController.text.isEmpty ||
                        phoneController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        streetController.text.isEmpty ||
                        numberController.text.isEmpty ||
                        neighborhoodController.text.isEmpty ||
                        cityController.text.isEmpty) {
                      _showErrorDialog(context, 'Por favor, preencha todos os campos.');
                      return;
                    }

                    final DateTime birthdate =
                        DateFormat('dd/MM/yyyy').parse(birthdateController.text);

                    user.set('description', descriptionController.text);
                    user.set('phone', phoneController.text);
                    user.set('cpf', cpfController.text);
                    user.set('birthdate', birthdate);
                    user.set('address', {
                      'street': streetController.text,
                      'number': numberController.text,
                      'neighborhood': neighborhoodController.text,
                      'complement': complementController.text,
                      'city': cityController.text,
                    });
                    user.set('registerCompleted', true);

                    final ParseResponse response = await user.save();
                    if (response.success) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      _showErrorDialog(context, response.error?.message ?? 'Erro desconhecido');
                    }
                  } catch (e) {
                    _showErrorDialog(context, 'Formato de data inválido. Use dd/MM/yyyy.');
                  }
                },
                child: const Text('Salvar e Continuar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (text.length > 11) text = text.substring(0, 11);

    if (text.length <= 2) {
      text = '($text';
    } else if (text.length <= 7) {
      text = '(${text.substring(0, 2)}) ${text.substring(2)}';
    } else {
      text = '(${text.substring(0, 2)}) ${text.substring(2, 7)}-${text.substring(7)}';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (text.length > 11) text = text.substring(0, 11);

    if (text.length <= 3) {
      text = text;
    } else if (text.length <= 6) {
      text = '${text.substring(0, 3)}.${text.substring(3)}';
    } else if (text.length <= 9) {
      text = '${text.substring(0, 3)}.${text.substring(3, 6)}.${text.substring(6)}';
    } else {
      text = '${text.substring(0, 3)}.${text.substring(3, 6)}.${text.substring(6, 9)}-${text.substring(9)}';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
