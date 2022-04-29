import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_api.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_model.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_page.dart';
import 'package:neo_application/pages/default_page.dart';
import 'package:neo_application/pages/home_page/home_page.dart';
import 'package:neo_application/pages/login_page/login_page.dart';
import 'package:neo_application/pages/provider/app_provider.dart';
import 'package:provider/provider.dart';

class ColaboradorEdit extends StatefulWidget {
  ColaboradorModel colaboradorModel;
  // var tipoAcao;
  // var indice;

  ColaboradorEdit({
    Key? key,
    required this.colaboradorModel,
    // this.tipoAcao,
    // this.indice
  }) : super(key: key);

  @override
  State<ColaboradorEdit> createState() => _ColaboradorEditState();
}

class _ColaboradorEditState extends State<ColaboradorEdit> {
  Size get size => MediaQuery.of(context).size;
  late ColaboradorModel oColaborador;
  late String _valueEntrada;

  final TextEditingController _controlleridAuditor = TextEditingController();
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerDataInicio = TextEditingController();
  final TextEditingController _controllerEspecialidade =
      TextEditingController();
  final TextEditingController _controllerqAuditor = TextEditingController();
  final TextEditingController _controllerqAuditorLider =
      TextEditingController();
  final TextEditingController _controllerqLiderExperiencia =
      TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  final TextEditingController _controllerConfSenha = TextEditingController();
  final TextEditingController _controllerChangePwd = TextEditingController();

  late AppModel appRepository;
  late ColaboradorModel oColaboradorModel;

  List<ColaboradorModel> listColaborador = [];

  bool checkBoxEnable = false;

  bool checkAuditor = false;
  bool checkAuditorLider = false;
  bool checkLiderExperiencia = false;
  bool checkSenha = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _setText();
    super.initState();

