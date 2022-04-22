import 'package:flutter/material.dart';
import 'package:neo_application/pages/home_page/home_page.dart';
import 'package:neo_application/pages/login_page/login_api.dart';
import 'package:neo_application/pages/utils/nav.dart';
import 'package:neo_application/pages/widgets/app_button.dart';
import 'package:neo_application/pages/widgets/app_text.dart';
import 'package:neo_application/pages/utils/globals.dart' as globals;


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _tLogin = TextEditingController();

  final _tSenha = TextEditingController();

  final _focusSenha = FocusNode();

  bool _showProgress = false;

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
            height: 310,
            width: 400,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(78, 204, 196, 2),

                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  height: 76,
                  child: const Center(
                    child: Text(
                      "Eco",
                      style: TextStyle(color: Colors.white,
                      fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
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

  Future<void> _onClickLogin() async {
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
            child: Center(
              child: Text("E-mail ou senha incorreto"),
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

}
