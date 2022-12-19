//CALENDARIO CON PERSISTENCIA EN DRIFT - PAU CARMONA // JORDI PASCUAL // RAUL TADEO

import 'package:examen_calendari/esdeveniments_controller.dart';
import 'package:flutter/material.dart';

class EditarEsdevenimentForm extends StatefulWidget {
  EditarEsdevenimentForm({Key? key}) : super(key: key);

  final EsdevenimentsController controlador=EsdevenimentsController();

  @override
  State<EditarEsdevenimentForm> createState() => _EditarEsdevenimentFormState();
}

class _EditarEsdevenimentFormState extends State<EditarEsdevenimentForm> {
  final _clauFormulari = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edició esdeveniment"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: guardar el formulario
          if (_clauFormulari.currentState!=null && _clauFormulari.currentState!.validate()) {
            _clauFormulari.currentState!.save();
            widget.controlador.save();
            Navigator.of(context).pop();
          }
        },
        child: Icon(Icons.save),
      ),
      body: Form(
        key: _clauFormulari,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FormField<DateTime>(
                    onSaved: (valor) => widget.controlador.dataInici=valor,
                    builder: (formFieldState) {
                      return TextButton(
                          onPressed: () async {
                            DateTime? fecha = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2022),
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2022, 12));
                            if (fecha != null) {
                              formFieldState.didChange(fecha);
                              TimeOfDay? hora = await showTimePicker(
                                  context: context,
                                  initialTime: const TimeOfDay(hour: 0, minute: 0));
                              if (hora != null) {
                                formFieldState.didChange(DateTime(
                                    fecha.year,
                                    fecha.month,
                                    fecha.day,
                                    hora.hour,
                                    hora.minute));
                              }
                            }
                          },
                          child: Text(formFieldState.value == null
                              ? "Prem per definir"
                              : formFieldState.value.toString()));
                    },
                  ),
                ),
                Expanded(
                  child: FormField<DateTime>(
                    onSaved: (valor) => widget.controlador.dataFi=valor,
                    builder: (formFieldState) {
                      return TextButton(
                          onPressed: () async {
                            DateTime? fecha = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2022),
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2022, 12));
                            if (fecha != null) {
                              formFieldState.didChange(fecha);
                              TimeOfDay? hora = await showTimePicker(
                                  context: context,
                                  initialTime: const TimeOfDay(hour: 0, minute: 0));
                              if (hora != null) {
                                formFieldState.didChange(DateTime(
                                    fecha.year,
                                    fecha.month,
                                    fecha.day,
                                    hora.hour,
                                    hora.minute));
                              }
                            }
                          },
                          child: Text(formFieldState.value == null
                              ? "Prem per definir"
                              : formFieldState.value.toString()));
                    },
                  ),
                )
              ],
            ),
            TextFormField(
              onSaved: (valor) => widget.controlador.titol=valor,
              decoration: const InputDecoration(labelText: "Títol"),
              validator: (valor) => valor==null || valor==""?"Debe introducir un valor":null,
            ),
            Expanded(
              child: TextFormField(
                onSaved: (valor) => widget.controlador.descripcio=valor,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  labelText: "Descripció",
                  alignLabelWithHint: true,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
