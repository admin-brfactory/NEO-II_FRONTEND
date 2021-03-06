import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_api.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_model.dart';
import 'package:neo_application/pages/clientes_grupos/colaborador/colaborador_page.dart';
import 'package:neo_application/pages/home_page/home_page.dart';
import 'package:neo_application/pages/login_page/login_api.dart';
import 'package:neo_application/pages/login_page/user_token.dart';
import 'package:neo_application/pages/provider/app_provider.dart';
import 'package:neo_application/pages/utils/nav.dart';
import 'package:neo_application/pages/widgets/app_button.dart';
import 'package:neo_application/pages/widgets/app_text.dart';
import 'package:neo_application/pages/utils/globals.dart' as globals;
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _tLogin = TextEditingController();

  final _tSenha = TextEditingController();

  final _tChangePwd = TextEditingController();

  final _focusSenha = FocusNode();

  final _controllerBtnLogin = TextEditingController();

  late ColaboradorModel oColaborador;

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

  bool _showProgress = false;

  late AppModel appRepository;

  final _formKeyDialog = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    globals.isValid = true;
    return Form(
      key: _formKey,
      child: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/login_bg_agro.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Container(
            height: 340,
            width: 400,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Center(
                    child: Container(
                      height: 100,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/logoEco.jpeg"),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ),
                AppText(
                  "E-mail",
                  Icon(Icons.person),
                  "Digite seu e-mail",
                  controller: _tLogin,
                  validator: _validateLogin,
                  textInputAction: TextInputAction.next,
                  nextFocus: _focusSenha,
                ),
                const SizedBox(
                  height: 10,
                ),
                AppText(
                  "Senha",
                  Icon(Icons.lock),
                  "Digite sua senha",
                  password: true,
                  controller: _tSenha,
                  validator: _validateSenha,
                  keyboardType: TextInputType.number,
                  focusNode: _focusSenha,
                  onFieldSubmitted:(value) {
                _onClickLogin();
              },
                ),
                const SizedBox(
                  height: 10,
                ),
                AppButton(
                  "Acessar",
                  onPressed: _onClickLogin,
                  showProgress: _showProgress,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Timer scheduleTimeout() => Timer(Duration(minutes: 9), handleTimeout);

  handleTimeout() async {
    UserToken userToken = UserToken();
      var token = await UserToken().getToken();
      try {
        var url =
            Uri.parse("https://neo-ii-back-end.azurewebsites.net/newToken");

        Map<String, String> headers = {
          "Authorization": "Bearer $token",
        };

        var response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          var map = jsonDecode(response.body);

          userToken = UserToken.fromMap(map);

          await userToken.saveToken(userToken.access_token!);
          scheduleTimeout();
          return userToken;
        }
        if (response.statusCode == 401) {
          return userToken;
        }
      } catch (e) {
        print(e);
      }
    
  }

   _onClickLogin() async {
    bool formOk = _formKey.currentState!.validate();
    if (!formOk) {
      return;
    }

    LoginModel loginModel = LoginModel();
    String username = _tLogin.text;
    String password = _tSenha.text;

    setState(() {
      _showProgress = true;
    });
    var response = await loginModel.login(username, password);

    if (response.access_token != null) {
      var response = await ColaboradorApi().getColaborador();

      if (response[0].change_pwd == "X") {
        _onDialogNovaSenha(response[0]);
        return;
      }

      scheduleTimeout();

      push(context, HomePage());
      setState(() {
        _showProgress = false;
      });
    } else {
      _onClickDialog();
      setState(() {
        _showProgress = false;
      });
    }
  }

  _onDialogNovaSenha(ColaboradorModel colaborador) => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Container(
          child: AlertDialog(
            elevation: 24,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: Container(
              width: 400,
              height: 250,
              child: Form(
                key: _formKeyDialog,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        "Altera????o de senha inicial",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 60,
                      child: TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value!.length == 0) {
                            return "Senha obrigat??ria";
                          }
                          return null;
                        },
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
                          if (value!.length == 0) {
                            return "Confirma????o de senha obrigat??ria";
                          }
                          if (value != _controllerSenha.text) {
                            return "As senhas n??o s??o compat??veis";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "Confirma????o de senha",
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(78, 204, 196, 2)),
                onPressed: () async {
                  var messageReturn =
                      await _onClickSalvarNovaSenha(colaborador);

                  if (messageReturn["type"] == "S") {
                    Fluttertoast.showToast(
                        msg: messageReturn["message"],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 10,
                        fontSize: 16.0);
                    Navigator.pop(context);
                    setState(() {
                      _showProgress = false;
                      _tSenha.text = "";
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: messageReturn["message"],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 10,
                        fontSize: 16.0);
                  }
                },
                child: Text("Salvar Altera????es"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(78, 204, 196, 2)),
                onPressed: () => {
                  Navigator.pop(context),
                  setState(() {
                    _showProgress = false;
                    _tSenha.text = "";
                    _controllerSenha.text = "";
                  }),
                },
                child: Text("Cancelar"),
              ),
            ],
          ),
        ),
      );

  String? _validateLogin(String? text) {
    if (text!.isEmpty) {
      return "Digite o e-mail";
    }
  }

  String? _validateSenha(String? text) {
    if (text!.isEmpty) {
      return "Digite a senha";
    }
  }

  _onClickDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            height: 60,
            child: ListTile(
              leading: Icon(
                Icons.warning,
                color: Colors.orange,
                size: 30,
              ),
              title: Text(
                'E-mail ou senha incorreto.',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => {Navigator.pop(context)},
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(78, 204, 196, 2)),
              child: Text("Ok"),
            )
          ],
        ),
      );

  _onClickSalvarNovaSenha(ColaboradorModel colaborador) async {
    if (_formKeyDialog.currentState!.validate()) {

      var senha = _controllerSenha.text;

      var data = colaborador.DataInicio;

      var DataInicio = data!.substring(3, 5) +
          '/' +
          data.substring(0, 2) +
          '/' +
          data.substring(6, 10);

      ColaboradorApi colaboradorApi = ColaboradorApi();

      ColaboradorModel oColaborador = ColaboradorModel(
        idAuditor: colaborador.idAuditor,
        Nome: colaborador.Nome,
        DataInicio: DataInicio,
        Especialidade: colaborador.Especialidade,
        Usuario: colaborador.Usuario,
        qAuditor: colaborador.qAuditor,
        qAuditorLider: colaborador.qAuditorLider,
        qLiderExperiencia: colaborador.qLiderExperiencia,
        Senha: senha,
        change_pwd: null,
      );

      var messageReturn = await colaboradorApi.updateColaborador(
          oColaborador, colaborador.idAuditor!);

      return messageReturn;
    } else {
      print("invalido");
    }
  }
}
