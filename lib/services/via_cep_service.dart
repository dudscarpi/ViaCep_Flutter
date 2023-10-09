import 'package:app_api_via_cep/models/result_cep.dart';
import 'package:http/http.dart' as http;

class ViaCepService {
  final String baseUrl = 'https://viacep.com.br/ws';

  Future<ResultCep> fetchCep({required String cep}) async {
    final response = await http.get(Uri.parse('$baseUrl/$cep/json/'));

    if (response.statusCode == 200) {
      return ResultCep.fromJson(response.body);
    } else {
      throw Exception('Requisição inválida!');
    }
  }
}
