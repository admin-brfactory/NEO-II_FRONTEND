import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../clientes_grupos/fracao_propriedades/dropDownController_Fracao.dart';

class DropdownEditFracao extends StatelessWidget {
  final DropDownControllerFracao dropDownControllerFracao;
  const DropdownEditFracao({
    Key? key,
    required this.dropDownControllerFracao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 40,
      child: AnimatedBuilder(
        animation: dropDownControllerFracao,
        builder: ((context, child) {
          if (dropDownControllerFracao.isLoading!) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return DropdownButtonHideUnderline(
            child: ButtonTheme(
              child: DropdownButtonFormField(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                decoration: const InputDecoration(
                  labelText: "Fração",
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                hint: Text("Fração"),
                isDense: true,
                isExpanded: true,
                value: dropDownControllerFracao.selecionadoFracao,
                onChanged: (fracao) =>
                    dropDownControllerFracao.setSelecionadoFracao(fracao),
                items: dropDownControllerFracao.listFracao.map((tipos) => DropdownMenuItem(
                          child: Text(tipos.propriedades!.Nome.toString() + " - " + tipos.Fracao.toString()),
                          value: tipos,
                        ))
                    .toList(),
              ),
            ),
          );
        }),
      ),
    );
  }
}
