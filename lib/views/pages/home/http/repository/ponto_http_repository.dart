import 'dart:convert';

import 'package:ponto_prevent/models/ponto_model.dart';
import 'package:ponto_prevent/models/repository/ponto_repository.dart';
import 'package:http/http.dart' as http;

class PontoHttpRepository implements PontoRepository {
  @override
  Future<List<PontoModel>> findAllPontos() async {
    try {
      final response = await http
          .get(Uri.parse('https://comprovante-ponto.herokuapp.com/pontos'));
      final List<dynamic> responseMap = jsonDecode(response.body);

      return responseMap
          .map<PontoModel>((resp) => PontoModel.fromJson(resp))
          .toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
