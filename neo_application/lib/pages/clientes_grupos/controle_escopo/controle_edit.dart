import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neo_application/pages/clientes_grupos/adm_grupos/dropDownController_Grupo.dart';
import 'package:neo_application/pages/clientes_grupos/adm_grupos/grupos_model.dart';
import 'package:neo_application/pages/clientes_grupos/controle_escopo/controle_api.dart';
import 'package:neo_application/pages/clientes_grupos/controle_escopo/controle_model.dart';
import 'package:neo_application/pages/clientes_grupos/controle_escopo/controle_page.dart';
import 'package:neo_application/pages/clientes_grupos/entidades_gestoras/dropDownController_Entidades.dart';
import 'package:neo_application/pages/clientes_grupos/entidades_gestoras/entidades_model.dart';
import 'package:neo_application/pages/clientes_grupos/fracao_propriedades/Tabelas_model.dart';
import 'package:neo_application/pages/clientes_grupos/fracao_propriedades/dropDownController_Fracao.dart';
import 'package:neo_application/pages/clientes_grupos/fracao_propriedades/fracao_model.dart';
import 'package:neo_application/pages/provider/app_provider.dart';
import 'package:provider/provider.dart';

import '../../widgets/dropdown_edit_fracao.dart';

class ControleEdit extends StatefulWidget {
  ControleModel controleModel;
  var tipoAcao;

  ControleEdit({Key? key, required this.controleModel, this.tipoAcao})
      : super(key: key);

  @override
  State<ControleEdit> createState() => _ControleEditState();
}

class _ControleEditState extends State<ControleEdit> {
  Size get size => MediaQuery.of(context).size;
  late ControleModel oControle;
  late String _valueEntrada;
  late String _valueSaida;

  DropDownControllerEntidades dropDownControllerEntidades =
      DropDownControllerEntidades();
  DropDownControllerGrupos dropDownControllerGrupos =
      DropDownControllerGrupos();
  DropDownControllerFracao dropDownControllerFracao =
      DropDownControllerFracao();

  final TextEditingController _controllerID = TextEditingController();
  final TextEditingController _controlleridFracao = TextEditingController();
  final TextEditingController _controlleridEntidade = TextEditingController();
  final TextEditingController _controlleridGrupo = TextEditingController();
  final TextEditingController _controllerDataEntrada = TextEditingController();
  final TextEditingController _controllerDataSaida = TextEditingController();
  final TextEditingController _controllerRequerenteSaida =
      TextEditingController();
  final TextEditingController _controllerAreaEscopo = TextEditingController();
  final TextEditingController _controllerAreaAuditada = TextEditingController();
  final TextEditingController _controllerCicloTrabalho =
      TextEditingController();

  late AppModel appRepository;
  late ControleModel oControleModel;

  EntidadesModel listEntidadesSelecionado = EntidadesModel();
  EntidadesModel listFracaoSelecionado = EntidadesModel();
  FracaoPropModel listGrupoSelecionado = FracaoPropModel();

  TodasTabelasModel todasTabelas = TodasTabelasModel();

  List<EntidadesModel> listEntidades = [];
  List<FracaoPropModel> listFracao = [];
  List<GruposModel> listGrupos = [];

  DateTime? dataEntrada;
  DateTime? dataSaida;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _setText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    oControleModel = widget.controleModel;
    appRepository = Provider.of<AppModel>(context);
    return Scaffold(
      body: _body(),
      appBar: AppBar(
        title: Text(widget.tipoAcao == "editar"
            ? "Editar Controle de Escopo (${widget.controleModel.ID})"
            : "Criar Novo Controle de Escopo"),
        backgroundColor: Color.fromRGBO(78, 204, 196, 2),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
    );
  }

  _setText() async {
    oControle = widget.controleModel;
    _controllerID.text = oControle.ID.toString();
    _controlleridFracao.text = oControle.idFracao.toString();
    _controlleridEntidade.text = oControle.idEntidade.toString();
    _controlleridGrupo.text = oControle.idGrupo.toString();
    _controllerDataEntrada.text = oControle.DataEntrada.toString();
    _controllerDataSaida.text = oControle.DataSaida.toString();
    _controllerRequerenteSaida.text = oControle.RequerenteSaida.toString();
    _controllerAreaEscopo.text = oControle.AreaEscopo.toString();
    _controllerAreaAuditada.text = oControle.AreaAuditada.toString();
    _controllerCicloTrabalho.text = oControle.CicloTrabalho.toString();
  }

