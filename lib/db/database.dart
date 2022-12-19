//CALENDARIO CON PERSISTENCIA EN DRIFT - PAU CARMONA // JORDI PASCUAL // RAUL TADEO


import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'tables.dart';

part 'database.g.dart';


//Generamos la conexion con la base de datos extrayendo el path al archivo mediante el package path.
LazyDatabase _openConnection(){
  return LazyDatabase(() async{
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path,'calendar_events.sqlite'));

    return NativeDatabase(file);
  });
}

//Declaramos la creacion de la base de datos partiendo de la tabla Events declarada en tables.dart.
@DriftDatabase(tables: [Events])
class AppDb extends _$AppDb{
  //Llamamos al metodo padre.
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  //Metodo encargado de devolver todos los eventos de la tabla.
  Future<List<Event>> getEvents() async{
    return await select(events).get();
  }

  //Metodo encargado de insertar eventos en la tabla.
  Future<int> insertEvent(EventsCompanion entity) async{
    return await into(events).insert(entity);
  }

}