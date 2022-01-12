import 'package:ponto_prevent/models/ponto_model.dart';

abstract class PontoRepository {
  Future<List<PontoModel>> findAllPontos();
}
