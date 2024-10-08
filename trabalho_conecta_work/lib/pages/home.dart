// lib/pages/home.dart
import 'package:flutter/material.dart';
import 'package:trabalho_conecta_work/components/my_app_bar.dart';
import 'package:trabalho_conecta_work/components/my_bottom_bar.dart'; // Importando o MyBottomBar

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  int currentPage = 0;
  final List<Color> colors = [Colors.blue, Colors.green, Colors.red];
  final Color unselectedColor = const Color.fromARGB(255, 255, 255, 255);

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);

    // Listener para atualizar o índice atual
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() {
          currentPage = tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
      appBar: MyAppBar(),
      bottomNavigationBar: MyBottomBar(
        tabController: tabController,
        colors: colors,
        unselectedColor: unselectedColor,
        currentPage: currentPage,
      ),
    );
  }
}
