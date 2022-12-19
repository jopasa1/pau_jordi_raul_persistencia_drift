//CALENDARIO CON PERSISTENCIA EN DRIFT - PAU CARMONA // JORDI PASCUAL // RAUL TADEO

import 'package:examen_calendari/editar_esdeveniment.dart';
import 'package:examen_calendari/esdeveniments_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'modelo.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => MyHomePage(
              title: "My home page",
            ),
        '/esdeveniment/nou': (context) => EditarEsdevenimentForm(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final EsdevenimentsController controlador = EsdevenimentsController();

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DateTime _selectedDay=DateTime.now();

  //EN LA CORRECION SE DECLARABA ESTA VARIABLE PERO NUNCA SE USABA, PROVOCANDO QUE CADA VEZ
  //QUE SE CLICARA UN DIA DISTINTO, SE VOLVIERA A LA FECHA ACTUAL.
  DateTime _focusedDay=DateTime.now();
  CalendarFormat _calendarFormat=CalendarFormat.month;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Se ha añadido un FutureBuilder que regenera la lista acorde a la base de datos cada vez
    //que se actualiza el estado.
    return FutureBuilder<void>(
      //Funcion load() que se encarga de actualizar la lista de esdeveniments acorde a la DB.
        future: widget.controlador.load(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot){
          List<Widget> children;
          if (snapshot.hasData) {
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          //Cuando la lectura de la base haya terminado cargamos el calendadrio y
          //la lista de eventos correspondientes.
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),

                  //AQUI ANTES DE ARREGLARLO SE IGUALABA CONSTANTEMENTE A DATETIME.NOW() PROVOCANDO
                  //UN RESET DEL DIA MARCADO.
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay; // update `_focusedDay` here as well
                    });
                  },
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  eventLoader: (day) {
                    return widget.controlador.getEsdeveniments(elDia: day);
                  },
                ),
                Expanded(
                  child: LlistatEsdevenimentsWidget(
                      llistaEsdeveniments: widget.controlador.getEsdeveniments(elDia: _selectedDay)),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await Navigator.of(context).pushNamed("/esdeveniment/nou");
                setState(() {});
              },
              tooltip: 'Afegir esdeveniment',
              child: const Icon(Icons.add),
            ),
          );
        },
    );
  }
}

class LlistatEsdevenimentsWidget extends StatelessWidget {
  const LlistatEsdevenimentsWidget({
    Key? key,
    required this.llistaEsdeveniments,
  }) : super(key: key);

  final List<Esdeveniment> llistaEsdeveniments;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        for (Esdeveniment lEsdeveniment in llistaEsdeveniments)
          EsdevenimentWidget(lEsdeveniment)
      ],
    );
  }
}

class EsdevenimentWidget extends StatelessWidget {
  const EsdevenimentWidget(
    this.esdeveniment, {
    Key? key,
  }) : super(key: key);

  final Esdeveniment esdeveniment;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          "${DateFormat("yyyy-MM-dd HH:mm").format(esdeveniment.horaInici)}: ${esdeveniment.titol}"),
    );
  }
}
