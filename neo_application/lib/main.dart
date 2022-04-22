import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:neo_application/pages/clientes_grupos/propriedades/tipoManejo/dropDownController.dart';
import 'package:neo_application/pages/login_page/login_page.dart';
import 'package:neo_application/pages/provider/app_provider.dart';
import 'package:neo_application/pages/provider/drawer_provider.dart';
import 'package:neo_application/pages/utils/list_uf.dart';
import 'package:provider/provider.dart';
import 'pages/clientes_grupos/propriedades/propriedades_busy.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [Locale('pt', 'BR')],
      home: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DrawerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DropDownController(),
        ),
        ChangeNotifierProvider(
          create: (context) => PropriedadesBusy(),
        ),
        ChangeNotifierProvider(
          create: (context) => Uf(),
        ),
      ],
      child: MaterialApp(
          title: 'Eco',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),

          home: LoginPage()),

    );
  }
}
