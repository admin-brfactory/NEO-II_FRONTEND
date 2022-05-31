import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neo_application/pages/clientes_grupos/adm_grupos/grupos_api.dart';
import 'package:neo_application/pages/clientes_grupos/adm_grupos/grupos_edit.dart';
import 'package:neo_application/pages/clientes_grupos/adm_grupos/grupos_model.dart';
import 'package:neo_application/pages/provider/app_provider.dart';
import 'package:provider/provider.dart';

class GruposPage extends StatefulWidget {
  const GruposPage({Key? key}) : super(key: key);

  @override
  State<GruposPage> createState() => _GruposPageState();
}

class _GruposPageState extends State<GruposPage> {
  Size get size => MediaQuery.of(context).size;

  List<GruposModel> listGrupos = [];

  GruposApi gruposApi = GruposApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      appBar: AppBar(
        title: Text("Lista de Grupos"),
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
    app.setPage(GruposEdit(
      grupoModel: GruposModel(
        idGrupo: 0,
        Nome: "",
        DataFormacao: "",
        IDGestor: 0,
         ),
      tipoAcao: "adicionar",
    ));
  }

  _body() {
    return FutureBuilder(
      future: GruposApi().getListGrupos(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Erro ao carregar os dados"));
        }
        if (snapshot.hasData) {
          listGrupos = snapshot.data;
          return Container(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Nome: ' + listGrupos[index].Nome! + ' - Data da Formação: ' + listGrupos[index].DataFormacao!
                        ),
                        
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            AppModel app =
                                Provider.of<AppModel>(context, listen: false);
                            app.setPage(GruposEdit(
                              grupoModel: listGrupos[index],
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

   Future<void> _deleteGrupo(int index, BuildContext context) async {
    var resposta =
        await  gruposApi.deleteGrupo(listGrupos[index].idGrupo!);
    if (resposta["type"] == "S") {
      Fluttertoast.showToast(
          msg: resposta["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      Navigator.pop(context);
      setState(() {
         GruposApi().getListGrupos();
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
              onPressed: () => _deleteGrupo(index, context),
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
