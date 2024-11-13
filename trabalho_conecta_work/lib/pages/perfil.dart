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
  ParseFileBase? _profileImage;
  String? _userName;

  @override
  void initState() {
    super.initState();
    checkUserCompletion();
    _loadProfileData();
  }

  Future<void> checkUserCompletion() async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser != null) {
      final isComplete = currentUser.get('registerCompleted') ?? false;

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
                    child: const Text('Depois'),
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

  // Carrega os dados do perfil, incluindo a imagem e o nome do usuário
  Future<void> _loadProfileData() async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser != null) {
      setState(() {
        _profileImage = currentUser.get<ParseFileBase>('profileImage');
        _userName = currentUser.get<String>('username') ?? 'Usuário';
      });
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
              // Imagem de perfil
              Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromRGBO(0, 74, 173, 1),
                    width: 3.0,
                  ),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? NetworkImage(_profileImage!.url!)
                      : null,
                  child: _profileImage == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              // Nome do usuário
              Text(
                'Olá, ${_userName != null ? _userName!.split(' ').take(1).join('') : 'Usuário'}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    MaterialPageRoute(
                      builder: (context) => ProposalScreen(),
                    ),
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
                onTap: () async {
                  // Navega para a tela de editar perfil e recarrega os dados ao retornar
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfileSheet()),
                  );
                  _loadProfileData(); // Atualiza os dados ao retornar
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
