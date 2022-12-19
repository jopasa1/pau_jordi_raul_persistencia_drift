//CALENDARIO CON PERSISTENCIA EN DRIFT - PAU CARMONA // JORDI PASCUAL // RAUL TADEO

import 'package:drift/drift.dart';

import 'db/database.dart';

class Esdeveniment {
  final DateTime horaInici, horaFinal;
  final String titol;
  final String? descripcio;

  Esdeveniment(
      {required this.horaInici,
        required this.horaFinal,
        required this.titol,
        this.descripcio});
}


class Model {

  static final Model _model=Model._internal();

  factory Model() {
    return _model;
  }

  Model._internal();

  //Modificada de FINAL para poder manipular su contenido.
  var esdeveniments = <Esdeveniment>[];

  //En caso de necesitar mantener el nuevo contenido solo.
  void delete(){
    esdeveniments = [];
  }

  ///////////////////////////
  //APARTADO BASE DE DATOS//
  /////////////////////////


  late AppDb _db;

  //Funcion encargada de leer la base de datos y transcribirla en esdeveniments
  //y a la vez añadirlos a la lista general.
  Future<void> readDB() async {
    try {
      //Creamos la conexion.
      _db = AppDb();
      //Llamamos al metodo encargado de devolvernos todos los eventos.
      List<Event> events = await _db.getEvents();
      //Por cada evento que tenemos en la DB creamos esdeveniments con dichos valores.
      for(var event in events){
        esdeveniments.add(Esdeveniment(
            horaInici: event.start_date!,
            horaFinal: event.end_date,
            titol: event.title,
            descripcio: event.desc));
      }
    } catch (e) {
      print("Error al insertar.");
    }
  }

  //Funcion encargada de insertar los datos de cada nuevo esdevenimiento apartir
  //de los parametros dados por el controlador al añadir un nuevo esdeveniment.
  insertDB(DateTime? start, DateTime? end, String? t, String? d){
    final entity = EventsCompanion(
      //NECESARIO EL VALUE() PARA PODER ASIGNAR LAS VARIABLES A PARAMETROS DE TIPO
      //VALUE<?>
      title: Value(t!),
      desc: Value(d!),
      start_date: Value(start!),
      end_date: Value(end!)
    );

    _db.insertEvent(entity);
  }
}

