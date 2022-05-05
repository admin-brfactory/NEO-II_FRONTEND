import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_api.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_edit.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_logado_edit.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_model.dart';
import 'package:neo_application/pages/login_page/login_page.dart';
import 'package:neo_application/pages/provider/app_provider.dart';
import 'package:neo_application/pages/utils/nav.dart';
import 'package:neo_application/web/expandable_list/sub_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:neo_application/pages/utils/globals.dart' as globals;

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<ColaboradorModel> listColaborador = [];
  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  _body(BuildContext context) {
    setState(() {
      ColaboradorApi().getColaborador();
    });

    return Container(
      color: Color.fromARGB(246, 34, 37, 44),
      child: FutureBuilder(
        future: ColaboradorApi().getColaborador(),
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
                      return Container(
                        color: Color.fromARGB(246, 34, 37, 44),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              ListTile(
                                title: Text(
                                  "Usuário",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  AppModel app = Provider.of<AppModel>(context,
                                      listen: false);
                                  app.setPage(ColaboradorLogadoEdit(
                                    colaboradorModel: listColaborador[index],
                                    tipoAcao: "editar",
                                  ));
                                },
                                leading: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SubListTile(),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 15, bottom: 20),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      push(context, LoginPage());
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.logout,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                          SizedBox(
                                            width: 27,
                                          ),
                                          Text(
                                            "Logout",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
