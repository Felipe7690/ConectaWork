import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:trabalho_conecta_work/pages/inicio.dart';
import 'package:trabalho_conecta_work/pages/pesquisar.dart';

class MyBottomBar extends StatelessWidget {
  final TabController tabController;
  final List<Color> colors;
  final Color unselectedColor;
  final int currentPage;

  const MyBottomBar({
    Key? key,
    required this.tabController,
    required this.colors,
    required this.unselectedColor,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      child: TabBar(
        controller: tabController,
        tabs: [
          Tab(icon: Icon(Icons.home, color: Colors.white)),
          Tab(icon: Icon(Icons.search_rounded, color: Colors.white)),
          Tab(icon: Icon(Icons.person, color: Colors.white)),
        ],
      ),
      fit: StackFit.expand,
      icon: (width, height) => Center(
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: null,
          icon: Icon(
            Icons.arrow_upward_rounded,
            color: unselectedColor,
            size: width,
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(20),
      duration: const Duration(seconds: 1),
      curve: Curves.decelerate,
      showIcon: true,
      width: MediaQuery.of(context).size.width * 0.8,
      barColor: colors[currentPage].computeLuminance() > 0.5
          ? const Color.fromARGB(255, 255, 255, 255)
          : const Color.fromRGBO(0, 74, 173, 1),
      start: 2,
      end: 0,
      offset: 10,
      barAlignment: Alignment.bottomCenter,
      iconHeight: 35,
      iconWidth: 35,
      reverse: false,
      barDecoration: BoxDecoration(
        color: colors[currentPage],
        borderRadius: BorderRadius.circular(500),
      ),
      iconDecoration: BoxDecoration(
        color: colors[currentPage],
        borderRadius: BorderRadius.circular(500),
      ),
      hideOnScroll: true,
      scrollOpposite: false,
      onBottomBarHidden: () {},
      onBottomBarShown: () {},
      body: (context, controller) => TabBarView(
        controller: tabController,
        dragStartBehavior: DragStartBehavior.down,
        physics: const BouncingScrollPhysics(),
        children: [
          Center(
            child: Inicio(),
          ),
          Center(
            child: Pesquisar(),
          ),
          Center(
            child: Container(
              height: 500,
              width: 300,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(235, 235, 235, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
              child: Center(
                child: Text(
                  "Aula de Mobile",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
