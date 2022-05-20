import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neo_application/pages/clientes_grupos/entidades_gestoras/fracao_entidade_model.dart';

class FracaoPorEntidadeApi {
  Future<List<FracaoPorEntidadeModel>> getFracao(int idEnti) async{

    try {
      var url = Uri.parse("https://neo-ii-back-end.azurewebsites.net/fracaoPropriedade/entidade/$idEnti");

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var responseMap = json.decode(response.body) as List;

        return responseMap.map((controle) => FracaoPorEntidadeModel.fromMap(controle)).toList();
      }

    } catch(e) {
      print(e);
    }
    throw "Erro ao carregar os dados";
  }
  
}

