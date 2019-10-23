import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/Dialogos.dart';

class NomeReciboScreen extends StatefulWidget {
  NomeReciboScreen({Key key}) : super(key: key);

  @override
  _NomeReciboScreenState createState() => _NomeReciboScreenState();
}

class _NomeReciboScreenState extends State<NomeReciboScreen> {

  var _nomes = <String>[
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
  final dataHoje = DateFormat('dd/MM/yyyy').format(DateTime.now());
  final anoAtual = DateFormat('yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Nome do recibo"),
      ),
      body: 
          
          ListView.separated(
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
        
    );
  }

  String _substituirMacros(String texto) {
    return texto.replaceAll("{data}", dataHoje).replaceAll("{ano}", anoAtual);
  }

  Widget _descricao() {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.grey[200], 
      child: Text("Nome usado no recibo compartilhado no Google Drive ou semelhante. O recibo é gerado ao pagar uma conta no app bancário. Toque em um item para copiar."),
    );
  }
}