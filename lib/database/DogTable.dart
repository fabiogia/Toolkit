import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:toolkit/database/BancoDados.dart';
import 'package:toolkit/models/Dog.dart';
import 'package:english_words/english_words.dart';
 
class DogTable {

  static Database db;

  static Future<List<Dog>> criarLista() async {
    // Get a reference to the database.
    if (db == null) db = await BancoDados.criarDatabase();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    if (maps.isEmpty) {
      _inserirDadosTeste();
    }

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  // Define a function that inserts dogs into the database
  static Future<void> insertDog(Dog dog) async {
    // Get a reference to the database.
    if (db == null) db = await BancoDados.criarDatabase();

    // Insert the Dog into the correct table. You might also specify the 
    // `conflictAlgorithm` to use in case the same dog is inserted twice. 
    // 
    // In this case, replace any previous data.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateDog(Dog dog) async {
    // Get a reference to the database.
    if (db == null) db = await BancoDados.criarDatabase();

    // Update the given Dog.
    await db.update(
      'dogs',
      dog.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dog.id],
    );
  }
 
  static Future<void> deleteDog(int id) async {
    // Get a reference to the database.
    if (db == null) db = await BancoDados.criarDatabase();

    // Remove the Dog from the Database.
    await db.delete(
      'dogs',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  static void _inserirDadosTeste() async {
    var fido = Dog(id: 0, name: 'Fido', age: 35, );
    await insertDog(fido);

    int id = 1;
    int idade;
    Random rnd = Random(100);
    generateWordPairs().take(50).forEach((palavra) async { 
      idade = 5 + rnd.nextInt(40-5);

      fido = Dog(id: id++, name: palavra.asString, age: idade, );
      await insertDog(fido);
    });
  }  
}