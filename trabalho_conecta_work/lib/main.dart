import 'package:flutter/material.dart';
import 'package:trabalho_conecta_work/pages/completar_cadastro.dart';
import 'package:trabalho_conecta_work/pages/curriculo.dart';
import 'package:trabalho_conecta_work/pages/home.dart';
import 'package:trabalho_conecta_work/pages/proposta.dart';
import 'package:trabalho_conecta_work/pages/tela_cadastrar.dart';
import 'package:trabalho_conecta_work/pages/tela_logar.dart';
import 'package:trabalho_conecta_work/pages/tela_logar_inicio.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'EkIrRkqtiHoxcZNxyLh1DrWuAnJYrzm6hmdIoQpo';
  const keyClientKey = 'syruc7EpG2sObLu5kcbseCxSFtRmqCIT7C2A0ZFE';
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
    return MaterialApp(
      initialRoute: '/loginInitial',
      routes: {
        '/loginInitial': (context) => LoginInitialScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomePage(),
        '/propostas': (context) => ProposalScreen(),
        '/curriculo': (context) => Curriculum(),
        '/completar_cadastro': (context) => FutureBuilder<ParseUser?>(
              future: _getCurrentUser(), // Verifica se o usuário está logado
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data != null) {
                  return CompleteProfileScreen(
                      user: snapshot.data!); // Passa o usuário logado
                } else {
                  return LoginScreen();
                }
              },
            ),
      },
      debugShowCheckedModeBanner: false,
    );
  }

  // Método para verificar se o usuário está logado
  Future<ParseUser?> _getCurrentUser() async {
    ParseUser? user = await ParseUser.currentUser();
    return user; // Retorna o usuário logado
  }
}
