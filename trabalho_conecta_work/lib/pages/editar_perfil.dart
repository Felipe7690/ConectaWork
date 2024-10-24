import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/my_app_bar.dart';

class EditProfileSheet extends StatelessWidget {
  const EditProfileSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: const MyAppBar(showAddIcon: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [
              // Botão Voltar Row
              Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.arrowLeft,
                  color: const Color.fromRGBO(0, 74, 173, 1),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),

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
                      color: Color.fromRGBO(0, 74, 173, 1),
                      shape: BoxShape.circle,
                    ),
                    // Alterar Imagem de Perfil
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      color: Colors.white,
                      onPressed: () {
                        _onEditProfileImage(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Formulário da Edição de Perfil
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
                  label: 'Breve Descrição',
                  initialValue: 'Olá, sou Douglas de Rubiataba Goiás.',
                  icon: Icons.edit),
              _buildEditableField(
                  label: 'Número de Telefone',
                  initialValue: '62 9.8553-3417',
                  icon: Icons.edit),
              _buildEditableField(
                  label: 'Email',
                  initialValue: 'douglas@gmail.com',
                  icon: Icons.edit),
              _buildEditableField(
                  label: 'Endereço',
                  initialValue: 'Av Aroeira, Q. A, L. 7, Setor Rubiatabinha',
                  icon: Icons.edit),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
                  shadowColor: const Color.fromARGB(255, 0, 0, 0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Define o raio das bordas aqui
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Salvar Alterações',
                  style: TextStyle(
                    color: Color.fromARGB( 255, 255, 255, 255)
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required String initialValue,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
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
          // Tirar uma foto
          // Escolher da Galeria
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt,
                    color: Color.fromRGBO(0, 73, 173, 1)),
                title: const Text('Tirar uma foto'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo,
                    color: Color.fromRGBO(0, 73, 173, 1)),
                title: const Text('Escolher da galeria'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
