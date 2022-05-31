import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:javascript/javascript.dart';
import 'package:neo_application/pages/clientes_grupos/adm_grupos/grupos_api.dart';
import 'package:neo_application/pages/clientes_grupos/adm_grupos/grupos_model.dart';
import 'package:neo_application/pages/clientes_grupos/adm_grupos/grupos_page.dart';
import 'package:neo_application/pages/clientes_grupos/entidades_gestoras/dropDownController_Entidades.dart';
import 'package:neo_application/pages/clientes_grupos/entidades_gestoras/entidades_model.dart';
import 'package:neo_application/pages/provider/app_provider.dart';
import 'package:provider/provider.dart';

class GruposEdit extends StatefulWidget {
  GruposModel grupoModel;
  var tipoAcao;

  GruposEdit({Key? key, required this.grupoModel, this.tipoAcao})
      : super(key: key);

  @override
  State<GruposEdit> createState() => _GruposEditState();
}

class _GruposEditState extends State<GruposEdit> {
  Size get size => MediaQuery.of(context).size;
  late GruposModel oGrupo;
  late String _value;

  DropDownControllerEntidades dropDownControllerEntidades = DropDownControllerEntidades();


  final TextEditingController _controllerIdGrupo = TextEditingController();
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerDataFormacao = TextEditingController();
  final TextEditingController _controllerIDGestor = TextEditingController();

  late AppModel appRepository;
  late GruposModel oGrupoModel;
  EntidadesModel valueSelected = EntidadesModel();

  EntidadesModel  listEntidadesSelecionado = EntidadesModel();

  List<EntidadesModel> listEntidades = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _setText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    oGrupoModel = widget.grupoModel;
    appRepository = Provider.of<AppModel>(context);
    return Scaffold(
      body: _body(),
      appBar: AppBar(
        title: Text(widget.tipoAcao == "editar"
            ? "Editar Grupos (${widget.grupoModel.idGrupo})"
            : "Criar Novo Grupos"),
        backgroundColor: Color.fromRGBO(78, 204, 196, 2),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
    );
  }

  _setText() async {
    oGrupo = widget.grupoModel;
    _controllerIdGrupo.text = oGrupo.idGrupo.toString();
    _controllerNome.text = oGrupo.Nome ?? "";
    _controllerDataFormacao.text = oGrupo.DataFormacao.toString();
    _controllerIDGestor.text = oGrupo.IDGestor.toString();
    
    await dropDownControllerEntidades.buscarEntidades();
    var listEntidades = dropDownControllerEntidades.listEntidades;

    if(oGrupo.gestor != null) {
     var listEntidadeFiltrado = listEntidades.where((element) => element.Id == oGrupo.gestor!.Id).toList();
      dropDownControllerEntidades.setSelecionadoEntidades(listEntidadeFiltrado[0]);
     }
  }

  _body() {
    return FutureBuilder(
      future: EntidadesApi().getListEntidades(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Erro ao carregar os dados"));
        }
        if (snapshot.hasData) {
          listEntidades = snapshot.data;
          return ListView(
            children: [
              Card(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                  return Container(
                    padding: EdgeInsets.all(50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 300,
                          height: 40,
                          child: TextFormField(
                            controller: _controllerNome,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "Nome",
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
                            controller: _controllerDataFormacao,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "Data da Formação",
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
                                    setState(() => _value = data.toString());

                                  _controllerDataFormacao.text =  _value.substring(8, 10) + '/' + _value.substring(5, 7) +  '/' + _value.substring(0, 4);
                            
                                },
                              ),
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
                          child: AnimatedBuilder(
                            animation: dropDownControllerEntidades,
                            builder: (context, child) {
                              if (dropDownControllerEntidades.listEntidades.isEmpty) {
                                return Center(child: const CircularProgressIndicator());
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
                                    value: dropDownControllerEntidades.selecionadoEntidades,
                                    onChanged: (value) => dropDownControllerEntidades.setSelecionadoEntidades(value),
                                    items: dropDownControllerEntidades.listEntidades.map((tipos) => DropdownMenuItem(
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
            onPressed: () => {appRepository.setPage(GruposPage())},
            child: Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  _onClickSalvar() async {
    if (_controllerNome.text == "" || _controllerDataFormacao.text == "") {
      _onClickDialog();
      return;
    }
    GruposApi gruposApi = GruposApi();

    var dataForm =_controllerDataFormacao.text.substring(3, 5) + '/' + _controllerDataFormacao.text.substring(0, 2) +  '/' + _controllerDataFormacao.text.substring(6, 10);

    GruposModel oGrupo = GruposModel(
      idGrupo: widget.grupoModel.idGrupo,
      Nome: _controllerNome.text,
      DataFormacao: dataForm,
      IDGestor:  dropDownControllerEntidades.selecionadoEntidades!.Id,
    );

    var messageReturn = await gruposApi.updateGrupo(oGrupo);

    if (messageReturn["type"] == "S") {
      Fluttertoast.showToast(
          msg: messageReturn["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      AppModel app = Provider.of<AppModel>(context, listen: false);
      app.setPage(GruposPage());
    }else {
      Fluttertoast.showToast(
          msg: messageReturn["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
    }
  }

  _onClickAdd() async {
    if (_controllerNome.text == "" || _controllerDataFormacao.text == "") {
      _onClickDialog();
      return;
    }
    GruposApi gruposApi = GruposApi();

    var dataForm =_controllerDataFormacao.text.substring(3, 5) + '/' + _controllerDataFormacao.text.substring(0, 2) +  '/' + _controllerDataFormacao.text.substring(6, 10);

    GruposModel oGrupo = GruposModel(
      Nome: _controllerNome.text,
      DataFormacao: dataForm,
      IDGestor: dropDownControllerEntidades.selecionadoEntidades!.Id ?? 0,
    );

    var messageReturn = await gruposApi.createGrupo(oGrupo);

    if (messageReturn["type"] == "S") {
      Fluttertoast.showToast(
          msg: messageReturn["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      AppModel app = Provider.of<AppModel>(context, listen: false);
      app.setPage(GruposPage());
    } else{
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
              leading: Icon(Icons.warning,
              color: Colors.orange,
              size: 30,),
              title: Text('Preencha os campos obrigatórios.',
             style: TextStyle(fontSize: 20),
             ),
              subtitle: Text('Nome, Data da Formatação, Entidade.',
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
