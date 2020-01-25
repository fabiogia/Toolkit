import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toolkit/utils/Dialogos.dart';

class TabUtils extends StatefulWidget {
  TabUtils(this.scaffoldKey, {Key key}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _TabUtilsState createState() => _TabUtilsState(scaffoldKey);
}

class _TabUtilsState extends State<TabUtils> {

  GlobalKey<ScaffoldState> scaffoldKey;

  _TabUtilsState(this.scaffoldKey);

  @override
  Widget build(BuildContext context) {
    return _camposGrid();
  }

  Widget _camposGrid() {
    var _tituloBotoes = [
      [ "barcode", "Limpar código de barras" ],
    ];
    
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return ListView(
      children: <Widget>[
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

  _limpezaCodBarrasClick() async {    
    String texto = (await Clipboard.getData(Clipboard.kTextPlain)).text;
    if (texto == null || texto.length == 0) {
      Dialogos.snackBar(this.scaffoldKey, "Clipboard não possui um texto", Duration(seconds: 2));
    }
    else {
      var textoLimpo = _somenteNumeros(texto);

      Clipboard.setData(ClipboardData(text: textoLimpo));
      // Dialogos.showToast("Antes:\n$texto\n(tam: ${texto.length}) \n\nDepois:\n$textoLimpo\n(tam: ${textoLimpo.length})  (dif: ${textoLimpo.length - texto.length})");
      Dialogos.snackBar(this.scaffoldKey, "$textoLimpo", Duration(seconds: 2));
    }
  }

  String _somenteNumeros(String texto) {
    var buf = StringBuffer();
    var codes = texto.codeUnits;
    for(var c in codes) {
      if (c >= 48 && c <= 57) buf.writeCharCode(c);
    }
    return buf.toString();
  }
}