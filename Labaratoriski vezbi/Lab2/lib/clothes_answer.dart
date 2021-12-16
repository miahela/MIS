import 'package:flutter/material.dart';

class ClothesAnswer extends StatelessWidget {
  String _answerText;
  Function tapped;

  ClothesAnswer(this.tapped, this._answerText);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: ElevatedButton(
        child: Text(
          _answerText,
          style: TextStyle(
            fontSize: 20,
            color: Colors.red,
          ),
        ),
        style: ElevatedButton.styleFrom(primary: Colors.green, padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        onPressed: tapped,
      ),
    );
  }
}
