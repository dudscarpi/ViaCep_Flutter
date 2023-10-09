import 'dart:convert';

class ResultCep {
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;
  final String unidade;
  final String ibge;
  final String gia;

  ResultCep({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.unidade,
    required this.ibge,
    required this.gia,
  });

  factory ResultCep.fromJson(String str) => ResultCep.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResultCep.fromMap(Map<String, dynamic> json) => ResultCep(
        cep: json["cep"] ?? '',
        logradouro: json["logradouro"] ?? '',
        complemento: json["complemento"] ?? '',
        bairro: json["bairro"] ?? '',
        localidade: json["localidade"] ?? '',
        uf: json["uf"] ?? '',
        unidade: json["unidade"] ?? '',
        ibge: json["ibge"] ?? '',
        gia: json["gia"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "cep": cep,
        "logradouro": logradouro,
        "complemento": complemento,
        "bairro": bairro,
        "localidade": localidade,
        "uf": uf,
        "unidade": unidade,
        "ibge": ibge,
        "gia": gia,
      };
}
