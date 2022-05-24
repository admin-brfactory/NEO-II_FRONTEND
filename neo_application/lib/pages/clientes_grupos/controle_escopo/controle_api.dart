import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:neo_application/pages/clientes_grupos/controle_escopo/controle_model.dart';
import 'package:neo_application/pages/clientes_grupos/fracao_propriedades/Tabelas_model.dart';

class ControleApi {
  List<ControleModel> list = [];
  Future<List<ControleModel>> getListControle() async {
    try {
      var url = Uri.parse(
          "https://neo-ii-back-end.azurewebsites.net/controleEscopos"); 

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var responseMap = json.decode(response.body) as List;

        return responseMap
            .map((controle) => ControleModel.fromMap(controle))
            .toList();
      }
    } catch (e) {
      print(e);
    }
    throw "Erro ao carregar os dados";
  }

  Future updateControle(ControleModel oControle) async {
    try {
      var url = Uri.parse(
          "https://neo-ii-back-end.azurewebsites.net/controleEscopos/update");

      var body = {
      'ID': oControle.ID,
      'idFracao': oControle.idFracao,
      'idEntidade': oControle.idEntidade,
      'idGrupo': oControle.idGrupo,
      'idPropriedade': oControle.idPropriedade,
      'DataEntrada': oControle.DataEntrada,
      'DataSaida': oControle.DataSaida,
      'RequerenteSaida': oControle.RequerenteSaida,
      'AreaEscopo': oControle.AreaEscopo,
      'AreaAuditada': oControle.AreaAuditada,
      'CicloTrabalho': oControle.CicloTrabalho,
      };

      var response = await http.put(url,
          headers: <String, String>{"Content-type": "application/json"},
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        Map<String, dynamic> map = {
          "type": res["type"],
          "message": res["message"]
        };
        return map;
      }
    } catch (e) {
      print(e);
    }
    return "";
  }

  Future createControle(ControleModel oControle) async {
    try {
      var url = Uri.parse(
          "https://neo-ii-back-end.azurewebsites.net/controleEscopos/create");

      var body = {
      'idFracao': oControle.idFracao,
      'idEntidade': oControle.idEntidade,
      'idPropriedade': oControle.idPropriedade,
      'idGrupo': oControle.idGrupo,
      'DataEntrada': oControle.DataEntrada,
      'DataSaida': oControle.DataSaida,
      'RequerenteSaida': oControle.RequerenteSaida,
      'AreaEscopo': oControle.AreaEscopo,
      'AreaAuditada': oControle.AreaAuditada,
      'CicloTrabalho': oControle.CicloTrabalho,
      };

      var response = await http.post(url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        Map<String, dynamic> map = {
          "type": res["type"],
          "message": res["message"]
        };
        return map;
      }
    } catch (e) {
      print(e);
    }
    return "";
  }

  Future deleteControle(int idProp) async {
    try {
      var url = Uri.parse(
          "https://neo-ii-back-end.azurewebsites.net/controleEscopos/delete/$idProp");

      var response = await http.delete(url);
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        Map<String, dynamic> map = {
          "type": res["type"],
          "message": res["message"]
        };
        return map;
      }
    } catch (e) {
      print(e);
    }
    return "";
  }
}

class TodasTabelas {
  List<TodasTabelasModel> list = [];
  Future<TodasTabelasModel> getTodasTabelas() async {
    try {
      var url = Uri.parse(
          "https://neo-ii-back-end.azurewebsites.net/buscaTodasTabelas");

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var responseMap = json.decode(response.body);
        var todasTabelas = TodasTabelasModel.fromMap(responseMap);
        return todasTabelas;
      }
    } catch (e) {
      print(e);
    }
    throw "Erro ao carregar os dados";
  }
}