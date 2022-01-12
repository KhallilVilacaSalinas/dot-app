import 'dart:convert';

class PontoModel {
  final String sId;
  final String sIdComprovante;
  final String idUser;
  final String dateTime;
  final String dateTile;
  final String image;
  final int iV;

  PontoModel({
    required this.sId,
    required this.sIdComprovante,
    required this.idUser,
    required this.dateTime,
    required this.dateTile,
    required this.image,
    required this.iV,
  });

  Map<String, dynamic> toJosn() {
    return {
      '_id': sId,
      '_idComprovante': sIdComprovante,
      'idUser': idUser,
      'dateTime': dateTime,
      'dateTile': dateTile,
      'image': image,
      '__v': iV,
    };
  }

  factory PontoModel.fromJson(Map<String, dynamic> map) {
    return PontoModel(
      sId: map['_id'] as String,
      sIdComprovante: map['_idComprovante'] as String,
      idUser: map['idUser'] as String,
      dateTime: map['dateTime'] as String,
      dateTile: map['dateTile'] as String,
      image: map['image'] as String,
      iV: map['__v'] as int,
    );
  }
}


// factory PontoModel.fromJson(dynamic json) {
  //   return PontoModel(
  //     idComprovante: json['_idComprovante'],
  //     idUser: json['idUser'],
  //     dateTime: json['dateTime'],
  //     dateTile: json['dateTile'],
  //     image: json['image'],
  //   );
  // }

  // static List<PontoModel> pontosFromSnapshot(List snapshot) {
  //   return snapshot.map((data) {
  //     return PontoModel.fromJson(data);
  //   }).toList();
  // }

  // @override
  // String toString() {
  //   return 'Ponto {idComprovante: $idComprovante, idUser: $idUser, dateTime: $dateTime, dateTile: $dateTile}';
  // }
