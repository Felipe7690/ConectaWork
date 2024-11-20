import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:intl/intl.dart';

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({super.key});

  @override
  _EditProfileSheetState createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  File? _selectedImage;
  String _imageUrl = '';
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _phoneController = TextEditingController();

  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _complementController = TextEditingController();
  final _cityController = TextEditingController();

  DateTime? _birthdate;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser != null) {
      setState(() {
        _imageUrl = currentUser.get<ParseFile>('profileImage')?.url ?? '';
        _nameController.text = currentUser.get<String>('username') ?? '';
        _descriptionController.text = currentUser.get<String>('description') ?? '';
        _emailController.text = currentUser.get<String>('email') ?? '';
        _cpfController.text = currentUser.get<String>('cpf') ?? '';
        _phoneController.text = currentUser.get<String>('phone') ?? '';

        _birthdate = currentUser.get<DateTime>('birthdate');
        _birthdateController.text = _birthdate != null
            ? DateFormat('dd-MM-yyyy').format(_birthdate!)
            : '';

        final addressMap = currentUser.get<Map<String, dynamic>>('address');
        if (addressMap != null) {
          _streetController.text = addressMap['street'] ?? '';
          _numberController.text = addressMap['number'] ?? '';
          _neighborhoodController.text = addressMap['neighborhood'] ?? '';
          _complementController.text = addressMap['complement'] ?? '';
          _cityController.text = addressMap['city'] ?? '';
        }
      });
    }
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser != null) {
      currentUser
        ..set('username', _nameController.text)
        ..set('description', _descriptionController.text)
        ..set('email', _emailController.text)
        ..set('cpf', _cpfController.text)
        ..set('birthdate', _birthdate)
        ..set('phone', _phoneController.text)
        ..set('address', {
          'street': _streetController.text,
          'number': _numberController.text,
          'neighborhood': _neighborhoodController.text,
          'complement': _complementController.text,
          'city': _cityController.text,
        });

      if (_selectedImage != null) {
        final parseFile = ParseFile(_selectedImage!);
        final response = await parseFile.save();
        if (response.success) {
          currentUser.set('profileImage', parseFile);
        } else {
          print('Erro ao salvar a imagem: ${response.error?.message}');
        }
      }

      final response = await currentUser.save();
      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso')),
        );
        Navigator.pop(context);
      } else {
        print('Erro ao atualizar o perfil: ${response.error?.message}');
      }
    }
  }

  Future<void> _selectBirthdate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _birthdate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    );

    if (selectedDate != null) {
      setState(() {
        _birthdate = selectedDate;
        _birthdateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!)
                    : NetworkImage(_imageUrl.isEmpty
                        ? 'https://example.com/default-profile.png'
                        : _imageUrl) as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _selectImage,
                child: const Text('Alterar imagem'),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: [
                  const Text(
                    'Dados',
                    style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Breve descrição'),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: _cpfController,
                    decoration: const InputDecoration(labelText: 'CPF'),
                  ),
                  TextFormField(
                    controller: _birthdateController,
                    readOnly: true,
                    onTap: _selectBirthdate,
                    decoration: const InputDecoration(labelText: 'Data de nascimento'),
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Número de telefone'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Endereço',
                    style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    controller: _streetController,
                    decoration: const InputDecoration(labelText: 'Rua'),
                  ),
                  TextFormField(
                    controller: _numberController,
                    decoration: const InputDecoration(labelText: 'Número'),
                  ),
                  TextFormField(
                    controller: _neighborhoodController,
                    decoration: const InputDecoration(labelText: 'Bairro'),
                  ),
                  TextFormField(
                    controller: _complementController,
                    decoration: const InputDecoration(labelText: 'Complemento'),
                  ),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'Cidade'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
