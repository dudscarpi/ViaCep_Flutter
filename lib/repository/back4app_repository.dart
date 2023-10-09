import 'package:app_api_via_cep/models/listagem_enderecos.dart';
import 'package:app_api_via_cep/repository/back4app_custom_dio.dart';

class Back4AppRepository {
  final _customDio = Back4AppCustomDio();

  Back4AppRepository();

  Future<List<ListagemCepModel>> getCeps() async {
    try {
      var result = await _customDio.dio.get("/enderecos");

      // Verifique se a chave "results" existe no JSON
      if (result.data.containsKey('results')) {
        // Obtém a lista de objetos JSON da chave "results"
        List<dynamic> data = result.data['results'];

        // Converta a lista de JSON em uma lista de objetos ListagemCepModel
        List<ListagemCepModel> list =
            data.map((json) => ListagemCepModel.fromJson(json)).toList();

        return list;
      } else {
        // Se a chave "results" não estiver presente no JSON, lance uma exceção
        throw Exception(
            'A chave "results" não está presente no JSON retornado.');
      }
    } catch (e) {
      throw Exception('Ocorreu um erro ao buscar os endereços: $e');
    }
  }

  Future<ListagemCepModel?> getEnderecoByObjectId(String objectId) async {
    try {
      final result = await _customDio.dio.get("/enderecos/$objectId");
      return ListagemCepModel.fromJson(result.data);
    } catch (e) {
      throw Exception('Ocorreu um erro ao buscar o endereço: $e');
    }
  }

  Future<void> createEndereco(ListagemCepModel enderecosBack4AppModel) async {
    try {
      await _customDio.dio
          .post("/enderecos", data: enderecosBack4AppModel.toJsonEndpoint());
    } catch (e) {
      throw Exception('Ocorreu um erro ao criar o endereço: $e');
    }
  }

  Future<void> updateEndereco(ListagemCepModel enderecosBack4AppModel) async {
    try {
      await _customDio.dio.put("/enderecos/${enderecosBack4AppModel.objectId}",
          data: enderecosBack4AppModel.toJsonEndpoint());
    } catch (e) {
      throw Exception('Ocorreu um erro ao atualizar o endereço: $e');
    }
  }

  Future<void> deleteEndereco(String objectId) async {
    try {
      await _customDio.dio.delete("/enderecos/$objectId");
    } catch (e) {
      throw Exception('Ocorreu um erro ao excluir o endereço: $e');
    }
  }
}
