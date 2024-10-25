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
            bottom: MediaQuery.of(context).viewInsets.bottom,
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
                    icon: const FaIcon(
                      FontAwesomeIcons.arrowLeft,
                      color: Color.fromRGBO(0, 74, 173, 1),
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

              // Campos de Perfil com ícones de edição
              _buildEditableFieldWithEdit(
                label: 'Nome',
                initialValue: 'Douglas',
                context: context,
              ),
              _buildEditableFieldWithEdit(
                label: 'Sobrenome',
                initialValue: 'Cássio',
                context: context,
              ),
              _buildEditableFieldWithEdit(
                label: 'Breve Descrição',
                initialValue: 'Olá, sou Douglas de Rubiataba Goiás.',
                context: context,
              ),
              _buildEditableFieldWithEdit(
                label: 'Número de Telefone',
                initialValue: '62 9.8553-3417',
                context: context,
              ),
              _buildEditableFieldWithEdit(
                label: 'Email',
                initialValue: 'douglas@gmail.com',
                context: context,
              ),
              _buildEditableFieldWithEdit(
                label: 'Endereço',
                initialValue: 'Av Aroeira, Q. A, L. 7, Setor Rubiatabinha',
                context: context,
              ),

              const SizedBox(height: 20),

              // Botões Cancelar e Salvar Alterações lado a lado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Cor para o botão Cancelar
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Salvar Alterações',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Função para construir os campos com ícones de edição
  Widget _buildEditableFieldWithEdit({
    required String label,
    required String initialValue,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '$label: $initialValue',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Color.fromRGBO(0, 74, 173, 1)),
            onPressed: () {
              _editProfileFieldDialog(context, label, initialValue);
            },
          ),
        ],
      ),
    );
  }

  // Função que cria o modal para editar campos de perfil
  void _editProfileFieldDialog(
      BuildContext context, String label, String initialValue) {
    final TextEditingController controller =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar $label'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Aqui você pode adicionar a lógica para salvar a alteração
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
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
