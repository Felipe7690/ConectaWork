import 'package:flutter/material.dart';
import 'package:trabalho_conecta_work/pages/tela_logar_inicio.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = '89IfoOBJSoVcMHAW5f9IbFIUfkkoT6MbElEfpeJa';
  const keyClientKey = 'eGXlRJtS1A3je6ZCqG1jNNABF8N1q1Yv9EQYUPnK';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    debug: true,
  );

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginInitialScreen(), //chama a a tela inicial de Login/Cadastro
    );
  }
}
