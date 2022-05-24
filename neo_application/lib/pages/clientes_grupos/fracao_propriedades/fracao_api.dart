import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:neo_application/pages/clientes_grupos/entidades_gestoras/entidades_model.dart';
import 'package:neo_application/pages/clientes_grupos/fracao_propriedades/Tabelas_model.dart';
import 'package:neo_application/pages/clientes_grupos/fracao_propriedades/fracao_model.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propriedades_model.dart';

class FracaoPropApi {
  List<FracaoPropModel> list = [];
  Future<List<FracaoPropModel>> getListFracaoProp() async {
    try {
      var url = Uri.parse(
          "https://neo-ii-back-end.azurewebsites.net/fracaoPropriedade");

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var responseMap = json.decode(response.body) as List;

        return responseMap
            .map((fracaoProp) => FracaoPropModel.fromMap(fracaoProp))
            .toList();
      }
    } catch (e) {
      print(e);
    }
    throw "Erro ao carregar os dados";
  }

  Future updateFracaoProp(FracaoPropModel oFracaoProp) async {
    try {
      var url = Uri.parse(
          "https://neo-ii-back-end.azurewebsites.net/fracaoPropriedade/update");

      var body = {
        "ID": oFracaoProp.ID,
        "IDEntidade": oFracaoProp.IDEntidade,
        "IDPropriedade": oFracaoProp.IDPropriedade,
        "Fracao": oFracaoProp.Fracao,
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

  Future createFracaoProp(FracaoPropModel oFracaoProp) async {
    try {
      var url = Uri.parse(
          "https://neo-ii-back-end.azurewebsites.net/fracaoPropriedade/create");

      var body = {
        "IDEntidade": oFracaoProp.IDEntidade,
        "IDPropriedade": oFracaoProp.IDPropriedade,
        "Fracao": oFracaoProp.Fracao,
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

  Future deleteFracaoProp(int idProp) async {
    try {
      var url = Uri.parse(
          "https://neo-ii-back-end.azurewebsites.net/fracaoPropriedade/delete/$idProp");

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
  List<EntidadesModel> list = [];
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