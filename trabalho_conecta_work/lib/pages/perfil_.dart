import 'package:flutter/material.dart';
import 'package:trabalho_conecta_work/pages/editar perfil.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

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
                offset: Offset(4, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container CircleAvatar
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
                  Icons.dashboard,
                  color: Color.fromRGBO(0, 74, 173, 1),
                ),
                title: const Text('Dashboard'),
                onTap: () {
                  // Ação do botão de Dashboard
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.account_balance_wallet,
                  color: Color.fromRGBO(0, 74, 173, 1),
                ),
                title: const Text('Minha carteira'),
                onTap: () {
                  // Ação do botão de Carteira
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.mail,
                  color: Color.fromRGBO(0, 74, 173, 1),
                ),
                title: const Text('Propostas'),
                onTap: () {
                  // Ação do botão de Propostas
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Color.fromRGBO(0, 74, 173, 1),
                ),
                title: const Text('Editar perfil'),
                onTap: () {
                  // Exibe o BottomSheet com o formulário de edição
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (context) {
                      return const EditProfileSheet(); // Chama a página de edição do perfil
                    },
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
