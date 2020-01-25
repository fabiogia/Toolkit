import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toolkit/screens/ListViewPaginadoScreen.dart';
import 'package:toolkit/screens/SqfliteScreen.dart';
import 'package:toolkit/utils/Dialogos.dart';

class TabTestes extends StatefulWidget {
  TabTestes({Key key}) : super(key: key);

  @override
  _TabTestesState createState() => _TabTestesState();
}

class _TabTestesState extends State<TabTestes> {

  @override
  Widget build(BuildContext context) {
    return _camposGrid();
  }

  Widget _camposGrid() {
    var _tituloBotoes = [
      [ "formatPageBreak", "Demo Paginação ListView" ],
      [ "database", "Demo Sqflite" ]
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
                      case 0: _listViewPaginadoClick(); break;         
                      case 1: _sqfliteClick(); break;
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

  _listViewPaginadoClick() {
    Navigator.of(context).push(_criarRotaAnimada(ListViewPaginadoScreen()));
  }

  _sqfliteClick() {
    Navigator.of(context).push(_criarRotaAnimada(SqfliteScreen()));
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
}