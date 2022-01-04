import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../widgets/image_input.dart';
import '../widgets/location_input.dart';
import '../providers/kolkvium.dart';

class AddKolkviumScreen extends StatefulWidget {
  static const routeName = '/add-kolokvium';
  @override
  _AddKolkviumScreenState createState() => _AddKolkviumScreenState();
}

class _AddKolkviumScreenState extends State<AddKolkviumScreen> {
  @override
  Widget build(BuildContext context) {
    final _titleController = TextEditingController();
    String _datePicked = "Not set";
    File _pickedImage;

    void _selectImage(File pickedImage) {
      _pickedImage = pickedImage;
    }

    void _saveKolokvium() {
      print(_titleController.text);
      print(_datePicked);
      if (_titleController.text.isEmpty || _datePicked == "Not set") return;

      Provider.of<Kolokvium>(context, listen: false)
          .addKolkvium(_titleController.text, _datePicked);
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new kolokvium"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                    SizedBox(height: 10),
                    TextButton(
                        onPressed: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2018, 3, 5),
                              maxTime: DateTime(2019, 6, 7), onConfirm: (date) {
                            var newDate =
                                DateFormat('yyyy-MM-dd – kk:mm').format(date);
                            _datePicked = newDate;
                            setState(() {});
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Text(
                          'show date time picker',
                          style: TextStyle(color: Colors.blue),
                        )),
                    SizedBox(height: 10),
                    Text(_datePicked)
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Add kolokvium'),
              onPressed: _saveKolokvium,
              elevation: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Theme.of(context).accentColor),
        ],
      ),
    );
  }
}
