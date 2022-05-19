import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neo_application/pages/clientes_grupos/entidades_gestoras/dropDownController_Entidades.dart';
import 'package:neo_application/pages/clientes_grupos/entidades_gestoras/entidades_model.dart';
import 'package:neo_application/pages/clientes_grupos/fracao_propriedades/Tabelas_model.dart';
import 'package:neo_application/pages/clientes_grupos/fracao_propriedades/fracao_api.dart';
import 'package:neo_application/pages/clientes_grupos/fracao_propriedades/fracao_model.dart';
import 'package:neo_application/pages/clientes_grupos/fracao_propriedades/fracao_page.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/dropDownController_Propriedades.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propriedades_model.dart';
import 'package:neo_application/pages/provider/app_provider.dart';
import 'package:provider/provider.dart';

class FracaoPropEdit extends StatefulWidget {
  FracaoPropModel fracaoPropModel;
  var tipoAcao;

  FracaoPropEdit({Key? key, required this.fracaoPropModel, this.tipoAcao})
      : super(key: key);

  @override
  State<FracaoPropEdit> createState() => _FracaoPropEditState();
}

class _FracaoPropEditState extends State<FracaoPropEdit> {
  Size get size => MediaQuery.of(context).size;
  late FracaoPropModel oFracaoProp;
  late String _value;

  DropDownControllerEntidades dropDownControllerEntidades =
      DropDownControllerEntidades();
  DropDownControllerPropriedades dropDownControllerPropriedades =
      DropDownControllerPropriedades();

  final TextEditingController _controllerID = TextEditingController();
  final TextEditingController _controllerIDEntidade = TextEditingController();
  final TextEditingController _controllerIDPropriedade =
      TextEditingController();
  final TextEditingController _controllerFracao = TextEditingController();

  late AppModel appRepository;
  late FracaoPropModel ofracaoPropModel;
  EntidadesModel valueSelected = EntidadesModel();

  EntidadesModel listEntidadesSelecionado = EntidadesModel();
  PropriedadesModel listPropriedadeSelecionado = PropriedadesModel();
  TodasTabelasModel todasTabelas = TodasTabelasModel();

  List<EntidadesModel> listEntidades = [];
  List<PropriedadesModel> listPropriedade = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _setText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ofracaoPropModel = widget.fracaoPropModel;
    appRepository = Provider.of<AppModel>(context);
    return Scaffold(
      body: _body(),
      appBar: AppBar(
        title: Text(widget.tipoAcao == "editar"
            ? "Editar Fração (${widget.fracaoPropModel.ID})"
            : "Criar Nova Fração"),
        backgroundColor: Color.fromRGBO(78, 204, 196, 2),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
    );
  }

  _setText() async {
    oFracaoProp = widget.fracaoPropModel;
    _controllerID.text = oFracaoProp.ID.toString();
    _controllerIDEntidade.text = oFracaoProp.IDEntidade.toString();
    _controllerIDPropriedade.text = oFracaoProp.IDPropriedade.toString();
    _controllerFracao.text = oFracaoProp.Fracao.toString();

    await dropDownControllerEntidades.buscarEntidades();
    var listEntidades = dropDownControllerEntidades.listEntidades;

    if (oFracaoProp.entidades != null) {
      var listEntidadeFiltrado = listEntidades
          .where((element) => element.Id == oFracaoProp.entidades!.Id)
          .toList();
      dropDownControllerEntidades
          .setSelecionadoEntidades(listEntidadeFiltrado[0]);
    }

    await dropDownControllerPropriedades.buscarPropriedades();
    var listPropriedades = dropDownControllerPropriedades.listPropriedades;

    if (oFracaoProp.propriedades != null) {
      var listPropriedadesFiltrado = listPropriedades
          .where((element) =>
              element.idPropriedade == oFracaoProp.propriedades!.idPropriedade)
          .toList();
      dropDownControllerPropriedades
          .setSelecionadoPropriedades(listPropriedadesFiltrado[0]);
    }
  }

