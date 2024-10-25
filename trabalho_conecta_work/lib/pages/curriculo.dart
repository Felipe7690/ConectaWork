import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Importar o package de seleção de arquivos
import '../components/my_app_bar.dart';

class Curriculum extends StatelessWidget {
  const Curriculum({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
            _buildSectionHeaderWithEdit('Habilidades', context, _editSkillsDialog),
            const SizedBox(height: 10),
            _buildSkillItem('Proativo'),
            _buildSkillItem('Boa comunicação'),
            _buildSkillItem('Líder'),
            _buildSkillItem('Pontual'),
            const Divider(),

            // EXPERIÊNCIA
            _buildSectionHeaderWithEdit('Experiência', context, _editExperienceDialog),
            const SizedBox(height: 10),
            _buildExperienceItem('Desenvolvedor Flutter', 'Empresa X', 'Jan 2020 - Atual'),
            _buildExperienceItem('Estagiário TI', 'Empresa Y', 'Jan 2019 - Dez 2019'),
            const Divider(),

            // FORMAÇÃO
            _buildSectionHeaderWithEdit('Formação', context, _editEducationDialog),
            const SizedBox(height: 10),
            _buildEducationItem('Bacharelado em Ciência da Computação', 'Universidade ABC', '2016 - 2020'),
            _buildEducationItem('Curso Técnico em Informática', 'Escola Técnica XYZ', '2014 - 2016'),
            const Divider(),

            // CERTIFICADOS
            _buildSectionHeaderWithEdit('Certificados', context, _editCertificatesDialog),
            const SizedBox(height: 10),
            _buildCertificateItem('Certificado de Flutter Avançado', 'Instituto Z', '2021'),
            _buildCertificateItem('Certificação AWS', 'AWS', '2022'),
            const Divider(),
          ],
        ),
      ),
    );
  }

  // Função auxiliar para construir o cabeçalho
  Widget _buildSectionHeaderWithEdit(String title, BuildContext context, Function onPressed) {
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
            onPressed(context);
          },
        ),
      ],
    );
  }

  // Função auxiliar para construir os itens de habilidades
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

  // Função auxiliar para construir os itens de experiência
  Widget _buildExperienceItem(String position, String company, String duration) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            position,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('$company | $duration'),
        ],
      ),
    );
  }

  // Função auxiliar para construir os itens de formação
  Widget _buildEducationItem(String degree, String institution, String period) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            degree,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('$institution | $period'),
        ],
      ),
    );
  }

  // Função auxiliar para construir os itens de certificados
  Widget _buildCertificateItem(String title, String issuer, String year) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('$issuer | $year'),
        ],
      ),
    );
  }

  // Função para abrir o modal de edição de certificados
  void _editCertificatesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController titleController = TextEditingController(text: 'Certificado de Flutter Avançado');
        final TextEditingController issuerController = TextEditingController(text: 'Instituto Z');
        final TextEditingController yearController = TextEditingController(text: '2021');
        String? filePath;

        return AlertDialog(
          title: const Text('Editar Certificados'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditableField('Título', titleController),
              _buildEditableField('Emissor', issuerController),
              _buildEditableField('Ano', yearController),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  // Função para selecionar o arquivo
                  FilePickerResult? result = await FilePicker.platform.pickFiles();

                  if (result != null && result.files.isNotEmpty) {
                    filePath = result.files.single.path; // Armazena o caminho do arquivo selecionado
                  }
                },
                child: const Text('Selecionar Arquivo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
                ),
              ),
              if (filePath != null) ...[ 
                const SizedBox(height: 10),
                Text('Arquivo selecionado:'),
                Text(filePath!, style: const TextStyle(fontStyle: FontStyle.italic)),
              ],
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Certificado salvo com sucesso!')),
                );
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
  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  // Função para abrir o modal de edição de habilidades
  void _editSkillsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController skillController1 = TextEditingController(text: 'Proativo');
        final TextEditingController skillController2 = TextEditingController(text: 'Boa comunicação');
        final TextEditingController skillController3 = TextEditingController(text: 'Líder');
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

  // Função para abrir o modal de edição de experiência
  void _editExperienceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController positionController = TextEditingController(text: 'Desenvolvedor Flutter');
        final TextEditingController companyController = TextEditingController(text: 'Empresa X');
        final TextEditingController durationController = TextEditingController(text: 'Jan 2020 - Atual');

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

  // Função para abrir o modal de edição de formação
  void _editEducationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController degreeController = TextEditingController(text: 'Bacharelado em Ciência da Computação');
        final TextEditingController institutionController = TextEditingController(text: 'Universidade ABC');
        final TextEditingController periodController = TextEditingController(text: '2016 - 2020');

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

  // Função auxiliar para construir os campos editáveis de habilidades no diálogo
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
