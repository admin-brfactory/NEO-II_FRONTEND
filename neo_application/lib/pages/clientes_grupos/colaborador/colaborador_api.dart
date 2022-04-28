import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_model.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_page.dart';
import 'package:neo_application/pages/clientes_grupos/controle_escopo/controle_model.dart';
import 'package:neo_application/pages/clientes_grupos/fracao_propriedades/Tabelas_model.dart';
import 'package:neo_application/pages/login_page/login_page.dart';
import 'package:neo_application/pages/login_page/user_token.dart';
import 'package:neo_application/pages/utils/globals.dart' as globals;

class ColaboradorApi {
  List<ColaboradorModel> list = [];
  
  Future<List<ColaboradorModel>> getColaborador() async {
    var token = await UserToken().getToken();

    try {
      var url = Uri.parse(
          "https://neo-ii-back-end.azurewebsites.net/user"); 

      Map<String, String> headers = {
        "Authorization": "JWT $token",
      };

      var response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        var responseMap = json.decode(response.body) as List;

        return responseMap
            .map((colaborador) => ColaboradorModel.fromMap(colaborador))
            .toList();
      } else if (response.statusCode == 401){
        globals.isValid = false;
        return[];
      }
    } catch (e) {
      print(e);
    }
    throw "Erro ao carregar os dados";
  }

  Future<List<ColaboradorModel>> getListColaborador() async {
    var token = await UserToken().getToken();

    try {
      var url = Uri.parse(
          "https://neo-ii-back-end.azurewebsites.net/users"); 

      Map<String, String> headers = {
        "Authorization": "JWT $token",
      };

      var response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        var responseMap = json.decode(response.body) as List;

        return responseMap
            .map((colaborador) => ColaboradorModel.fromMap(colaborador))
            .toList();
      } else if (response.statusCode == 401){
        globals.isValid = false;
        return[];
      }
    } catch (e) {
      print(e);
    }
    throw "Erro ao carregar os dados";
  }

  Future updateColaborador(ColaboradorModel oColaborador, int update) async {
    var token = await UserToken().getToken();

    try {
      var url = Uri.parse(
          "https://neo-ii-back-end.azurewebsites.net/user/update/$update");

      var body = {
      "idAuditor": oColaborador.idAuditor,
      "Nome": oColaborador.Nome,
      "DataInicio": oColaborador.DataInicio,
      "Especialidade": oColaborador.Especialidade,
      "qAuditor": oColaborador.qAuditor,
      "qAuditorLider": oColaborador.qAuditorLider,
      "qLiderExperiencia": oColaborador.qLiderExperiencia,
      "Usuario": oColaborador.Usuario,
      "change_pwd": oColaborador.change_pwd,
      "Senha": oColaborador.Senha,
      };

      var response = await http.put(url,
          headers: <String, String>{
             "Authorization": "JWT $token",
            "Content-type": "application/json",
          },
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        Map<String, dynamic> map = {
          "type": res["type"],
          "message": res["message"]
        };
        return map;
      }
      else if (response.statusCode == 401) {
        Map<String, dynamic> map = {
          "type": "U",
          "message": "Sessão expirada",
        };
        return map;
      }
    } catch (e) {
      print(e);
    }
    return "";
  }

  Future createColaborador(ColaboradorModel oColaborador) async {
    var token = await UserToken().getToken();

    try {
      var url = Uri.parse(
          "https://neo-ii-back-end.azurewebsites.net/signup");

      var body = {
      "Nome": oColaborador.Nome,
      "DataInicio": oColaborador.DataInicio,
      "Especialidade": oColaborador.Especialidade,
      "qAuditor": oColaborador.qAuditor,
      "qAuditorLider": oColaborador.qAuditorLider,
      "qLiderExperiencia": oColaborador.qLiderExperiencia,
      "Usuario": oColaborador.Usuario,
      "change_pwd": oColaborador.change_pwd,
      "Senha": oColaborador.Senha,
      };

       var response = await http.post(url,
          headers: <String, String>{
             "Authorization": "JWT $token",
            "Content-type": "application/json",
          },
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        Map<String, dynamic> map = {
          "type": res["type"],
          "message": res["message"]
        };
        return map;
      }
      else if (response.statusCode == 401) {
        Map<String, dynamic> map = {
          "type": "U",
          "message": "Sessão expirada",
        };
        return map;
      }
    } catch (e) {
      print(e);
    }
    return "";
  }

  Future deleteColaborador(int delete) async {
    var token = await UserToken().getToken();

    try {
      var url = Uri.parse(
          "https://neo-ii-back-end.azurewebsites.net/user/delete/$delete");

      // var response = await http.delete(url);
      
      var response = await http.delete(url,
          headers: <String, String>{
             "Authorization": "JWT $token",
            "Content-type": "application/json",
          });
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        Map<String, dynamic> map = {
          "type": res["type"],
          "message": res["message"]
        };
        return map;
      }
      else if (response.statusCode == 401) {
        Map<String, dynamic> map = {
          "type": "U",
          "message": "Sessão expirada",
        };
        return map;
      }
    } catch (e) {
      print(e);
    }
    return "";
  }
}