  _buscarGrupos() async {
    await dropDownControllerGrupos.buscarGrupos();
    var listGrupos = dropDownControllerGrupos.listGrupos;

    if (oControle.grupos != null) {
      var listGruposFiltrado = listGrupos
          .where((element) => element.idGrupo == oControle.grupos!.idGrupo)
          .toList();
      dropDownControllerGrupos.setSelecionadoGrupos(listGruposFiltrado[0]);
    }
  }

  _buscarEntidades() async {
    await dropDownControllerEntidades.buscarEntidades();
    var listEntidades = dropDownControllerEntidades.listEntidades;

    if (oControle.entidades != null) {
      var listEntidadeFiltrado = listEntidades
          .where((element) => element.Id == oControle.entidades!.Id)
          .toList();

      dropDownControllerEntidades
          .setSelecionadoEntidades(listEntidadeFiltrado[0]);
      _buscarFracao(listEntidadeFiltrado[0].Id!);
    }
  }

  _buscarFracao(int idEnti) async {
    await dropDownControllerFracao.buscarFracao(idEnti);
    var listFracao = dropDownControllerFracao.listFracao;

    if (oControle.fracao != null) {
      var listFracaoFiltrado = listFracao
          .where((element) => element.ID == oControle.fracao!.ID)
          .toList();
      dropDownControllerFracao.setSelecionadoFracao(listFracaoFiltrado[0]);
    }
  }

