import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi/wifi.dart';
// import 'package:permission_handler/permission_handler.dart';

import '../../utils/Dialogos.dart';

class TabRotulos extends StatefulWidget {
  TabRotulos({Key key}) : super(key: key);

  @override
  _TabRotulosState createState() => _TabRotulosState();
}

class _TabRotulosState extends State<TabRotulos> {

  final _nomes = <String>[
    "Colegio filhos - {data}-1",
    "Colegio filhos - {data}-2",
    "Dalmo - {data}",
    "ENEL - {data}",
    "IPTU {ano} - {data}",
    "Itaucard Visa - {data}",
    "Nubank - {data}",
    "Saneago - {data}",
    "Simples Nacional - {data}",
    "Sogra - {data}",
    "Tim - {data}",
    "Tim Live - {data}",
    "Vale alimentação - {data}",
    "",
    "Contador - {data}",
    "FGTS zelador - {data}",
    "Salario zelador - {data}",
    "GPS zelador - {data}",
    "PIS zelador - {data}",
  ];

  final _scaffoldKey = GlobalKey<ScaffoldState>(); 
  final dataHoje = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final anoAtual = DateFormat('yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () { 
      _atualizarMeuIp(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _camposMeuIp(),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 1.0,
                color: Colors.grey,
              ),
              itemCount: _nomes.length + 1,
              itemBuilder: (context, index) { 
                if (index == 0) {
                  return _descricao();
                }

                return ListTile(
                  title: Text(_substituirMacros(_nomes[index - 1])),
                  onTap: () { 
                    Clipboard.setData(ClipboardData(text: _substituirMacros(_nomes[index - 1])));
                    Dialogos.snackBar(_scaffoldKey, "Copiado para o clipboard", Duration(seconds: 2));
                  },
                  );
              },
            )
          )
        ]
    );
  }

  String _meuIp = "";

  Widget _camposMeuIp() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 5, 5), 
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

  _atualizarMeuIp() async {
    // PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    // if (permission != PermissionStatus.granted) {
    //   Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.location]);
    //   if (permission != PermissionStatus.granted) {
    //     return;
    //   }
    // }

    setState(() {
      _meuIp = "Obtendo...";
    });

    String ip = await Wifi.ip;
    String ssid = await Wifi.ssid;
    //Signal strength， 1-3，The bigger the number, the stronger the signal
    // int level = await Wifi.level;
    
    setState(() {
      _meuIp = "$ip  Rede $ssid";
    });
  }

  String _substituirMacros(String texto) {
    return texto.replaceAll("{data}", dataHoje).replaceAll("{ano}", anoAtual);
  }

  Widget _descricao() {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.grey[200], 
      child: Text("Nomes usados em recibos de pagamento salvos no Google Drive ou semelhante. Os recibos são gerados ao pagar contas em apps bancários. Toque em um item para copiar o texto."),
    );
  }
}
