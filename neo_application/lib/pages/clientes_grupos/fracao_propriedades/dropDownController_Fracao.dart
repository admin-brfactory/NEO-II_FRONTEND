import 'package:flutter/material.dart';
import 'package:neo_application/pages/clientes_grupos/entidades_gestoras/fracao_entidade_api.dart';
import 'package:neo_application/pages/clientes_grupos/entidades_gestoras/fracao_entidade_model.dart';

class DropDownControllerFracao extends ChangeNotifier {
  bool? isLoading = false;
  List<FracaoPorEntidadeModel> listFracao = [];
  FracaoPorEntidadeModel? selecionadoFracao;

  Future buscarFracao(int idEnti) async {
    setLoading(true);
    if (selecionadoFracao != null) {
      selecionadoFracao = null;
    }
    listFracao = await FracaoPorEntidadeApi().getFracao(idEnti);
    setLoading(false);

    notifyListeners();
  }

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setSelecionadoFracao(selTipo) {
    selecionadoFracao = selTipo;

    notifyListeners();
  }
}
