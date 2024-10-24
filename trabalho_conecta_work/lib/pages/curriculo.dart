import 'package:flutter/material.dart';
import '../components/my_app_bar.dart';

class Curriculum extends StatelessWidget {
  const Curriculum({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(showAddIcon: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Aqui você pode visualizar ou editar seu currículo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),

            // HABILIDADES
            _buildSectionHeaderWithEdit('Habilidades', context),
            const SizedBox(height: 10),
            _buildSkillItem('Proativo'),
            _buildSkillItem('Boa comunicação'),
            _buildSkillItem('Lider'),
            _buildSkillItem('Pontual'),
            const Divider(),
          ],
        ),
      ),
    );
  }

  // Função auxiliar para construir o cabeçalho da seção Habilidades com o ícone de edição
  Widget _buildSectionHeaderWithEdit(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Color.fromRGBO(0, 74, 173, 1)),
          onPressed: () {
            // Abre o modal de edição de habilidades
            _editSkillsDialog(context);
          },
        ),
      ],
    );
  }

  // Função auxiliar para construir as habilidades
  Widget _buildSkillItem(String skill) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(skill),
        ],
      ),
    );
  }

  // Função que cria o modal para editar as habilidades
  void _editSkillsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController skillController1 = TextEditingController(text: 'Proativo');
        final TextEditingController skillController2 = TextEditingController(text: 'Boa comunicação');
        final TextEditingController skillController3 = TextEditingController(text: 'Lider');
        final TextEditingController skillController4 = TextEditingController(text: 'Pontual');

        return AlertDialog(
          title: const Text('Editar Habilidades'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditableSkillField(skillController1),
              _buildEditableSkillField(skillController2),
              _buildEditableSkillField(skillController3),
              _buildEditableSkillField(skillController4),
            ],
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
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  // Função auxiliar para construir os campos editáveis no modal
  Widget _buildEditableSkillField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Habilidade',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