    _controllerSenha.addListener(() {
      final checkBoxEnable = _controllerSenha.text.isNotEmpty;
      setState(() => this.checkBoxEnable = checkBoxEnable);
      
    });
  }

  @override
  void dispose() {
    _controllerSenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    oColaboradorModel = widget.colaboradorModel;
    appRepository = Provider.of<AppModel>(context);
    return Scaffold(
      body: _body(),
      appBar: AppBar(
        title: Text("Editar usuário"),
        backgroundColor: Color.fromRGBO(78, 204, 196, 2),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
    );
  }

  _setText() {
    oColaborador = widget.colaboradorModel;
    _controlleridAuditor.text = oColaborador.idAuditor.toString();
    _controllerNome.text = oColaborador.Nome.toString();
    _controllerDataInicio.text = oColaborador.DataInicio.toString();
    _controllerEspecialidade.text = oColaborador.Especialidade.toString();
    _controllerEmail.text = oColaborador.Usuario.toString();
    // _controllerChangePwd.text = oColaborador.change_pwd.toString();
    // if (_controllerChangePwd.text == "X") {
    //   checkSenha = true;
    // } else {
    //   checkSenha = false;
    // }
    _controllerqAuditor.text = oColaborador.qAuditor.toString();
    if (_controllerqAuditor.text == "X") {
      checkAuditor = true;
    } else {
      checkAuditor = false;
    }
    _controllerqAuditorLider.text = oColaborador.qAuditorLider.toString();
    if (_controllerqAuditorLider.text == "X") {
      checkAuditorLider = true;
    } else {
      checkAuditorLider = false;
    }
    _controllerqLiderExperiencia.text =
        oColaborador.qLiderExperiencia.toString();
    if (_controllerqLiderExperiencia.text == "X") {
      checkLiderExperiencia = true;
    } else {
      checkLiderExperiencia = false;
    }
  }

  _body() {
    return FutureBuilder(
      future: ColaboradorApi().getListColaborador(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Erro ao carregar os dados"));
        }
        if (snapshot.hasData) {
          listColaborador = snapshot.data;
          if (listColaborador.isNotEmpty) {
            return ListView(
              children: [
                Card(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      padding: EdgeInsets.all(50),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 30,
                              height: 20,
                            ),
                            SizedBox(
                              width: 300,
                              height: 40,
                              child: TextFormField(
                                controller: _controllerNome,
                                decoration: const InputDecoration(
                                  labelText: "Nome",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                              height: 20,
                            ),
                            SizedBox(
                              width: 300,
                              height: 40,
                              child: TextFormField(
                                controller: _controllerEspecialidade,
                                decoration: const InputDecoration(
                                  labelText: "Especialidade",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                              height: 20,
                            ),
                            Container(
                              width: 300,
                              height: 40,
                              child: TextFormField(
                                controller: _controllerDataInicio,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Data de Início",
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.date_range,
                                      color: Color.fromARGB(96, 88, 87, 87),
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      final data = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (data != null)
                                        setState(() =>
                                            _valueEntrada = data.toString());

                                      _controllerDataInicio.text =
                                          _valueEntrada.substring(8, 10) +
                                              '/' +
                                              _valueEntrada.substring(5, 7) +
                                              '/' +
                                              _valueEntrada.substring(0, 4);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                              height: 20,
                            ),
                            SizedBox(
                              width: 300,
                              height: 60,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.length == 0) {
                                    return "E-mail curto demais";
                                  } else if (!value.contains("@")) {
                                    return "E-mail invalido";
                                  } else if (!value.contains(".")) {
                                    return "E-mail invalido";
                                  }
                                  return null;
                                },
                                controller: _controllerEmail,
                                decoration: const InputDecoration(
                                  labelText: "E-mail",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                              height: 5,
                            ),
                            SizedBox(
                              width: 300,
                              height: 60,
                              child: TextFormField(
                                obscureText: true,
                                controller: _controllerSenha,
                                decoration: const InputDecoration(
                                  labelText: "Senha",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                              height: 5,
                            ),
                            SizedBox(
                              width: 300,
                              height: 60,
                              child: TextFormField(
                                obscureText: true,
                                validator: (value) {
                                  if (value != _controllerSenha.text) {
                                    return "As senhas não são compatíveis";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Confirmação de Senha",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              ),
                            ),
                            SizedBox(
                                child: Row(
                              children: [
                                Checkbox(
                                    value: checkSenha,
                                    onChanged: checkBoxEnable
                                        ? (value) {
                                            setState(() {
                                              if (_controllerSenha.text != "") {
                                                checkBoxEnable = true;
                                              }
                                              checkSenha = value!;
                                            });
                                          }
                                        : null),
                                Text(
                                    "Solicitar alteração de senha no próximo logon?")
                              ],
                            )),
                            const SizedBox(
                              width: 30,
                              height: 2,
                            ),
                            SizedBox(
                                child: Row(
                              children: [
                                Checkbox(
                                  value: checkAuditor,
                                  onChanged: (value) {
                                    setState(() {
                                      checkAuditor = value!;
                                    });
                                  },
                                ),
                                Text("Auditor")
                              ],
                            )),
                            const SizedBox(
                              width: 30,
                              height: 2,
                            ),
                            SizedBox(
                                child: Row(
                              children: [
                                Checkbox(
                                  value: checkAuditorLider,
                                  onChanged: (value) {
                                    setState(() {
                                      checkAuditorLider = value!;
                                    });
                                  },
                                ),
                                Text("Auditor Líder")
                              ],
                            )),
                            const SizedBox(
                              width: 30,
                              height: 2,
                            ),
                            SizedBox(
                                child: Row(
                              children: [
                                Checkbox(
                                  value: checkLiderExperiencia,
                                  onChanged: (value) {
                                    setState(() {
                                      checkLiderExperiencia = value!;
                                    });
                                  },
                                ),
                                Text("Lider de Experiência")
                              ],
                            )),
                            const SizedBox(
                              width: 30,
                              height: 20,
                            ),
                            _Buttons()
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
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
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  _Buttons() {
    return Container(
      alignment: Alignment.bottomRight,
      child: ButtonBar(
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(246, 34, 37, 44)),
            onPressed: () => _onClickSalvar(),
            child: Text("Salvar Alterações"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(246, 34, 37, 44)),
            onPressed: () => {appRepository.setPage(ColaboradorPage())},
            child: Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  _onClickSalvar() async {
    if (_formKey.currentState!.validate()) {
      if (_controllerNome.text == "" ||
          _controllerEspecialidade.text == "" ||
          _controllerEmail.text == "") {
        _onClickDialog();
        return;
      }

      var senha = _controllerSenha.text;
      var novaSenha;
      var auditor;
      var auditorLider;
      var liderExperiencia;

      if (checkBoxEnable == false) {
        checkSenha = false;
      } 

      if (checkSenha == true) {
        novaSenha = "X";
      }

      if (checkAuditor == true) {
        auditor = "X";
      } else {
        auditor = "";
      }

      if (checkAuditorLider == true) {
        auditorLider = "X";
      } else {
        auditorLider = "";
      }

      if (checkLiderExperiencia == true) {
        liderExperiencia = "X";
      } else {
        liderExperiencia = "";
      }

      var DataInicio = _controllerDataInicio.text.substring(3, 5) +
          '/' +
          _controllerDataInicio.text.substring(0, 2) +
          '/' +
          _controllerDataInicio.text.substring(6, 10);

      ColaboradorApi colaboradorApi = ColaboradorApi();

      ColaboradorModel oColaborador = ColaboradorModel(
        idAuditor: widget.colaboradorModel.idAuditor,
        Nome: _controllerNome.text,
        DataInicio: DataInicio.toString(),
        Especialidade: _controllerEspecialidade.text,
        Usuario: _controllerEmail.text,
        qAuditor: auditor,
        qAuditorLider: auditorLider,
        qLiderExperiencia: liderExperiencia,
        Senha: senha,
        change_pwd: novaSenha,
      );

      var messageReturn = await colaboradorApi.updateColaborador(oColaborador, widget.colaboradorModel.idAuditor!);

      if (messageReturn["type"] == "S") {
        Fluttertoast.showToast(
            msg: messageReturn["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            fontSize: 16.0);

        AppModel app = Provider.of<AppModel>(context, listen: false);
        app.setPage(ColaboradorPage());
      } else if (messageReturn["type"] == "U") {
        Fluttertoast.showToast(
            msg: messageReturn["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            fontSize: 16.0);

        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()));
        });
      } else {
        Fluttertoast.showToast(
            msg: messageReturn["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            fontSize: 16.0);
      }
    } else {
      print("invalido");
    }
  }

  _onClickDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            height: 60,
            child: Center(
              child: ListTile(
                leading: Icon(
                  Icons.warning,
                  color: Colors.orange,
                  size: 30,
                ),
                title: Text(
                  'Preencha os campos obrigatórios.',
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  'Nome, Especialidade e E-mail.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => {Navigator.pop(context)},
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(75, 171, 143, 30)),
              child: Text("Ok"),
            )
          ],
        ),
      );
}
