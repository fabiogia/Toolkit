import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toolkit/screens/NomeReciboScreen.dart';
import 'package:toolkit/screens/ListViewPaginadoScreen.dart';
import 'package:toolkit/screens/SqfliteScreen.dart';
import 'package:wifi/wifi.dart';

import 'utils/Dialogos.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meu toolkit',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Meu toolkit'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>(); 

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () { 
      _atualizarMeuIp(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _camposGrid()
    );
  }

  Widget _camposMeuIp() {
    return Padding(
      padding: EdgeInsets.all(5), 
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(_meuIp)
                ]
              )
            )
          ),
          FlatButton(
            padding: EdgeInsets.all(0),
            child: Icon(Icons.refresh),
            onPressed: () { _atualizarMeuIp(); }
          )
        ],
      ));
  }

  _limpezaCodBarrasClick() async {    
    String texto = (await Clipboard.getData(Clipboard.kTextPlain)).text;
    if (texto == null || texto.length == 0) {
      Dialogos.snackBar(_scaffoldKey, "Clipboard não possui um texto", Duration(seconds: 3));
    }
    else {
      var textoLimpo = _somenteNumeros(texto);

      Clipboard.setData(ClipboardData(text: textoLimpo));
      Dialogos.snackBar(_scaffoldKey, "Antes:\n$texto\n(tam: ${texto.length}) \n\nDepois:\n$textoLimpo\n(tam: ${textoLimpo.length})  (dif: ${textoLimpo.length - texto.length})", Duration.zero);
    }
  }

  _nomeReciboClick() {
    Navigator.of(context).push(_criarRotaAnimada(NomeReciboScreen()));
  }

  Route _criarRotaAnimada(Widget tela) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => tela,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  String _meuIp = "";

  _atualizarMeuIp() async {
    setState(() {
     this._meuIp = "Obtendo...";
    });

    String ip = await Wifi.ip;
    String ssid = await Wifi.ssid;
    //Signal strength， 1-3，The bigger the number, the stronger the signal
    // int level = await Wifi.level;
    
    setState(() {
     this._meuIp = "$ip  Rede $ssid";
    });
  }

  String _somenteNumeros(String texto) {
    var buf = StringBuffer();
    var codes = texto.codeUnits;
    for(var c in codes) {
      if (c >= 48 && c <= 57) buf.writeCharCode(c);
    }
    return buf.toString();
  }

  _listViewPaginadoClick() {
    Navigator.of(context).push(_criarRotaAnimada(ListViewPaginadoScreen()));
  }

  _sqfliteClick() {
    Navigator.of(context).push(_criarRotaAnimada(SqfliteScreen()));
  }

  Widget _camposGrid() {
    var _tituloBotoes = [
      [ "barcode", "Limpar código de barras" ],
      [ "googleDrive", "Nome do recibo" ],
      [ "formatPageBreak", "Demo Paginação ListView" ],
      [ "database", "Demo Sqflite" ]
    ];
    
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return ListView(
      children: <Widget>[
        _camposMeuIp(),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isPortrait ? 3 : 5),
          itemCount: _tituloBotoes.length,
          itemBuilder: (context, index) =>
            SizedBox.expand(
              child: Padding(
                padding: EdgeInsets.all(5), 
                child: RaisedButton(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(MdiIcons.fromString(_tituloBotoes[index][0]), size: 36),
                      Text(_tituloBotoes[index][1], textAlign: TextAlign.center),
                    ],
                  ),
                  onPressed: () { 
                    switch(index) {
                      case 0: _limpezaCodBarrasClick(); break;
                      case 1: _nomeReciboClick(); break;
                      case 2: _listViewPaginadoClick(); break;         
                      case 3: _sqfliteClick(); break;
                    }
                  },
                ),
              )
            )
          ,
          physics: ScrollPhysics(), // to disable GridView's scrolling
          shrinkWrap: true, 
        )
      ]);
  }
}
