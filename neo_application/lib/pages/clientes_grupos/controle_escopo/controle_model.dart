import 'dart:convert';

import 'package:neo_application/pages/clientes_grupos/adm_grupos/grupos_model.dart';
import 'package:neo_application/pages/clientes_grupos/entidades_gestoras/entidades_model.dart';
import 'package:neo_application/pages/clientes_grupos/fracao_propriedades/fracao_model.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propFloresta/propFloresta_model.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propriedades_model.dart';

class ControleModel {
  int? ID;
  int? idFracao;
  FracaoPropModel? fracao;
  int? idEntidade;
  EntidadesModel? entidades;
  int? idPropriedade;
  PropriedadesModel? propriedades;
  int? idGrupo;
  GruposModel? grupos;
  String? DataEntrada;
  String? DataSaida;
  String? RequerenteSaida;
  double? AreaEscopo;
  double? AreaAuditada;
  int? CicloTrabalho;

  
  ControleModel({
    this.ID,
    this.idFracao,
    this.fracao,
    this.idEntidade,
    this.entidades,
    this.idPropriedade,
    this.propriedades,
    this.idGrupo,
    this.grupos,
    this.DataEntrada,
    this.DataSaida,
    this.RequerenteSaida,
    this.AreaEscopo,
    this.AreaAuditada,
    this.CicloTrabalho,
  });


  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(ID != null){
      result.addAll({'ID': ID});
    }
    if(idFracao != null){
      result.addAll({'idFracao': idFracao});
    }
    if(fracao != null){
      result.addAll({'fracao': fracao!.toMap()});
    }
    if(idEntidade != null){
      result.addAll({'idEntidade': idEntidade});
    }
    if(entidades != null){
      result.addAll({'entidades': entidades!.toMap()});
    }
    if(idPropriedade != null){
      result.addAll({'idPropriedade': idPropriedade});
    }
    if(propriedades != null){
      result.addAll({'propriedades': propriedades!.toMap()});
    }
    if(idGrupo != null){
      result.addAll({'idGrupo': idGrupo});
    }
    if(grupos != null){
      result.addAll({'grupos': grupos!.toMap()});
    }
    if(DataEntrada != null){
      result.addAll({'DataEntrada': DataEntrada});
    }
    if(DataSaida != null){
      result.addAll({'DataSaida': DataSaida});
    }
    if(RequerenteSaida != null){
      result.addAll({'RequerenteSaida': RequerenteSaida});
    }
    if(AreaEscopo != null){
      result.addAll({'AreaEscopo': AreaEscopo});
    }
    if(AreaAuditada != null){
      result.addAll({'AreaAuditada': AreaAuditada});
    }
    if(CicloTrabalho != null){
      result.addAll({'CicloTrabalho': CicloTrabalho});
    }
  
    return result;
  }

  factory ControleModel.fromMap(Map<String, dynamic> map) {
    return ControleModel(
      ID: map['ID']?.toInt(),
      idFracao: map['idFracao']?.toInt(),
      fracao: map['fracao'] != null ? FracaoPropModel.fromMap(map['fracao']) : null,
      idEntidade: map['idEntidade']?.toInt(),
      entidades: map['entidades'] != null ? EntidadesModel.fromMap(map['entidades']) : null,
      idPropriedade: map['idPropriedade']?.toInt(),
      propriedades: map['propriedades'] != null ? PropriedadesModel.fromMap(map['propriedades']) : null,
      idGrupo: map['idGrupo']?.toInt(),
      grupos: map['grupos'] != null ? GruposModel.fromMap(map['grupos']) : null,
      DataEntrada: map['DataEntrada'],
      DataSaida: map['DataSaida'],
      RequerenteSaida: map['RequerenteSaida'],
      AreaEscopo: map['AreaEscopo']?.toDouble(),
      AreaAuditada: map['AreaAuditada']?.toDouble(),
      CicloTrabalho: map['CicloTrabalho']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ControleModel.fromJson(String source) => ControleModel.fromMap(json.decode(source));
}
