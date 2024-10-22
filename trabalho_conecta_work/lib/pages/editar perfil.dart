import 'package:flutter/material.dart';
import '../components/my_app_bar.dart';

class EditProfileSheet extends StatelessWidget {
  const EditProfileSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        // Adiciona rolagem
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Ajusta para o teclado
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
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
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(0, 74, 173, 1), // Fundo azul
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      color: Colors.white, // Cor do ícone
                      onPressed: () {
                        // Ação para alterar a imagem do perfil
                        _onEditProfileImage(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Editar Perfil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildEditableField(
                  label: 'Nome', initialValue: 'Douglas', icon: Icons.edit),
              _buildEditableField(
                  label: 'Sobrenome', initialValue: 'Cássio', icon: Icons.edit),
              _buildEditableField(
                  label: 'CPF',
                  initialValue: '000.000.000-00',
                  icon: Icons.edit),
              _buildEditableField(
                  label: 'Senha',
                  initialValue: '*********',
                  icon: Icons.edit,
                  isPassword: true),
              _buildEditableField(
                  label: 'Telefone',
                  initialValue: '62 9.8553-3417',
                  icon: Icons.edit),
              _buildEditableField(
                  label: 'Email',
                  initialValue: 'douglas@gmail.com',
                  icon: Icons.edit),
              _buildEditableField(
                  label: 'Saldo', initialValue: 'R\$ 25,00', icon: Icons.edit),
              _buildEditableField(
                  label: 'Data de Nascimento',
                  initialValue: '18/04/2000',
                  icon: Icons.edit),
              _buildEditableField(
                  label: 'Endereço',
                  initialValue: 'Av Aroeira',
                  icon: Icons.edit),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF004AAD),
                  shadowColor: Colors.green,
                  elevation: 3,
                ),
                onPressed: () {
                  // Ação do botão salvar
                },
                child: const Text('Salvar Alterações'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para construir os campos de edição
  Widget _buildEditableField({
    required String label,
    required String initialValue,
    required IconData icon,
    bool isPassword = false, // Se o campo é senha ou não
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        obscureText: isPassword, // Esconde o texto se for senha
        decoration: InputDecoration(
          labelText: label, // Adiciona o rótulo ao campo
          suffixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          suffixIconColor: const Color.fromRGBO(0, 74, 173, 1),
        ),
      ),
    );
  }

  // Função que será chamada ao clicar no botão de editar imagem
  void _onEditProfileImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt,
                    color: Color.fromRGBO(0, 73, 173, 1)),
                title: const Text('Tirar uma foto'),
                onTap: () {
                  Navigator.pop(context);
                  // Ação de tirar uma foto
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo,
                    color: Color.fromRGBO(0, 73, 173, 1)),
                title: const Text('Escolher da galeria'),
                onTap: () {
                  Navigator.pop(context);
                  // Ação de escolher da galeria
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
