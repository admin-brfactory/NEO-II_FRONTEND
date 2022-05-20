import 'package:flutter/cupertino.dart';
import 'package:neo_application/pages/clientes_grupos/entidades_gestoras/fracao_entidade_api.dart';
import 'package:neo_application/pages/clientes_grupos/entidades_gestoras/fracao_entidade_model.dart';
import 'package:neo_application/pages/clientes_grupos/fracao_propriedades/fracao_api.dart';
import 'package:neo_application/pages/clientes_grupos/fracao_propriedades/fracao_model.dart';

class DropDownControllerFracao extends ChangeNotifier {
  
  List<FracaoPorEntidadeModel> listFracao = [];
  FracaoPorEntidadeModel? selecionadoFracao;

  Future buscarFracao(int idEnti) async {
    listFracao = await FracaoPorEntidadeApi().getFracao(idEnti);

    notifyListeners();
  }

  void setSelecionadoFracao(selTipo){
    selecionadoFracao = selTipo;
    notifyListeners();
  }


}