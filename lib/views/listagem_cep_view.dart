// ignore_for_file: unused_local_variable

import 'package:app_api_via_cep/models/listagem_enderecos.dart';
import 'package:app_api_via_cep/repository/back4app_repository.dart';
import 'package:app_api_via_cep/views/criacao_cep_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListagemCepView extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const ListagemCepView({Key? key});

  @override
  State<ListagemCepView> createState() => _ListCepViewState();
}

class _ListCepViewState extends State<ListagemCepView> {
  Back4AppRepository back4AppRepository = Back4AppRepository();
  late Future<List<ListagemCepModel>> _enderecosBack4AppModel;
  late String objectId;
  late String cep;
  late String logradouro;
  late String complemento;
  late String bairro;
  late String cidade;
  late String uf;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _enderecosBack4AppModel = getEnderecos();
  }

  Future<List<ListagemCepModel>> getEnderecos() async {
    List<ListagemCepModel> ceps = await back4AppRepository.getCeps();
    setState(() {
      loading = false;
    });
    return ceps;
  }

  Future<void> deleteEndereco(String objectId) async {
    try {
      await back4AppRepository.deleteEndereco(objectId);
      List<ListagemCepModel> updatedCeps = await getEnderecos();
      setState(() {
        _enderecosBack4AppModel = Future.value(updatedCeps);
      });
      // ignore: use_build_context_synchronously
      var showSnackBar2 = ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Endereço Excluído com sucesso!"),
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      var showSnackBar2 = ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao excluir o endereço: $e"),
        ),
      );
    }
  }

  void buscarEnderecoById(String id) async {
    var enderecos = await back4AppRepository.getEnderecoByObjectId(id);

    setState(() {
      objectId = enderecos!.objectId;
      cep = enderecos.cep;
      logradouro = enderecos.logradouro;
      bairro = enderecos.bairro;
      cidade = enderecos.cidade;
      uf = enderecos.uf;
    });
  }

  void enviarEndereco(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CriacaoCepView(
          objectId: objectId,
          cep: cep,
          logradouro: logradouro,
          bairro: bairro,
          cidade: cidade,
          uf: uf,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : FutureBuilder<List<ListagemCepModel>>(
                future: _enderecosBack4AppModel,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Nenhum endereço encontrado.');
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          var endereco = snapshot.data![index];
                          DateTime dataCriacao =
                              DateTime.parse(endereco.createdAt);
                          String dataFormatada = DateFormat('dd/MM/yyyy HH:mm')
                              .format(dataCriacao);
                          return Dismissible(
                            onDismissed: (DismissDirection dismissDirection) {
                              deleteEndereco(endereco.objectId);
                            },
                            key: Key(endereco.cidade),
                            child: GestureDetector(
                              onTap: () {
                                buscarEnderecoById(endereco.objectId);
                                enviarEndereco(context);
                              },
                              child: ListTile(
                                title: Text(
                                  "${endereco.logradouro} - ${endereco.bairro}\n${endereco.cidade} - ${endereco.uf}",
                                ),
                                subtitle: Text("Criado em: $dataFormatada"),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
      ),
    );
  }
}
