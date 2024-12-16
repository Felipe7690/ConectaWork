import 'package:flutter/material.dart';
import '../components/my_app_bar.dart';

class Curriculum extends StatelessWidget {
  const Curriculum({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: const MyAppBar(showAddIcon: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Aqui você pode visualizar ou editar seu currículo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),

            // HABILIDADES
            _buildSectionHeaderWithAdd('Habilidades', context, _editSkillsDialog),
            const SizedBox(height: 10),
            _buildSkillItem('Nada adicionado'),
            const Divider(),

            // EXPERIÊNCIA
            _buildSectionHeaderWithAdd('Experiência', context, _editExperienceDialog),
            const SizedBox(height: 10),
            _buildExperienceItem('Nada adicionado'),
            const Divider(),

            // FORMAÇÃO
            _buildSectionHeaderWithAdd('Formação', context, _editEducationDialog),
            const SizedBox(height: 10),
            _buildEducationItem('Nada adicionado'),
            const Divider(),

            // CERTIFICADOS
            _buildSectionHeaderWithAdd('Certificados', context, _editCertificatesDialog),
            const SizedBox(height: 10),
            _buildCertificateItem('Nada adicionado'),
            const Divider(),
          ],
        ),
      ),
    );
  }

  // Função auxiliar para o cabeçalho com o botão +
  Widget _buildSectionHeaderWithAdd(String title, BuildContext context, Function onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Color.fromRGBO(0, 74, 173, 1)),
          onPressed: () {
            onPressed(context);
          },
        ),
      ],
    );
  }

  // Função auxiliar para os itens de habilidades
  Widget _buildSkillItem(String skill) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(skill, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // Função auxiliar para os itens de experiência
  Widget _buildExperienceItem(String position) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(position, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // Função auxiliar para os itens de formação
  Widget _buildEducationItem(String degree) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(degree, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // Função auxiliar para os itens de certificados
  Widget _buildCertificateItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // Função auxiliar para os campos editáveis
  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromRGBO(0, 74, 173, 1)),
          ),
        ),
      ),
    );
  }

  // Função para editar habilidades
  void _editSkillsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController skillController1 = TextEditingController();
        final TextEditingController skillController2 = TextEditingController();
        final TextEditingController skillController3 = TextEditingController();
        final TextEditingController skillController4 = TextEditingController();

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

  // Função para editar experiência
  void _editExperienceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController positionController = TextEditingController();
        final TextEditingController companyController = TextEditingController();
        final TextEditingController durationController = TextEditingController();

        return AlertDialog(
          title: const Text('Editar Experiência'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditableField('Cargo', positionController),
              _buildEditableField('Empresa', companyController),
              _buildEditableField('Duração', durationController),
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

  // Função para editar formação
  void _editEducationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController degreeController = TextEditingController();
        final TextEditingController institutionController = TextEditingController();
        final TextEditingController periodController = TextEditingController();

        return AlertDialog(
          title: const Text('Editar Formação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditableField('Curso', degreeController),
              _buildEditableField('Instituição', institutionController),
              _buildEditableField('Período', periodController),
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

  // Função para editar certificados
  void _editCertificatesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController titleController = TextEditingController();
        final TextEditingController issuerController = TextEditingController();
        final TextEditingController yearController = TextEditingController();

        return AlertDialog(
          title: const Text('Editar Certificados'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditableField('Título', titleController),
              _buildEditableField('Emissor', issuerController),
              _buildEditableField('Ano', yearController),
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

  // Função auxiliar para construir os campos de habilidade
  Widget _buildEditableSkillField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
