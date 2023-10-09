import 'package:app_api_via_cep/models/viacep_model.dart';
import 'package:dio/dio.dart';

class ViaCepRepository {
  Future<ViaCepModel> consultarCEP(String cep) async {
    var dio = Dio();
    var result = await dio.get("https://viacep.com.br/ws/$cep/json/");
    if (result.statusCode == 200) {
      return ViaCepModel.fromJson(result.data);
    }
    return ViaCepModel();
  }
}
