import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neo_application/pages/clientes_grupos/controle_escopo/controle_api.dart';
import 'package:neo_application/pages/clientes_grupos/controle_escopo/controle_edit.dart';
import 'package:neo_application/pages/clientes_grupos/controle_escopo/controle_model.dart';
import 'package:neo_application/pages/clientes_grupos/fracao_propriedades/Tabelas_model.dart';
import 'package:neo_application/pages/provider/app_provider.dart';
import 'package:provider/provider.dart';

class ControlePage extends StatefulWidget {
  const ControlePage({Key? key}) : super(key: key);

  @override
  State<ControlePage> createState() => _ControlePageState();
}

class _ControlePageState extends State<ControlePage> {
  Size get size => MediaQuery.of(context).size;

  List<ControleModel> listControle = [];
  List<TodasTabelasModel> listTabelas = [];

  ControleApi controleApi = ControleApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      appBar: AppBar(
        title: Text("Lista de Controle de Escopos"),
        backgroundColor: Color.fromRGBO(78, 204, 196, 2),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onNavAdd(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(78, 204, 196, 2),
      ),
    );
  }

  void _onNavAdd(BuildContext context) {
    AppModel app = Provider.of<AppModel>(context, listen: false);
    app.setPage(ControleEdit(
      controleModel: ControleModel(
        ID: 0,
      idFracao: 0,
      idEntidade: 0,
      idPropriedade: 0,
      idGrupo: 0,
      DataEntrada: "",
      DataSaida: "",
      RequerenteSaida: "",
      AreaEscopo: 0,
      AreaAuditada: 0,
      CicloTrabalho: 0,
         ),
      tipoAcao: "adicionar",
    ));
  }

  _body() {
    ControleApi().getListControle();
    return FutureBuilder(
      future: ControleApi().getListControle(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Erro ao carregar os dados"));
        }
        if (snapshot.hasData) {
          listControle = snapshot.data;
          return Container(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var grupo = listControle[index].grupos!.Nome != null ? listControle[index].grupos!.Nome.toString() : "";
                var entidades = listControle[index].entidades!.Nome != null ? listControle[index].entidades!.Nome.toString() : "";
                var propriedades;
                var fracao;
                if (entidades != "") {
                  propriedades = listControle[index].fracao!.propriedades!.Nome != null ? listControle[index].fracao!.propriedades!.Nome.toString() : "";
                  fracao = listControle[index].fracao!.Fracao != null ? listControle[index].fracao!.Fracao.toString() : "";
                } else {
                  propriedades = "";
                  fracao = "";
                }
                
                return Card(
                  child: ListTile(
                    title: Text("Grupos: " + grupo + " - " "Entidade: " + entidades + " - " "Propriedade: " + propriedades + " - " "Fração da Propriedade: " + fracao + " - " "Data Entrada: " + "${listControle[index].DataEntrada}" + " - " "Data Saída: " + "${listControle[index].DataSaida}" + " - " "Requerente Saída: " + "${listControle[index].RequerenteSaida}"
                        ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            AppModel app =
                                Provider.of<AppModel>(context, listen: false);
                            app.setPage(ControleEdit(
                              controleModel: listControle[index],
                              tipoAcao: "editar",
                            ));
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Color.fromARGB(246, 34, 37, 44),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await _dialogDelete(index, context);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Color.fromARGB(246, 34, 37, 44),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

   Future<void> _deleteControle(int index, BuildContext context) async {
    var resposta =
        await  controleApi.deleteControle(listControle[index].ID!);
    if (resposta["type"] == "S") {
      Fluttertoast.showToast(
          msg: resposta["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          fontSize: 16.0);
      Navigator.pop(context);
      setState(() {
         ControleApi().getListControle();
      });
    }
  }

  _dialogDelete(int index, BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            height: 50,
            child: Center(
              child: Text("Você deseja excluir este item?"),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => _deleteControle(index, context),
              child: Text("Sim"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(246, 34, 37, 44)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Não"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(246, 34, 37, 44)),
            ),
          ],
        ),
      );
}
