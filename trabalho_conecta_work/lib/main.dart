import 'package:flutter/material.dart';
import 'package:trabalho_conecta_work/pages/home.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // Chama a página principal que puxa os componentes.
    );
  }
}
