import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toolkit/database/DogTable.dart';
import 'package:toolkit/models/Dog.dart';
import 'package:toolkit/utils/Dialogos.dart';

class DogsListState extends State<DogsList> {

  List<Dog> _dogs = List<Dog>(); 

  @override
  void initState() {
    super.initState();
    _populateList(); 
  }

  void _populateList() async {
    _dogs = await DogTable.criarLista();
    setState(() { });
  }

  Dismissible _buildItemsForListView(BuildContext context, int index) {
      return Dismissible(
        key: Key(_dogs[index].id.toString()),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async => await Dialogos.question(context, "Dog", "Excluir este registro?",),
        onDismissed: (direction) async {        
          await DogTable.deleteDog(_dogs[index].id);
          _dogs.removeAt(index);
          // Dialogos.snackBar(root, texto, duracao)
        },
        background: LeaveBehindView(),
        child: ListTile(
          title: Text(_dogs[index].name),
          subtitle: Text("Idade: ${_dogs[index].age}", style: TextStyle(fontSize: 18)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
          itemCount: _dogs.length,
          itemBuilder: _buildItemsForListView,
        );
  }
}

class DogsList extends StatefulWidget {

  @override
  createState() => DogsListState(); 
}

class LeaveBehindView extends StatelessWidget {
  LeaveBehindView({Key key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.red,
      padding: const EdgeInsets.all(16.0),
      child: new Row (
        children: <Widget>[
        //new Icon(Icons.delete),
        new Expanded(
          child: new Text(''),
        ),
        new Icon(Icons.delete, color: Colors.white),
        ],
      ),
    );
  } 
}
 