import 'dart:collection';
import 'package:flutter/material.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        title: "Exams app",
        home: new TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  Map<String, String> _exams = new HashMap<String, String>();
  String _newExam = "";
  String _newDate = "";

  void _addExam() {
    if (_newExam.length > 0) {
      setState(() {
        print("EXAM " + _newExam + "  DATE  " + _newDate);
        _exams[_newExam] = _newDate;
      });
    }
  }

  void _deleteExam(int index) {
    setState(() {
      _exams.remove(_exams.keys.elementAt(index));
    });
  }

  void _promptFinishExam(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
                'Do you want to delete the exam for "${_exams.keys.elementAt(index)}" on  "${_exams[_exams.keys.elementAt(index)]}" ?'),
            actions: <Widget>[
              new TextButton(
                child: new Text('No'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              new TextButton(
                child: new Text('Delete'),
                onPressed: () {
                  _deleteExam(index);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _setNewExamState(String exam) {
    if (exam.length > 0) {
      setState(() {
        _newExam = exam;
      });
    }
  }

  void _setNewDateState(String date) {
    if (date.length > 0) {
      setState(() {
        _newDate = date;
      });
    }
  }

  Widget _buildExamsList() {
    return new ListView.builder(
      itemCount: _exams.length,
      itemBuilder: (context, index) {
        String key = _exams.keys.elementAt(index);
        return new Card(
          child: new ListTile(
            title: Column(
              children: [
                new Text(
                  "$key",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                new Text(
                  "${_exams[key]}",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            ),
            onTap: () => _promptFinishExam(index),
          ),
          margin: EdgeInsets.all(10),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Exams App'),
        actions: [
          IconButton(onPressed: _pushAddExam, icon: Icon(Icons.add))
        ],
      ),
      body: _buildExamsList(),
    );
  }

  void _pushAddExam() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return _buildAddExam();
    }));
  }

  Widget _buildAddExam() {
    Widget _textElement() {
      return Column(
        children: [
          new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addExam();
            },
            onChanged: (val) {
              _setNewExamState(val);
            },
            decoration: new InputDecoration(
                hintText: 'Subject',
                contentPadding: EdgeInsets.all(16)),
          ),
          new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addExam();
            },
            onChanged: (val) {
              _setNewDateState(val);
            },
            decoration: new InputDecoration(
                hintText: 'Date',
                contentPadding: EdgeInsets.all(16)),
          ),
        ],
      );
    }

    return new Scaffold(
        appBar: new AppBar(title: new Text('Add exam')),
        body: new Container(
            padding: EdgeInsets.all(16),
            child: new Column(
              children: <Widget>[
                _textElement(),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new ElevatedButton(
                      onPressed: () {
                        _addExam();
                        Navigator.pop(context);
                      },
                      child: new Text("Add"),
                    ),
                  ],
                )
              ],
            )));
  }
}
