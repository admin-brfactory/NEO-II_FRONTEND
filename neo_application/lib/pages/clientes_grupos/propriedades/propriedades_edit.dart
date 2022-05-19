import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neo_application/main.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propFloresta/propFloresta_Model.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propManejo/propManejo_api.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propManejo/propManejo_model.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propProduto/propProduto_api.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propProduto/propProduto_model.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propriedades_api.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propriedades_busy.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propriedades_model.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propriedades_page.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/tipoManejo/dropDownController.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/tipoProduto/dropDownController.dart';
import 'package:neo_application/pages/provider/app_provider.dart';
import 'package:neo_application/pages/utils/list_uf.dart';
import 'package:provider/provider.dart';
import 'propFloresta/propFloresta_api.dart';
import 'tipoFloresta/dropDownController.dart';

class PropriedadesEdit extends StatefulWidget {
  PropriedadesModel propModel;
  var tipoAcao;
  var indice;
  String uf;
  PropriedadesEdit(
      {Key? key,
      required this.propModel,
      this.tipoAcao,
      this.uf = "",
      this.indice})
      : super(key: key);

  @override
  State<PropriedadesEdit> createState() => _PropriedadesEditState();
}

class _PropriedadesEditState extends State<PropriedadesEdit>
    with TickerProviderStateMixin {
  Size get size => MediaQuery.of(context).size;

  var listIndice;

  List ListTipoManejo = [
    {"ID": 1, "Descricao": "Descrição Teste 1"},
    {"ID": 2, "Descricao": "tipo manejo 1"},
    {"ID": 3, "Descricao": "tipo manejo 2"},
    {"ID": 4, "Descricao": "tipo manejo 3"}
  ];

  List<PropManejoModel> listPropManejo = [];
  List<PropriedadesModel> listProp = [];

  DropDownController dropDownController = DropDownController();
  DropDownControllerFloresta dropDownControllerFloresta =
      DropDownControllerFloresta();
  DropDownControllerProduto dropDownControllerProduto =
      DropDownControllerProduto();

  PropriedadesBusy? propriedadesBusy;

  bool isLoading = false;

  late PropriedadesModel oProp;

  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerCNPJ = TextEditingController();
  final TextEditingController _controllerXCoord = TextEditingController();
  final TextEditingController _controllerYCoord = TextEditingController();
  final TextEditingController _controllerAreaPropriedade =
      TextEditingController();
  final TextEditingController _controllerAreaTotal = TextEditingController();
  final TextEditingController _controllerAreaPlantada = TextEditingController();
  final TextEditingController _controllerAreaEstimaConser =
      TextEditingController();
  final TextEditingController _controllerAreaInfraestrutura =
      TextEditingController();
  final TextEditingController _controllerAreaOutro = TextEditingController();
  final TextEditingController _controllerLocalizacao = TextEditingController();

  final _controllerCNPJFocus = FocusNode();
  final _controllerXCoordFocus = FocusNode();
  final _controllerYCoordFocus = FocusNode();
  final _controllerAreaPropriedadeFocus = FocusNode();
  final _controllerAreaTotalFocus = FocusNode();
  final _controllerAreaPlantadaFocus = FocusNode();
  final _controllerAreaEstimaConserFocus = FocusNode();
  final _controllerAreaInfraestruturaFocus = FocusNode();
  final _controllerAreaOutroFocus = FocusNode();
  final _controllerLocalizacaoFocus = FocusNode();
  final _controllerUfFocus = FocusNode();

  late AppModel appRepository;
  double constWidth = 600;
  late PropriedadesModel oPropModel;
  String? listUfSelecionado;
  String? valueSelected;

  @override
  Widget build(BuildContext context) {
    oPropModel = widget.propModel;
    appRepository = Provider.of<AppModel>(context);
    propriedadesBusy = Provider.of<PropriedadesBusy>(context);
    return Scaffold(
      body: _body(),
      appBar: AppBar(
        title: Text(widget.tipoAcao == "editar"
            ? "Editar Propriedade (${widget.propModel.idPropriedade})"
            : "Criar Nova Propriedade"),
        backgroundColor: Color.fromRGBO(78, 204, 196, 2),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
    );
  }

  _setText() async {
    listIndice = widget.indice;
    oProp = widget.propModel;
    _controllerNome.text = oProp.Nome ?? "";
    _controllerCNPJ.text = oProp.CNPJ ?? "";
    _controllerXCoord.text = oProp.XCoord.toString();
    _controllerYCoord.text = oProp.yCoord.toString();
    _controllerAreaPropriedade.text = oProp.AreaPropriedade.toString();
    _controllerAreaTotal.text = oProp.AreaTotal.toString();
    _controllerAreaPlantada.text = oProp.AreaPlantada!.toString();
    _controllerAreaEstimaConser.text = oProp.AreaEstimaConservacao.toString();
    _controllerAreaInfraestrutura.text = oProp.AreaInfraestrutura.toString();
    _controllerAreaOutro.text = oProp.AreaOutrosUsos.toString();
    _controllerLocalizacao.text = oProp.Localizacao ?? "";
    listUfSelecionado = valueSelected != null
        ? valueSelected
        : oProp.UF != ""
            ? oProp.UF
            : "";

    dropDownController.buscarTipoManejo();

    dropDownControllerFloresta.buscarTipoFloresta();

    dropDownControllerProduto.buscarTipoProduto();
  }

  _body() {
    return FutureBuilder(
      future: PropriedadesApi().getListPropriedades(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Erro ao carregar os dados"));
        }
        if (snapshot.hasData) {
          listProp = snapshot.data;

          if (widget.propModel.Nome != "") {
            _setText();
          }

          TabController _tabController = TabController(length: 3, vsync: this);

          List<String> listUfs = Uf().listUfs();

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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 786) {
                          return Container(
                            padding: EdgeInsets.all(25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _formEsq(),
                                _formDir(),
                                _Buttons(),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            padding: EdgeInsets.all(25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _formEsq()),
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                    ),
                                    Expanded(child: _formDir()),
                                  ],
                                ),
                                _Buttons()
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Card(
                    child: Column(
                      children: [
                        Container(
                          child: TabBar(
                            controller: _tabController,
                            labelColor: Colors.white,
                            unselectedLabelColor: Color.fromRGBO(68, 76, 87, 2),
                            indicatorColor: Color.fromRGBO(68, 76, 87, 2),
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              color: Color.fromRGBO(78, 204, 196, 2),
                            ),
                            tabs: [
                              Tab(text: "Tipos de Manejo"),
                              Tab(text: "Tipos de Floresta"),
                              Tab(text: "Produtos"),
                            ],
                          ),
                        ),
                        Container(
                          width: double.maxFinite,
                          height: 400,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              //Manejo
                              ListView(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 300,
                                                child: ListView.builder(
                                                  itemCount: snapshot
                                                      .data[widget.indice]
                                                      .tipoManejo
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Card(
                                                      child: ListTile(
                                                        title: Text(
                                                            "${Map.from(listProp[listIndice].tipoManejo[index])['Descricao']}"),
                                                        trailing: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            IconButton(
                                                              onPressed:
                                                                  () async {
                                                                await _dialogDeleteManejo(
                                                                    index,
                                                                    context);
                                                              },
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                color: Color
                                                                    .fromARGB(
                                                                        246,
                                                                        34,
                                                                        37,
                                                                        44),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            _ButtonsManejo(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              //Floresta
                              ListView(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 300,
                                                child: ListView.builder(
                                                  itemCount: snapshot
                                                      .data[widget.indice]
                                                      .tipoFloresta
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Card(
                                                      child: ListTile(
                                                        title: Text(
                                                            "${Map.from(listProp[listIndice].tipoFloresta[index])['Descricao']}"),
                                                        trailing: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            IconButton(
                                                              onPressed:
                                                                  () async {
                                                                await _dialogDeleteFloresta(
                                                                    index,
                                                                    context);
                                                              },
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                color: Color
                                                                    .fromARGB(
                                                                        246,
                                                                        34,
                                                                        37,
                                                                        44),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [_ButtonsFloresta()],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              //Produto
                              ListView(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 300,
                                                child: ListView.builder(
                                                  itemCount: snapshot
                                                      .data[widget.indice]
                                                      .produtos
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Card(
                                                      child: ListTile(
                                                        title: Text(
                                                            "${Map.from(listProp[listIndice].produtos[index])['Descricao']}"),
                                                        trailing: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            IconButton(
                                                              onPressed:
                                                                  () async {
                                                                await _dialogDeleteProduto(
                                                                    index,
                                                                    context);
                                                              },
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                color: Color
                                                                    .fromARGB(
                                                                        246,
                                                                        34,
                                                                        37,
                                                                        44),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [_ButtonsProduto()],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  _formEsq() {
    return Column(
      children: [
        SizedBox(
          width: constWidth,
          height: 40,
          child: TextFormField(
            textInputAction: TextInputAction.next,
            autofocus: true,
            onEditingComplete: () => _controllerCNPJFocus.requestFocus(),
            controller: _controllerNome,
            decoration: const InputDecoration(
              labelText: "Nome",
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: constWidth,
          height: 60,
          child: TextFormField(
            focusNode: _controllerCNPJFocus,
            onEditingComplete: () => _controllerXCoordFocus.requestFocus(),
            controller: _controllerCNPJ,
            maxLength: 18,
            decoration: const InputDecoration(
              labelText: "CNPJ",
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          width: constWidth,
          height: 40,
          child: TextFormField(
            focusNode: _controllerXCoordFocus,
            onEditingComplete: () => _controllerYCoordFocus.requestFocus(),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+.?\d{0,2}'))
            ],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _controllerXCoord,
            decoration: const InputDecoration(
              labelText: "XCoord",
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: constWidth,
          height: 40,
          child: TextFormField(
            focusNode: _controllerYCoordFocus,
            onEditingComplete: () =>
                _controllerAreaPropriedadeFocus.requestFocus(),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+.?\d{0,2}'))
            ],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _controllerYCoord,
            decoration: const InputDecoration(
              labelText: "YCoord",
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: constWidth,
          height: 40,
          child: TextFormField(
            focusNode: _controllerAreaPropriedadeFocus,
            onEditingComplete: () => _controllerAreaTotalFocus.requestFocus(),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+.?\d{0,2}'))
            ],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _controllerAreaPropriedade,
            decoration: const InputDecoration(
              labelText: "Área da Propriedade",
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: constWidth,
          height: 40,
          child: TextFormField(
            focusNode: _controllerAreaTotalFocus,
            onEditingComplete: () =>
                _controllerAreaPlantadaFocus.requestFocus(),
            controller: _controllerAreaTotal,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+.?\d{0,2}'))
            ],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: "Área Total",
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  _formDir() {
    List<String> listUfs = Uf().listUfs();
    return Column(
      children: [
        SizedBox(
          width: constWidth,
          height: 40,
          child: TextFormField(
            focusNode: _controllerAreaPlantadaFocus,
            onEditingComplete: () =>
                _controllerAreaEstimaConserFocus.requestFocus(),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+.?\d{0,2}'))
            ],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _controllerAreaPlantada,
            decoration: const InputDecoration(
              labelText: "Área Plantada",
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: constWidth,
          height: 40,
          child: TextFormField(
            focusNode: _controllerAreaEstimaConserFocus,
            onEditingComplete: () =>
                _controllerAreaInfraestruturaFocus.requestFocus(),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+.?\d{0,2}'))
            ],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _controllerAreaEstimaConser,
            decoration: const InputDecoration(
              labelText: "Área Estimada de Conservação",
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: constWidth,
          height: 40,
          child: TextFormField(
            focusNode: _controllerAreaInfraestruturaFocus,
            onEditingComplete: () => _controllerAreaOutroFocus.requestFocus(),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+.?\d{0,2}'))
            ],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _controllerAreaInfraestrutura,
            decoration: const InputDecoration(
              labelText: "Área de Infraestrutura",
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: constWidth,
          height: 40,
          child: TextFormField(
            focusNode: _controllerAreaOutroFocus,
            onEditingComplete: () => _controllerLocalizacaoFocus.requestFocus(),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+.?\d{0,2}'))
            ],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _controllerAreaOutro,
            decoration: const InputDecoration(
              labelText: " Outras Áreas",
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: constWidth,
          height: 40,
          child: TextFormField(
            focusNode: _controllerLocalizacaoFocus,
            onEditingComplete: () => _controllerUfFocus.requestFocus(),
            controller: _controllerLocalizacao,
            decoration: const InputDecoration(
              labelText: "Localização",
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: constWidth,
          height: 40,
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  labelText: "UF",
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                hint: Text("UF"),
                isDense: true,
                isExpanded: true,
                value: listUfSelecionado,
                onChanged: (newValue) => {
                  setState(() {
                    valueSelected = newValue;
                    listUfSelecionado = valueSelected;
                  })
                },
                items: listUfs.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 30,
          height: 20,
        ),
      ],
    );
  }

/*********************************************************************************
 *  Inicio de funções para a lista de Manejo ID: MANFIND
 *********************************************************************************/

// BOTÃO PARA ABRIR O POPUP DE ADD TIPO MANEJO
  _ButtonsManejo() {
    return Container(
      alignment: Alignment.bottomRight,
      child: ButtonBar(
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(246, 34, 37, 44)),
            onPressed: () => _onClickAddManejo(),
            child: Text("Adicionar"),
          ),
        ],
      ),
    );
  }

  //popup para add novo manejo
  _onClickAddManejo() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: AnimatedBuilder(
              animation: dropDownController,
              builder: (context, child) {
                if (dropDownController.listTipoManejo.isEmpty) {
                  return const CircularProgressIndicator();
                } else {
                  return DropdownButtonHideUnderline(
                      child: ButtonTheme(
                    child: DropdownButton(
                      hint: Text("Tipos Manejo"),
                      isDense: true,
                      isExpanded: true,
                      value: dropDownController.selecionadoTipoManejo,
                      onChanged: (value) =>
                          dropDownController.setSelecionadoTipoManejo(value),
                      items: dropDownController.listTipoManejo
                          .map((tipos) => DropdownMenuItem(
                                child: Text(tipos.Descricao!),
                                value: tipos,
                              ))
                          .toList(),
                    ),
                  ));
                }
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => _onAddManejo(
                  context,
                  dropDownController.selecionadoTipoManejo!.ID,
                  dropDownController.selecionadoTipoManejo!.Descricao),
              child: Text("Salvar"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(246, 34, 37, 44)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(246, 34, 37, 44)),
            ),
          ],
        ),
      );

  void _onAddManejo(context, sId, sDesc) async {
    var propManejo = PropManejoModel(
        IDPropriedade: oPropModel.idPropriedade, IDTipoManejo: sId);
    var result = await PropManejoApi().createPropManejo(propManejo);

    if (result["type"] == "S") {
      propriedadesBusy!.setOnLoad();
      Fluttertoast.showToast(
          msg: result["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      Navigator.pop(context);
      setState(() {
        PropriedadesApi().getListPropriedades();
      });
    } else {
      Fluttertoast.showToast(
          msg: result["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      Navigator.pop(context);
    }
  }

  _dialogDeleteManejo(int index, BuildContext context) => showDialog(
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
              onPressed: () => _deleteManejo(index, context),
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

  Future<void> _deleteManejo(int index, BuildContext context) async {
    var resposta = await PropManejoApi()
        .deletePropManejo(listProp[listIndice].propManejo[index]["ID"]);
    if (resposta["type"] == "S") {
      propriedadesBusy!.setOnLoad();
      Fluttertoast.showToast(
          msg: resposta["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      Navigator.pop(context);
      setState(() {
        PropriedadesApi().getListPropriedades();
      });
    } else {
      Fluttertoast.showToast(
          msg: resposta["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      Navigator.pop(context);
    }
  }

/*******************   FIM FUNÇÕES MANEJO   ************************************ */

/*********************************************************************************
*  Inicio de funções para a lista de Florestas - ID:#FLTFIND
*********************************************************************************/
// BOTÃO PARA ABRIR O POPUP DE ADD TIPO FLORESTAS
  _ButtonsFloresta() {
    return Container(
      alignment: Alignment.bottomRight,
      child: ButtonBar(
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(246, 34, 37, 44)),
            onPressed: () => _onClickAddFloresta(),
            child: Text("Adicionar"),
          ),
        ],
      ),
    );
  }

  //popup para add novo manejo
  _onClickAddFloresta() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: AnimatedBuilder(
              animation: dropDownControllerFloresta,
              builder: (context, child) {
                if (dropDownControllerFloresta.listTipoFloresta.isEmpty) {
                  return const CircularProgressIndicator();
                } else {
                  return DropdownButtonHideUnderline(
                      child: ButtonTheme(
                    child: DropdownButton(
                      hint: Text("Tipos Floresta"),
                      isDense: true,
                      isExpanded: true,
                      value: dropDownControllerFloresta.selecionadoTipoFloresta,
                      onChanged: (value) => dropDownControllerFloresta
                          .setSelecionadoTipoFloresta(value),
                      items: dropDownControllerFloresta.listTipoFloresta
                          .map((tipos) => DropdownMenuItem(
                                child: Text(tipos.Descricao!),
                                value: tipos,
                              ))
                          .toList(),
                    ),
                  ));
                }
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => _onAddFloresta(
                  context,
                  dropDownControllerFloresta.selecionadoTipoFloresta!.ID,
                  dropDownControllerFloresta
                      .selecionadoTipoFloresta!.Descricao),
              child: Text("Salvar"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(246, 34, 37, 44)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(246, 34, 37, 44)),
            ),
          ],
        ),
      );

  void _onAddFloresta(context, sId, sDesc) async {
    var propFloresta = PropFlorestaModel(
        IDPropriedade: oPropModel.idPropriedade, IDTipoManejo: sId);
    var result = await PropFlorestaAPI().createPropManejo(propFloresta);

    if (result["type"] == "S") {
      propriedadesBusy!.setOnLoad();
      Fluttertoast.showToast(
          msg: result["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      Navigator.pop(context);
      setState(() {
        PropriedadesApi().getListPropriedades();
      });
    } else {
      Fluttertoast.showToast(
          msg: result["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      Navigator.pop(context);
    }
  }

  _dialogDeleteFloresta(int index, BuildContext context) => showDialog(
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
              onPressed: () => _deleteFloresta(index, context),
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

  Future<void> _deleteFloresta(int index, BuildContext context) async {
    var resposta = await PropFlorestaAPI()
        .deletePropManejo(listProp[listIndice].propFloresta[index]["ID"]);
    if (resposta["type"] == "S") {
      propriedadesBusy!.setOnLoad();
      Fluttertoast.showToast(
          msg: resposta["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      Navigator.pop(context);
      setState(() {
        PropriedadesApi().getListPropriedades();
      });
    } else {
      Fluttertoast.showToast(
          msg: resposta["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      Navigator.pop(context);
    }
  }

/*******************   FIM FUNÇÕES FLORESTAS   ************************************ */

/*********************************************************************************
*  Inicio de funções para a lista de Produto - ID:#ProdFIND
*********************************************************************************/
// BOTÃO PARA ABRIR O POPUP DE ADD TIPO PRODUTO
  _ButtonsProduto() {
    return Container(
      alignment: Alignment.bottomRight,
      child: ButtonBar(
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(246, 34, 37, 44)),
            onPressed: () => _onClickAddProduto(),
            child: Text("Adicionar"),
          ),
        ],
      ),
    );
  }

  //POPUP PARA ADD NOVO PRODUTO
  _onClickAddProduto() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: AnimatedBuilder(
              animation: dropDownControllerProduto,
              builder: (context, child) {
                if (dropDownControllerProduto.listTipoProduto.isEmpty) {
                  return const CircularProgressIndicator();
                } else {
                  return DropdownButtonHideUnderline(
                      child: ButtonTheme(
                    child: DropdownButton(
                      hint: Text("Tipos Produtos"),
                      isDense: true,
                      isExpanded: true,
                      value: dropDownControllerProduto.selecionadoTipoProduto,
                      onChanged: (value) => dropDownControllerProduto
                          .setSelecionadoTipoProduto(value),
                      items: dropDownControllerProduto.listTipoProduto
                          .map((tipos) => DropdownMenuItem(
                                child: Text(tipos.Descricao!),
                                value: tipos,
                              ))
                          .toList(),
                    ),
                  ));
                }
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => _onAddProduto(
                  context,
                  dropDownControllerProduto.selecionadoTipoProduto!.ID,
                  dropDownControllerProduto.selecionadoTipoProduto!.Descricao),
              child: Text("Salvar"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(246, 34, 37, 44)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(246, 34, 37, 44)),
            ),
          ],
        ),
      );

  void _onAddProduto(context, sId, sDesc) async {
    var propProduto = PropProdutoModel(
        IDPropriedade: oPropModel.idPropriedade, IDTipoManejo: sId);
    var result = await PropProdutoApi().createPropProduto(propProduto);

    if (result["type"] == "S") {
      propriedadesBusy!.setOnLoad();
      Fluttertoast.showToast(
          msg: result["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      Navigator.pop(context);
      setState(() {
        PropriedadesApi().getListPropriedades();
      });
    } else {
      Fluttertoast.showToast(
          msg: result["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      Navigator.pop(context);
    }
  }

  _dialogDeleteProduto(int index, BuildContext context) => showDialog(
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
              onPressed: () => _deleteProduto(index, context),
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

  Future<void> _deleteProduto(int index, BuildContext context) async {
    var resposta = await PropProdutoApi()
        .deletePropProduto(listProp[listIndice].propProdutos[index]["ID"]);
    if (resposta["type"] == "S") {
      propriedadesBusy!.setOnLoad();
      Fluttertoast.showToast(
          msg: resposta["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      Navigator.pop(context);
      setState(() {
        PropriedadesApi().getListPropriedades();
      });
    } else {
      Fluttertoast.showToast(
          msg: resposta["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      Navigator.pop(context);
    }
  }

/*******************   FIM FUNÇÕES PRODUTOS   ************************************ */

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
            onPressed: () => {appRepository.setPage(PropriedadesPage())},
            child: Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  _onClickSalvar() async {
    if (_controllerNome.text == "" ||
        _controllerCNPJ.text == "" ||
        _controllerXCoord.text == "" ||
        _controllerYCoord.text == "") {
      _onClickDialog();
      return;
    }

    double areaPropriedade;
    double areaTotal;
    double areaPlantada;
    double areaEstimaConservacao;
    double areaInfraestrutura;
    double areaOutrosUsos;

    double xCoord = double.parse(_controllerXCoord.text.replaceAll(",", "."));

    double yCoord = double.parse(_controllerYCoord.text.replaceAll(",", "."));

    if (_controllerAreaPropriedade.text.isEmpty) {
      areaPropriedade = 0;
    } else {
      areaPropriedade =
          double.parse(_controllerAreaPropriedade.text.replaceAll(",", "."));
    }

    if (_controllerAreaTotal.text.isEmpty) {
      areaTotal = 0;
    } else {
      areaTotal = double.parse(_controllerAreaTotal.text.replaceAll(",", "."));
    }

    if (_controllerAreaPlantada.text.isEmpty) {
      areaPlantada = 0;
    } else {
      areaPlantada =
          double.parse(_controllerAreaPlantada.text.replaceAll(",", "."));
    }

    if (_controllerAreaEstimaConser.text.isEmpty) {
      areaEstimaConservacao = 0;
    } else {
      areaEstimaConservacao =
          double.parse(_controllerAreaEstimaConser.text.replaceAll(",", "."));
    }

    if (_controllerAreaInfraestrutura.text.isEmpty) {
      areaInfraestrutura = 0;
    } else {
      areaInfraestrutura =
          double.parse(_controllerAreaInfraestrutura.text.replaceAll(",", "."));
    }

    if (_controllerAreaOutro.text.isEmpty) {
      areaOutrosUsos = 0;
    } else {
      areaOutrosUsos =
          double.parse(_controllerAreaOutro.text.replaceAll(",", "."));
    }

    PropriedadesApi propriedadesApi = PropriedadesApi();

    PropriedadesModel oProp = PropriedadesModel(
      idPropriedade: oPropModel.idPropriedade,
      Nome: _controllerNome.text,
      CNPJ: _controllerCNPJ.text,
      XCoord: xCoord,
      yCoord: yCoord,
      AreaPropriedade: areaPropriedade,
      AreaTotal: areaTotal,
      AreaPlantada: areaPlantada,
      AreaEstimaConservacao: areaEstimaConservacao,
      AreaInfraestrutura: areaInfraestrutura,
      AreaOutrosUsos: areaOutrosUsos,
      Localizacao: _controllerLocalizacao.text ?? "",
      UF: listUfSelecionado ?? "",
    );

    var messageReturn = await propriedadesApi.updatePropriedade(oProp);

    if (messageReturn["type"] == "S") {
      Fluttertoast.showToast(
          msg: messageReturn["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 16.0);
      AppModel app = Provider.of<AppModel>(context, listen: false);
      app.setPage(PropriedadesPage());
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
                  'Nome, CNPJ, XCoord, YCoord.',
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
