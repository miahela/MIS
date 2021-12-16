import 'package:flutter/material.dart';

import './clothes_question.dart';

import './clothes_answer.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  void _iWasTapped() {
    setState(() {
      _questionIndex += 1;
    });
  }

  var questions = [
    {
      'question': "Select clothes type",
      'answer': [
        'Pants',
        'Dresses',
        'Coats',
        'Beachwear'
      ]
    },
    {
      'question': "Select season",
      'answer': [
        'Winter',
        'Summer',
        'Spring',
        'Autumn'
      ]
    },
    {
      'question': "Select style",
      'answer': [
        'High Fashion',
        'Y2K',
        'Sporty'
      ]
    },
  ];
  var _questionIndex = 0;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("Find out your best outfit"),
      ),
      body: Column(
        children: [
          ClothesQuestion(questions[_questionIndex]['question']),
          ...(questions[_questionIndex]['answer'] as List<String>).map((answer) {
            return ClothesAnswer(_iWasTapped, answer);
          }),
        ],
      ),
    ));
  }
}
