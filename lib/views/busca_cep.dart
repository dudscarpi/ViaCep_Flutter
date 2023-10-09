import 'package:app_api_via_cep/models/viacep_model.dart';
import 'package:app_api_via_cep/repository/viacep_repository.dart';
import 'package:app_api_via_cep/views/criacao_cep_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuscaCep extends StatefulWidget {
  const BuscaCep({Key? key}) : super(key: key);

  @override
  State<BuscaCep> createState() => _BuscaCepState();
}

class _BuscaCepState extends State<BuscaCep> {
  var controllerCep = TextEditingController(text: '');
  var viaCepModel = ViaCepModel();
  var viaCepRepository = ViaCepRepository();
  bool loading = false;

  void enviarEndereco(BuildContext context) async {
    String cep;
    String logradouro;
    String bairro;
    String cidade;
    String uf;
    if (viaCepModel.logradouro == null) {
      cep = controllerCep.text;
      logradouro = "";
      bairro = "";
      cidade = "";
      uf = "";
    } else {
      cep = viaCepModel.cep.toString();
      logradouro = viaCepModel.logradouro.toString();
      bairro = viaCepModel.bairro.toString();
      cidade = viaCepModel.localidade.toString();
      uf = viaCepModel.uf.toString();
    }

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CriacaoCepView(
                objectId: "default",
                cep: cep,
                logradouro: logradouro,
                bairro: bairro,
                cidade: cidade,
                uf: uf)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          children: [
            TextField(
              maxLength: 8,
              controller: controllerCep,
              keyboardType: TextInputType.number,
              onChanged: (String value) async {
                var cep = value;
                if (cep.length == 8) {
                  viaCepModel = await viaCepRepository.consultarCEP(cep);
                  setState(() {});
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              ],
              decoration: const InputDecoration(
                  labelText: 'CEP',
                  hintText: 'Digite aqui o CEP a Ser Buscado...'),
            ),
            GestureDetector(
                onTap: () {
                  enviarEndereco(context);
                },
                child: Card(
                    child: loading
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              if (viaCepModel.cep != null &&
                                  viaCepModel.cep == "")
                                Text(
                                  "${viaCepModel.cep} - ${viaCepModel.logradouro ?? ""}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              if (viaCepModel.bairro != null &&
                                  viaCepModel.bairro != "" &&
                                  viaCepModel.localidade != null &&
                                  viaCepModel.localidade != "" &&
                                  viaCepModel.uf != null &&
                                  viaCepModel.uf != "")
                                Text(
                                  "${viaCepModel.logradouro} - ${viaCepModel.bairro} - ${viaCepModel.localidade} - ${viaCepModel.uf}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ))),
            const SizedBox(
              height: 20,
            ),
            if (viaCepModel.cep == null || viaCepModel.cep == "")
              ElevatedButton(
                onPressed: () {
                  enviarEndereco(context);
                },
                child: const Text('Cadastrar CEP'),
              ),
          ],
        ),
      ),
    );
  }
}
