import 'package:flutter/material.dart';
import 'package:trabalho_conecta_work/pages/nova_demanda.dart'; // Certifique-se de que o caminho esteja correto

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool
      showAddIcon; // Adiciona o parâmetro para controlar a exibição do ícone

  // Construtor que aceita o parâmetro showAddIcon (com valor padrão true)
  const MyAppBar({super.key, this.showAddIcon = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Remove o botão de voltar automático
      title: Image.asset(
        "assets/imagens/logo_b.png",
        height: 40, // Defina a altura da imagem
        fit: BoxFit.scaleDown,
      ),
      backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
      elevation: 0,
      actions: showAddIcon // Condicional para mostrar ou não o ícone "+"
          ? [
              IconButton(
                onPressed: () {
                  // Navega para a página NovaDemanda quando o ícone "mais" é pressionado
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NovaDemanda()),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ]
          : null, // Se showAddIcon for false, não exibe o ícone
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
