import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class DescDemanda extends StatefulWidget {
  const DescDemanda({Key? key}) : super(key: key);

  @override
  State<DescDemanda> createState() => _DescDemandaState();
}

final List<String> banners = [
  'assets/imagens/banner1.jpg',
  'assets/imagens/banner3.jpg',
  'assets/imagens/banner4.jpg',
];

int _currentIndex = 0;

class _DescDemandaState extends State<DescDemanda> {
  final MoneyMaskedTextController _valorController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );
  final TextEditingController _dataEntregaController = TextEditingController();
  final MaskedTextController _whatsappController =
      MaskedTextController(mask: '(00) 0.0000-0000');

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildBanners(screenWidth),
            _buildDescricao(),
            _buildDescricaoCompleta(),
            _buildEnviarPropostaButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromRGBO(0, 74, 173, 1),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 16.0),
            child: Image.asset(
              'assets/imagens/logo.png',
              width: 60,
              height: 60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanners(double screenWidth) {
    final int numberOfDots = banners.length;
    final double indicatorWidth = (numberOfDots * 12) + 20;

    return SafeArea(
      top: false,
      child: SizedBox(
        height: screenWidth,
        width: screenWidth,
        child: Stack(
          children: [
            PageView.builder(
              itemCount: banners.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Image.asset(
                    banners[index],
                    fit: BoxFit.cover,
                    width: screenWidth,
                    height: screenWidth,
                  ),
                );
              },
            ),
            Positioned(
              bottom: 10,
              left: (screenWidth - indicatorWidth) / 2,
              child: _buildIndicator(indicatorWidth),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(double indicatorWidth) {
    return Container(
      width: indicatorWidth,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(banners.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == index
                  ? Colors.white
                  : Colors.grey.withOpacity(0.9),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDescricao() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                        'https://avatars.githubusercontent.com/u/116851523?v=4'),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Douglas Cássio",
                      style: TextStyle(
                        color: Color(0xFF004AAD),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              "Contratamos eletricista para serviços de manutenção e instalação elétrica.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "À 5 dias | Rubiataba, Goiás, Brasil",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescricaoCompleta() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Descrição:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Buscamos eletricista qualificado para manutenção e instalação elétrica. O candidato deve ter experiência, conhecimento das normas de segurança e capacidade de trabalhar de forma autônoma...",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnviarPropostaButton() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: const BoxDecoration(color: Colors.white),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: ElevatedButton.icon(
            onPressed: () => _showConfirmationDialog(context),
            icon: const Icon(
              Icons.send,
              color: Colors.white,
            ),
            label: const Text(
              "Enviar Proposta",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Enviar Proposta"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _valorController,
                  decoration: const InputDecoration(
                    labelText: "Valor",
                    prefixIcon: Icon(
                      Icons.monetization_on,
                      color: Color(0xFF004AAD),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Color(0xFF004AAD),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF004AAD)),
                    ),
                  ),
                  cursorColor: Color(0xFF004AAD),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _dataEntregaController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Data de Entrega",
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: Color(0xFF004AAD),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Color(0xFF004AAD),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF004AAD)),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: Colors.white,
                            colorScheme: ColorScheme.light(
                              primary: Color(0xFF004AAD),
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: Colors.black,
                            ),
                            dialogBackgroundColor: Colors.white,
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                      setState(() {
                        _dataEntregaController.text = formattedDate;
                      });
                    }
                  },
                ),
                TextField(
                  controller: _whatsappController,
                  decoration: const InputDecoration(
                    labelText: "WhatsApp",
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Color(0xFF004AAD),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Color(0xFF004AAD),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF004AAD)),
                    ),
                  ),
                  cursorColor: Color(0xFF004AAD),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  color: Color(0xFF004AAD),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Enviar",
                  style: TextStyle(
                    color: Color(0xFF004AAD),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                )),
          ],
        );
      },
    );
  }
}