  _body() {
    return FutureBuilder(
      future: TodasTabelas().getTodasTabelas(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Erro ao carregar os dados"));
        }
        if (snapshot.hasData) {
          todasTabelas = snapshot.data;
          listEntidades = todasTabelas.entidades!;
          listPropriedade = todasTabelas.propriedades!;
          List<EntidadesModel> listEntidadesValue = [];
          List<PropriedadesModel> listPropriedadeValue = [];
          return ListView(
            children: [
              Card(
                child: LayoutBuilder(builder: (context, constraints) {
                  return Container(
                    padding: EdgeInsets.all(50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 300,
                          height: 40,
                          child: AnimatedBuilder(
                            animation: dropDownControllerEntidades,
                            builder: (context, child) {
                              if (dropDownControllerEntidades
                                  .listEntidades.isEmpty) {
                                return Center(
                                    child: const CircularProgressIndicator());
                              } else {
                                return DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                  child: DropdownButtonFormField(
                                    style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                    decoration: InputDecoration(
                                      labelText: "Entidades",
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    hint: Text("Entidades"),
                                    isDense: true,
                                    isExpanded: true,
                                    value: dropDownControllerEntidades
                                        .selecionadoEntidades,
                                    onChanged: (value) =>
                                        dropDownControllerEntidades
                                            .setSelecionadoEntidades(value),
                                    items: dropDownControllerEntidades
                                        .listEntidades
                                        .map((tipos) => DropdownMenuItem(
                                              child: Text(tipos.Nome!),
                                              value: tipos,
                                            ))
                                        .toList(),
                                  ),
                                ));
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                          height: 20,
                        ),
                        Container(
                          width: 300,
                          height: 40,
                          child: AnimatedBuilder(
                            animation: dropDownControllerPropriedades,
                            builder: (context, child) {
                                return DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                  child: DropdownButtonFormField(
                                    style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                    decoration: InputDecoration(
                                      labelText: "Propriedades",
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    hint: Text("Propriedades"),
                                    isDense: true,
                                    isExpanded: true,
                                    value: dropDownControllerPropriedades
                                        .selecionadoPropriedades,
                                    onChanged: (value) =>
                                        dropDownControllerPropriedades
                                            .setSelecionadoPropriedades(value),
                                    items: dropDownControllerPropriedades
                                        .listPropriedades
                                        .map((tipos) => DropdownMenuItem(
                                              child: Text(tipos.Nome!),
                                              value: tipos,
                                            ))
                                        .toList(),
                                  ),
                                ));
                              
                            },
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
                            controller: _controllerFracao,
                            decoration: const InputDecoration(
                              labelText: "Fração da Propriedade",
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        _Buttons()
                      ],
                    ),
                  );
                }),
              ),
            ],
          );
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
            onPressed: () =>
                widget.tipoAcao == "editar" ? _onClickSalvar() : _onClickAdd(),
            child: widget.tipoAcao == "editar"
                ? Text("Salvar Alterações")
                : Text("Adicionar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(246, 34, 37, 44)),
            onPressed: () => {appRepository.setPage(FracaoPropPage())},
            child: Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  _onClickSalvar() async {
    if (_controllerFracao.text == 0 ||
        _controllerFracao.text == null ||
        _controllerFracao.text == "") {
      _onClickDialog();
      return;
    }
    FracaoPropApi fracaoPropApi = FracaoPropApi();

    int Fracao = int.parse(_controllerFracao.text);

    FracaoPropModel oFracaoProp = FracaoPropModel(
      ID: widget.fracaoPropModel.ID,
      IDEntidade: dropDownControllerEntidades.selecionadoEntidades!.Id,
      IDPropriedade:
          dropDownControllerPropriedades.selecionadoPropriedades!.idPropriedade,
      Fracao: Fracao,
    );

    var messageReturn = await fracaoPropApi.updateFracaoProp(oFracaoProp);

    if (messageReturn["type"] == "S") {
      Fluttertoast.showToast(
          msg: messageReturn["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      AppModel app = Provider.of<AppModel>(context, listen: false);
      app.setPage(FracaoPropPage());
    } else {
      Fluttertoast.showToast(
          msg: messageReturn["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
    }
  }

  _onClickAdd() async {
    if (_controllerFracao.text == "0" ||
        _controllerFracao.text == null ||
        _controllerFracao.text == "") {
      _onClickDialog();
      return;
    }
    FracaoPropApi fracaoPropApi = FracaoPropApi();

    int Fracao = int.parse(_controllerFracao.text);

    FracaoPropModel oFracaoProp = FracaoPropModel(
      ID: widget.fracaoPropModel.ID,
      IDEntidade: dropDownControllerEntidades.selecionadoEntidades!.Id,
      IDPropriedade:
          dropDownControllerPropriedades.selecionadoPropriedades!.idPropriedade,
      Fracao: Fracao,
    );

    var messageReturn = await fracaoPropApi.createFracaoProp(oFracaoProp);

    if (messageReturn["type"] == "S") {
      Fluttertoast.showToast(
          msg: messageReturn["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      AppModel app = Provider.of<AppModel>(context, listen: false);
      app.setPage(FracaoPropPage());
    } else {
      Fluttertoast.showToast(
          msg: messageReturn["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
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
                  'Entidades, Propriedades, Fração.',
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
