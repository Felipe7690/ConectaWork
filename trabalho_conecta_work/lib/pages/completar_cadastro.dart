import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:trabalho_conecta_work/pages/home.dart';

class CompleteProfileScreen extends StatelessWidget {
  final ParseUser user;

  CompleteProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final TextEditingController cpfController = TextEditingController();
    final TextEditingController birthdateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Completar Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cpfController,
              decoration: InputDecoration(labelText: 'CPF'),
            ),
            TextField(
              controller: birthdateController,
              decoration: InputDecoration(labelText: 'Data de Nascimento'),
            ),
            ElevatedButton(
              onPressed: () async {
                user.set('cpf', cpfController.text);
                user.set('birthdate', birthdateController.text);
                user.set('completar_cadastro', true);
                await user.save();
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text('Salvar e Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
