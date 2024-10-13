import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,

          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 5,
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
                  backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/116851523?v=4'),
                ),
              ),

              const SizedBox(height: 10),
              const Text(
                'Olá, Douglas Cássio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.dashboard, color: Color.fromRGBO(0, 74, 173, 1),),
                title: const Text('Dashboard'),
                onTap: () {

                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet, color: Color.fromRGBO(0, 74, 173, 1),), 
                title: const Text('Minha carteira'),
                onTap: () {

                },
              ),
              ListTile(
                leading: const Icon(Icons.mail, color: Color.fromRGBO(0, 74, 173, 1),),
                title: const Text('Propostas'),
                onTap: () {

                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Color.fromRGBO(0, 74, 173, 1),),
                title: const Text('Editar perfil'),
                onTap: () {

                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Profile(),
  ));
}
