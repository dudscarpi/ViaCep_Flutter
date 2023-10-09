import 'package:app_api_via_cep/models/listagem_enderecos.dart';
import 'package:app_api_via_cep/repository/back4app_repository.dart';
import 'package:app_api_via_cep/views/busca_cep.dart';
import 'package:app_api_via_cep/views/listagem_cep_view.dart';
import 'package:flutter/material.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectViewIndex = 1;

  _selectView(int index) {
    setState(() {
      _selectViewIndex = index;
    });
  }

  List<Map<String, Object>> _views = [];
  var viaCepRepository = Back4AppRepository();
  var back4AppHttpRepository = Back4AppRepository();
  var viaCepModel = ListagemCepModel;

  @override
  void initState() {
    super.initState();
    _views = [
      {'title': 'Buscar CEP', 'view': const BuscaCep()},
      {'title': 'Meus Endereços', 'view': const ListagemCepView()},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _views[_selectViewIndex]['title'] as String,
        ),
        centerTitle: true,
      ),
      body: _views[_selectViewIndex]['view'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectView,
          currentIndex: _selectViewIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search_sharp),
              label: 'Buscar CEP',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded),
              label: 'Meus Endereços',
            ),
          ]),
    );
  }
}
