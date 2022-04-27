import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_api.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_model.dart';
import 'package:neo_application/pages/login_page/login_page.dart';

class DefaultPage extends StatefulWidget {
  const DefaultPage({Key? key}) : super(key: key);

  @override
  State<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  Size get size => MediaQuery.of(context).size;

  List<ColaboradorModel> listColaborador = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  // _body() {
  //   return Center(child: Text("DEFAULT PAGE"));
  // }

  _body() {
    return FutureBuilder(
      future: ColaboradorApi().getColaborador(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Erro ao carregar os dados"));
        }
        if (snapshot.hasData) {
          listColaborador = snapshot.data;
          if (listColaborador.isNotEmpty) {
             return Center(child: Text("DEFAULT PAGE"));
          } else {
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
        }
        return Center();
      },
    );
  }
}
