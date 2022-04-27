import 'dart:convert';

class ColaboradorModel {
  
  int? idAuditor;
  String? Nome;
  String? DataInicio;
  String? Especialidade;
  String? qAuditor;
  String? qAuditorLider;
  String? qLiderExperiencia;
  String? Usuario;
  String? change_pwd;
  String? Senha;
  

  ColaboradorModel({
    this.idAuditor,
    this.Nome,
    this.DataInicio,
    this.Especialidade,
    this.qAuditor,
    this.qAuditorLider,
    this.qLiderExperiencia,
    this.Usuario, 
    this.change_pwd,
    this.Senha,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(idAuditor != null){
      result.addAll({'idAuditor': idAuditor});
    }
    if(Nome != null){
      result.addAll({'Nome': Nome});
    }
    if(DataInicio != null){
      result.addAll({'DataInicio': DataInicio});
    }
    if(Especialidade != null){
      result.addAll({'Especialidade': Especialidade});
    }
    if(qAuditor != null){
      result.addAll({'qAuditor': qAuditor});
    }
    if(qAuditorLider != null){
      result.addAll({'qAuditorLider': qAuditorLider});
    }
    if(qLiderExperiencia != null){
      result.addAll({'qLiderExperiencia': qLiderExperiencia});
    }
    if(Usuario != null){
      result.addAll({'Usuario': Usuario});
    }
    if(change_pwd != null){
      result.addAll({'change_pwd': change_pwd});
    }
    if(Senha != null){
      result.addAll({'Senha': Senha});
    }
  
    return result;
  }

  factory ColaboradorModel.fromMap(Map<String, dynamic> map) {
    return ColaboradorModel(
      idAuditor: map['idAuditor']?.toInt(),
      Nome: map['Nome'],
      DataInicio: map['DataInicio'],
      Especialidade: map['Especialidade'],
      qAuditor: map['qAuditor'],
      qAuditorLider: map['qAuditorLider'],
      qLiderExperiencia: map['qLiderExperiencia'],
      Usuario: map['Usuario'],
      change_pwd: map['change_pwd'],
      Senha: map['Senha'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ColaboradorModel.fromJson(String source) => ColaboradorModel.fromMap(json.decode(source));
}