  _body() {
    _buscarEntidades();
    _buscarGrupos();
    return FutureBuilder(
      future: TodasTabelas().getTodasTabelas(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Erro ao carregar os dados"));
        }
        if (snapshot.hasData) {
          todasTabelas = snapshot.data;
          listEntidades = todasTabelas.entidades!;
          listFracao = todasTabelas.fracaoPropriedades!;
          listGrupos = todasTabelas.grupos!;

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              CircularProgressIndicator();
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
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
                                animation: dropDownControllerGrupos,
                                builder: (context, child) {
                                  if (dropDownControllerGrupos
                                      .listGrupos.isEmpty) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                      child: DropdownButtonFormField(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          labelText: "Grupos",
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                        ),
                                        hint: Text("Grupos"),
                                        isDense: true,
                                        isExpanded: true,
                                        value: dropDownControllerGrupos
                                            .selecionadoGrupos,
                                        onChanged: (value) {
                                          dropDownControllerGrupos
                                              .setSelecionadoGrupos(value);
                                        },
                                        items: dropDownControllerGrupos
                                            .listGrupos
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
                                animation: dropDownControllerEntidades,
                                builder: (context, child) {
                                  if (dropDownControllerEntidades
                                      .listEntidades.isEmpty) {
                                    return Center(
                                        child:
                                            const CircularProgressIndicator());
                                  } else {
                                    return DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                      child: DropdownButtonFormField<
                                          EntidadesModel>(
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          labelText: "Entidades",
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                        ),
                                        hint: Text("Entidades"),
                                        isDense: true,
                                        isExpanded: true,
                                        value: dropDownControllerEntidades
                                            .selecionadoEntidades,
                                        onChanged: (value) {
                                          dropDownControllerEntidades
                                              .setSelecionadoEntidades(value);
                                          dropDownControllerFracao
                                              .buscarFracao(value!.Id!);
                                        },
                                        items: dropDownControllerEntidades
                                            .listEntidades
                                            .map((tipos) => DropdownMenuItem<
                                                    EntidadesModel>(
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
                            DropdownEditFracao(
                              dropDownControllerFracao:
                                  dropDownControllerFracao,
                            ),
                            const SizedBox(
                              width: 30,
                              height: 20,
                            ),
                            Container(
                              width: 300,
                              height: 40,
                              child: TextFormField(
                                controller: _controllerDataEntrada,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Data de Entrada",
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
                                      if (data != null) {
                                        dataEntrada = data;
                                        _valueEntrada = data.toString();
                                        _controllerDataEntrada.text =
                                            _valueEntrada.substring(8, 10) +
                                                '/' +
                                                _valueEntrada.substring(5, 7) +
                                                '/' +
                                                _valueEntrada.substring(0, 4);
                                      }
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
                              child: TextFormField(
                                controller: _controllerDataSaida,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Data de Saida",
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
                                      if (data != null) {
                                        dataSaida = data;
                                        _valueSaida = data.toString();
                                        _controllerDataSaida.text =
                                            _valueSaida.substring(8, 10) +
                                                '/' +
                                                _valueSaida.substring(5, 7) +
                                                '/' +
                                                _valueSaida.substring(0, 4);
                                      }
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
                              height: 40,
                              child: TextFormField(
                                controller: _controllerRequerenteSaida,
                                decoration: const InputDecoration(
                                  labelText: "Requerente de Sa??da",
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
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+.?\d{0,2}'))
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: _controllerAreaEscopo,
                                decoration: const InputDecoration(
                                  labelText: "??rea Escopo",
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
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+.?\d{0,2}'))
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: _controllerAreaAuditada,
                                decoration: const InputDecoration(
                                  labelText: "??rea Auditada",
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
                                controller: _controllerCicloTrabalho,
                                decoration: const InputDecoration(
                                  labelText: "Ciclo Trabalho",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                              height: 20,
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
                ? Text("Salvar Altera????es")
                : Text("Adicionar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(246, 34, 37, 44)),
            onPressed: () => {appRepository.setPage(ControlePage())},
            child: Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  _onClickSalvar() async {
    if (_controllerDataEntrada.text == "" ||
        dropDownControllerGrupos.selecionadoGrupos == null ||
        dropDownControllerEntidades.selecionadoEntidades == null ||
        dropDownControllerFracao.selecionadoFracao == null) {
      _onClickDialog();
      return;
    }

    var DataEntrada = _controllerDataEntrada.text;
    var DataSaida = _controllerDataSaida.text;

    if (DataEntrada != "") {
      DataEntrada = _controllerDataEntrada.text.substring(3, 5) +
          '/' +
          _controllerDataEntrada.text.substring(0, 2) +
          '/' +
          _controllerDataEntrada.text.substring(6, 10);
    } else {
      DataEntrada = "";
    }

    if (DataSaida != "") {
      DataSaida = _controllerDataSaida.text.substring(3, 5) +
          '/' +
          _controllerDataSaida.text.substring(0, 2) +
          '/' +
          _controllerDataSaida.text.substring(6, 10);
    } else {
      DataSaida = "";
    }

    double AreaEscopo = double.parse(_controllerAreaEscopo.text);
    double AreaAuditada = double.parse(_controllerAreaAuditada.text);
    int CicloTrabalho = int.parse(_controllerCicloTrabalho.text);

    if (_controllerAreaEscopo.text.isEmpty) {
      AreaEscopo = 0;
    } else {
      AreaEscopo =
          double.parse(_controllerAreaEscopo.text.replaceAll(",", "."));
    }

    if (_controllerAreaAuditada.text.isEmpty) {
      AreaAuditada = 0;
    } else {
      AreaAuditada =
          double.parse(_controllerAreaAuditada.text.replaceAll(",", "."));
    }

    var fracao;
    var propriedade;
    var entidades;
    var grupos;

    var idFracao = dropDownControllerFracao.selecionadoFracao;
    if (idFracao == null) {
      fracao = 0;
    } else {
      fracao = dropDownControllerFracao.selecionadoFracao!.ID;
    }

    if (idFracao != null) {
      var idPropriedade = idFracao.IDPropriedade;
    if (idPropriedade == null) {
      propriedade = 0;
    } else {
      propriedade = dropDownControllerFracao.selecionadoFracao!.IDPropriedade;
    }
    } else {
      propriedade = 0;
    }

    var idPropriedade = idFracao!.IDPropriedade;
    if (idPropriedade == null) {
      propriedade = 0;
    } else {
      propriedade = dropDownControllerFracao.selecionadoFracao!.IDPropriedade;
    }

    var idEntidade = dropDownControllerEntidades.selecionadoEntidades;
    if (idEntidade == null) {
      entidades = 0;
    } else {
      entidades = dropDownControllerEntidades.selecionadoEntidades!.Id;
    }

    var idGrupo = dropDownControllerGrupos.selecionadoGrupos;
    if (idGrupo == null) {
      grupos = 0;
    } else {
      grupos = dropDownControllerGrupos.selecionadoGrupos!.idGrupo;
    }

    ControleApi controleApi = ControleApi();

    ControleModel oControle = ControleModel(
      ID: widget.controleModel.ID,
      idFracao: fracao,
      idEntidade: entidades,
      idGrupo: grupos,
      idPropriedade: propriedade,
      DataEntrada: DataEntrada.toString(),
      DataSaida: DataSaida.toString(),
      RequerenteSaida: _controllerRequerenteSaida.text.toString(),
      AreaEscopo: AreaEscopo,
      AreaAuditada: AreaAuditada,
      CicloTrabalho: CicloTrabalho,
    );

    var messageReturn = await controleApi.updateControle(oControle);

    if (messageReturn["type"] == "S") {
      Fluttertoast.showToast(
          msg: messageReturn["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 10,
          fontSize: 16.0);

      AppModel app = Provider.of<AppModel>(context, listen: false);
      app.setPage(ControlePage());
    } else {
      Fluttertoast.showToast(
          msg: messageReturn["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 10,
          fontSize: 16.0);
    }
  }

  _onClickAdd() async {
    if (_controllerDataEntrada.text == "" ||
        dropDownControllerGrupos.selecionadoGrupos == null ||
        dropDownControllerEntidades.selecionadoEntidades == null ||
        dropDownControllerFracao.selecionadoFracao == null) {
      _onClickDialog();
      return;
    }

    var DataEntrada = _controllerDataEntrada.text;
    var DataSaida = _controllerDataSaida.text;

    if (DataEntrada != "") {
      DataEntrada = _controllerDataEntrada.text.substring(3, 5) +
          '/' +
          _controllerDataEntrada.text.substring(0, 2) +
          '/' +
          _controllerDataEntrada.text.substring(6, 10);
    } else {
      DataEntrada = "";
    }

    if (DataSaida != "") {
      DataSaida = _controllerDataSaida.text.substring(3, 5) +
          '/' +
          _controllerDataSaida.text.substring(0, 2) +
          '/' +
          _controllerDataSaida.text.substring(6, 10);
    } else {
      DataSaida = "";
    }

    double AreaEscopo = double.parse(_controllerAreaEscopo.text);
    double AreaAuditada = double.parse(_controllerAreaAuditada.text);
    int CicloTrabalho = int.parse(_controllerCicloTrabalho.text);

    if (_controllerAreaEscopo.text.isEmpty) {
      AreaEscopo = 0;
    } else {
      AreaEscopo =
          double.parse(_controllerAreaEscopo.text.replaceAll(",", "."));
    }

    if (_controllerAreaAuditada.text.isEmpty) {
      AreaAuditada = 0;
    } else {
      AreaAuditada =
          double.parse(_controllerAreaAuditada.text.replaceAll(",", "."));
    }

    var fracao;
    var propriedade;
    var entidades;
    var grupos;

    var idFracao = dropDownControllerFracao.selecionadoFracao;
    if (idFracao == null) {
      fracao = 0;
    } else {
      fracao = dropDownControllerFracao.selecionadoFracao!.ID;
    }

    if (idFracao != null) {
      var idPropriedade = idFracao.IDPropriedade;
    if (idPropriedade == null) {
      propriedade = 0;
    } else {
      propriedade = dropDownControllerFracao.selecionadoFracao!.IDPropriedade;
    }
    } else {
      propriedade = 0;
    }

    var idEntidade = dropDownControllerEntidades.selecionadoEntidades;
    if (idEntidade == null) {
      entidades = 0;
    } else {
      entidades = dropDownControllerEntidades.selecionadoEntidades!.Id;
    }

    var idGrupo = dropDownControllerGrupos.selecionadoGrupos;
    if (idGrupo == null) {
      grupos = 0;
    } else {
      grupos = dropDownControllerGrupos.selecionadoGrupos!.idGrupo;
    }

    ControleApi controleApi = ControleApi();

    ControleModel oControle = ControleModel(
      idFracao: fracao,
      idEntidade: entidades,
      idGrupo: grupos,
      idPropriedade: propriedade,
      DataEntrada: DataEntrada.toString(),
      DataSaida: DataSaida.toString(),
      RequerenteSaida: _controllerRequerenteSaida.text.toString(),
      AreaEscopo: AreaEscopo,
      AreaAuditada: AreaAuditada,
      CicloTrabalho: CicloTrabalho,
    );

    var messageReturn = await controleApi.createControle(oControle);

    if (messageReturn["type"] == "S") {
      Fluttertoast.showToast(
          msg: messageReturn["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 10,
          fontSize: 16.0);
      AppModel app = Provider.of<AppModel>(context, listen: false);
      app.setPage(ControlePage());
    } else {
      Fluttertoast.showToast(
          msg: messageReturn["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 10,
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
                  'Preencha os campos obrigat??rios',
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  'Entidades, Grupos, Fra????o e Data de Entrada.',
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
