import 'package:flutter/material.dart';
import 'package:oh_so_you_are/other/utility.dart';

class AddPlace extends StatefulWidget{
  const AddPlace({Key? key}) : super(key: key);

  @override
  State<AddPlace> createState() => _AddPlace();
}

class _AddPlace extends State<AddPlace> {
  final _formKey = GlobalKey<FormState>();
  final _placeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aggiungi luogo"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextFormField(
                controller: _placeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome luogo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci un nome';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Utility.addPlace(_placeController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Aggiungi'),
            ),
          ],
        ),
      ),
    );
  }
}