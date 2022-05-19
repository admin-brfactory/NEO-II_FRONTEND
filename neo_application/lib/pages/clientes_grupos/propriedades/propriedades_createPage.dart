import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propManejo/propManejo_model.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propriedades_api.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propriedades_busy.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propriedades_model.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/propriedades_page.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/tipoManejo/dropDownController.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/tipoProduto/dropDownController.dart';
import 'package:neo_application/pages/provider/app_provider.dart';
import 'package:neo_application/pages/utils/list_uf.dart';
import 'package:provider/provider.dart';
import 'tipoFloresta/dropDownController.dart';

class PropriedadesCreate extends StatefulWidget {
  var tipoAcao;
  var indice;

  PropriedadesCreate({Key? key, this.tipoAcao, this.indice}) : super(key: key);

  @override
  State<PropriedadesCreate> createState() => _PropriedadesCreateState();
}

class _PropriedadesCreateState extends State<PropriedadesCreate> {
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

  Uf? ufController = Uf();

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
  String? listUfSelecionado;
  String? valueSelected;

  @override
  Widget build(BuildContext context) {
    appRepository = Provider.of<AppModel>(context);
    propriedadesBusy = Provider.of<PropriedadesBusy>(context);
    return Scaffold(
      body: _body(),
      appBar: AppBar(
        title: Text("Criar Nova Propriedade"),
        backgroundColor: Color.fromRGBO(78, 204, 196, 2),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
    );
  }

  _setText() async {
    listIndice = widget.indice;
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

  _Buttons() {
    return Container(
      alignment: Alignment.bottomRight,
      child: ButtonBar(
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(246, 34, 37, 44)),
            onPressed: () => _onClickAdd(),
            child: Text("Adicionar"),
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

  _onClickAdd() async {
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
        UF: listUfSelecionado ?? "");

    var messageReturn = await propriedadesApi.createPropriedade(oProp);

    if (messageReturn["type"] == "S") {
      Fluttertoast.showToast(
          msg: messageReturn["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 10,
          fontSize: 16.0);
      AppModel app = Provider.of<AppModel>(context, listen: false);
      app.setPage(PropriedadesPage());
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
