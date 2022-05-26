import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_api.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_createPage.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_edit.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_model.dart';
import 'package:neo_application/pages/clientes_grupos/fracao_propriedades/Tabelas_model.dart';
import 'package:neo_application/pages/login_page/login_page.dart';
import 'package:neo_application/pages/provider/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:neo_application/pages/utils/globals.dart' as globals;

class ColaboradorPage extends StatefulWidget {
  String? token;
  var indice;

  ColaboradorPage({Key? key, this.token, this.indice}) : super(key: key);

  @override
  State<ColaboradorPage> createState() => _ColaboradorPageState();
}

class _ColaboradorPageState extends State<ColaboradorPage> {
  Size get size => MediaQuery.of(context).size;

  List<ColaboradorModel> listColaborador = [];
  List<TodasTabelasModel> listTabelas = [];

  ColaboradorApi colaboradorApi = ColaboradorApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      appBar: AppBar(
        title: Text("Usuário"),
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
    app.setPage(ColaboradorCreate(
      colaboradorModel: ColaboradorModel(
        idAuditor: 0,
        Nome: "",
        DataInicio: "",
        Especialidade: "",
        qAuditor: "",
        qAuditorLider: "",
        qLiderExperiencia: "",
        Usuario: "",
      ),
      tipoAcao: "adicionar",
    ));
  }

  _body() {
    return FutureBuilder(
      future: ColaboradorApi().getListColaborador(),
      builder: (context, AsyncSnapshot snapshot) {
        if (globals.isValid == false) {
          Fluttertoast.showToast(
              msg: "Usuario não autorizado",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 10,
              fontSize: 16.0);
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()));
          });
        }
        if (snapshot.hasError) {
          return Center(child: Text("Erro ao carregar os dados"));
        }
        if (snapshot.hasData) {
          listColaborador = snapshot.data;
          return Container(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text("Nome: " +
                        "${listColaborador[index].Nome}" +
                        " - " "E-mail: " +
                        "${listColaborador[index].Usuario}" +
                        " - " "Especialidade: " +
                        "${listColaborador[index].Especialidade}" +
                        " - " "Data de Início: " +
                        "${listColaborador[index].DataInicio}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        IconButton(
                              onPressed: () {
                                AppModel app = Provider.of<AppModel>(context,
                                    listen: false);
                                app.setPage(ColaboradorEdit(
                                  colaboradorModel: listColaborador[index],
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

 Future<void> _deleteColaborador(int index, BuildContext context) async {
    var resposta =
        await colaboradorApi.deleteColaborador(listColaborador[index].idAuditor!);
    if (resposta["type"] == "S") {
      Fluttertoast.showToast(
          msg: resposta["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 10,
          fontSize: 16.0);
      Navigator.pop(context);
      setState(() {
        ColaboradorApi().getListColaborador();
      });
    }
  }

  _dialogDelete(int index, BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            height: 60,
            child: Center(
              child: Text("Você deseja excluir este item?"),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => _deleteColaborador(index, context),
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
