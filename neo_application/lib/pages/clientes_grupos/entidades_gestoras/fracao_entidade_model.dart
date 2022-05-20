import 'dart:convert';
import 'package:neo_application/pages/clientes_grupos/entidades_gestoras/entidades_model.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propriedades_model.dart';

class FracaoPorEntidadeModel {
int? ID;
int? IDEntidade;
EntidadesModel? entidades;
int? IDPropriedade;
PropriedadesModel? propriedades;
int? Fracao;

  FracaoPorEntidadeModel({
    this.ID,
    this.IDEntidade,
    this.entidades,
    this.IDPropriedade,
    this.propriedades,
    this.Fracao,
  });


  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(ID != null){
      result.addAll({'ID': ID});
    }
    if(IDEntidade != null){
      result.addAll({'IDEntidade': IDEntidade});
    }
    if(entidades != null){
      result.addAll({'entidades': entidades!.toMap()});
    }
    if(IDPropriedade != null){
      result.addAll({'IDPropriedade': IDPropriedade});
    }
    if(propriedades != null){
      result.addAll({'propriedades': propriedades!.toMap()});
    }
    if(Fracao != null){
      result.addAll({'Fracao': Fracao});
    }
  
    return result;
  }

  factory FracaoPorEntidadeModel.fromMap(Map<String, dynamic> map) {
    return FracaoPorEntidadeModel(
      ID: map['ID']?.toInt(),
      IDEntidade: map['IDEntidade']?.toInt(),
      entidades: map['entidades'] != null ? EntidadesModel.fromMap(map['entidades']) : null,
      IDPropriedade: map['IDPropriedade']?.toInt(),
      propriedades: map['propriedades'] != null ? PropriedadesModel.fromMap(map['propriedades']) : null,
      Fracao: map['Fracao']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory FracaoPorEntidadeModel.fromJson(String source) => FracaoPorEntidadeModel.fromMap(json.decode(source));
}
