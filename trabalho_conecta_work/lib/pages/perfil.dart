import 'package:flutter/material.dart';
import 'package:trabalho_conecta_work/pages/editar_perfil.dart';
import 'package:trabalho_conecta_work/pages/proposta.dart';
import 'package:trabalho_conecta_work/pages/curriculo.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    checkUserCompletion();
  }

  Future<void> checkUserCompletion() async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser != null) {
      final isComplete = currentUser.get('completar_cadastro') ?? false;

      if (!isComplete) {
        // Exibe o popup de completar cadastro
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Cadastro Incompleto'),
                content: const Text(
                    'Para acessar todas as funcionalidades, complete seu cadastro.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/completar_cadastro');
                    },
                    child: const Text('Completar Cadastro'),
                  ),
                ],
              );
            },
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(4, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromRGBO(0, 74, 173, 1),
                    width: 3.0,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/116851523?v=4'),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Olá, Douglas Cássio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(
                  Icons.mail,
                  color: Color.fromRGBO(0, 74, 173, 1),
                ),
                title: const Text('Propostas'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Proposta()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.description,
                  color: Color.fromRGBO(0, 74, 173, 1),
                ),
                title: const Text('Currículo'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Curriculum(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Color.fromRGBO(0, 74, 173, 1),
                ),
                title: const Text('Editar perfil'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfileSheet()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
