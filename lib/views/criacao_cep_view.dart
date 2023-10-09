import 'package:app_api_via_cep/models/listagem_enderecos.dart';
import 'package:app_api_via_cep/repository/back4app_repository.dart';
import 'package:app_api_via_cep/views/nav.dart';
import 'package:flutter/material.dart';

class CriacaoCepView extends StatefulWidget {
  final String objectId;
  final String cep;
  final String logradouro;
  final String bairro;
  final String cidade;
  final String uf;

  const CriacaoCepView({
    required this.objectId,
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.cidade,
    required this.uf,
  });

  @override
  State<CriacaoCepView> createState() => _CriacaoCepViewState();
}

class _CriacaoCepViewState extends State<CriacaoCepView> {
  Back4AppRepository back4AppRepository = Back4AppRepository();
  var cepController = TextEditingController();
  var logradouroController = TextEditingController(text: null);
  var bairroController = TextEditingController(text: null);
  var cidadeController = TextEditingController(text: null);
  var ufController = TextEditingController(text: null);

  @override
  void initState() {
    super.initState();
    dadosEndereco();
  }

  void dadosEndereco() {
    cepController.text = widget.cep;
    logradouroController.text = widget.logradouro;
    bairroController.text = widget.bairro;
    cidadeController.text = widget.cidade;
    ufController.text = widget.uf;
    setState(() {});
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Nav()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar/Atualizar"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
              child: Column(
            children: [
              TextFormField(
                controller: cepController,
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  hintText: 'Digite o CEP',
                ),
              ),
              TextFormField(
                controller: logradouroController,
                decoration: const InputDecoration(
                  labelText: 'Logradouro',
                  hintText: 'Nome da Rua',
                ),
              ),
              TextFormField(
                controller: bairroController,
                decoration: const InputDecoration(
                  labelText: 'Bairro',
                  hintText: 'Nome do Bairro',
                ),
              ),
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: cidadeController,
                        decoration: const InputDecoration(
                          labelText: 'Cidade',
                          hintText: 'Nome da Cidade',
                        ),
                      )),
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: ufController,
                        decoration: const InputDecoration(
                          labelText: 'UF-Estado',
                          hintText: 'Sigla do Estado',
                        ),
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (cepController.text == "" ||
                        logradouroController.text == "" ||
                        bairroController.text == "" ||
                        cidadeController.text == "" ||
                        ufController.text == "") {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Ops!! Algo deu errado!"),
                              content: const Wrap(
                                children: [
                                  Text(
                                      "Preencha todos os campos antes de tenatar enviar o endereço!"),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"))
                              ],
                            );
                          });
                    } else if (widget.objectId == "default") {
                      await back4AppRepository.createEndereco(
                          ListagemCepModel.create(
                              cepController.text,
                              logradouroController.text,
                              bairroController.text,
                              cidadeController.text,
                              ufController.text));
                      showSnackBar("Endereço criado com sucesso!");
                    } else {
                      await back4AppRepository.updateEndereco(
                          ListagemCepModel.update(
                              widget.objectId,
                              cepController.text,
                              logradouroController.text,
                              bairroController.text,
                              cidadeController.text,
                              ufController.text));
                      showSnackBar("Endereço atualizado com sucesso!");
                    }
                  },
                  child: const Text("Enviar Novo Endereço"))
            ],
          )),
        ),
      ),
    );
  }
}
