//CALENDARIO CON PERSISTENCIA EN DRIFT - PAU CARMONA // JORDI PASCUAL // RAUL TADEO

import 'package:drift/drift.dart';

//Declaramos la estructura de la tabla Events.
class Events extends Table{
  //ID int autoincrementada.
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get desc => text()();
  DateTimeColumn get start_date => dateTime()();
  DateTimeColumn get end_date => dateTime()();
}