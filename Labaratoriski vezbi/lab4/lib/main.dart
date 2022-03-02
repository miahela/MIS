import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        title: "Exams",
        home: new TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TodoListState();
}

class User {
  String username;
  String password;
  Map<String, DateTime> _exams = new HashMap<String, DateTime>();
  List<String> _dates = [];
  User(this.username, this.password);
}

class TodoListState extends State<TodoList> {
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  DateTime showFor = DateTime.now();
  Map<String, DateTime> _showExams = new HashMap<String, DateTime>();
  String _newExam = "";
  String _newPassword = "";
  String _newLogin = "";
  String _loggedInUser = "";
  String sanitizeDateTime(DateTime dateTime) =>
      "${dateTime.year}-${dateTime.month}-${dateTime.day}";

  List<User> users = [];

  FlutterLocalNotificationsPlugin localNotification;

  @override
  void initState() {
    super.initState();
    var androidInitialize = new AndroidInitializationSettings('ic_launcher');

    var iOSImtialize = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: androidInitialize, iOS: iOSImtialize);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String body) async {
    tz.initializeTimeZones();
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    var androidDetails = new AndroidNotificationDetails(
        "channelId", "Local Notification", "This is the description",
        importance: Importance.max);
    var iosDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotification.show(0, title, body, generalNotificationDetails);
  }

  void _register() {
    User u = new User(_newLogin, _newPassword);
    users.add(u);
    _showNotification(
        "Succesful registration", "You succesfully registered " + u.username);
  }

  void _login() {
    for (User u in users) {
      if (_newLogin == u.username) {
        if (_newPassword == u.password) {
          _showNotification(
              "Log in", "You succesfull loged in " + _loggedInUser);
          setState(() {
            _loggedInUser = _newLogin;
          });
        }
      }
    }
  }

  void _addExam() {
    if (_newExam.length > 0) {
      setState(() {
        if (_loggedInUser != "") {
          for (User u in users) {
            if (u.username == _loggedInUser) {
              DateTime ss = new DateTime(selectedDate.year, selectedDate.month,
                  selectedDate.day, selectedTime.hour, selectedTime.minute);
              u._dates.add(sanitizeDateTime(ss));
              u._exams[_newExam] = ss;
              _showNotification(
                  "Upcoming exam",
                  "Subject: " +
                      _newExam +
                      " date: " +
                      "${DateFormat('dd-MM-yyyy - kk:mm').format(ss)}");
            }
          }
        }
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  _filterByDate(BuildContext context) async {
    DateTime sDate;
    User sU;
    if (_loggedInUser != "") {
      for (User u in users) {
        if (u.username == _loggedInUser) {
          sDate = u._exams.values.last;
          sU = u;
        }
      }
    }

    final DateTime selected = await showDatePicker(
      context: context,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
      initialDate: sDate,
      selectableDayPredicate: (DateTime val) {
        String sanitized = sanitizeDateTime(val);
        return sU._dates.contains(sanitized);
      },
    );
    if (selected != null)
      setState(() {
        _showExams.clear();
        for (String ispit in sU._exams.keys) {
          if (sanitizeDateTime(sU._exams[ispit])
                  .compareTo(sanitizeDateTime(selected)) ==
              0) {
            _showExams[ispit] = sU._exams[ispit];
          }
        }
        showFor = selected;
      });
  }

  _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  void _setNewLoginUState(String username) {
    if (username.length > 0) {
      setState(() {
        _newLogin = username;
      });
    }
  }

  void _setNewLoginPState(String password) {
    if (password.length > 0) {
      setState(() {
        _newPassword = password;
      });
    }
  }

  void _setNewExamState(String ispit) {
    if (ispit.length > 0) {
      setState(() {
        _newExam = ispit;
      });
    }
  }

  Widget _buttons() {
    return new Row(
      children: [
        _loggedInUser == ""
            ? new IconButton(onPressed: _pushRegister, icon: Icon(Icons.login))
            : new IconButton(onPressed: _logout, icon: Icon(Icons.logout)),
        _loggedInUser == ""
            ? new Container(
                height: 0,
                width: 0,
              )
            : new IconButton(onPressed: _pushAddExam, icon: Icon(Icons.add))
      ],
    );
  }

  Widget _buildExamsList() {
    return new ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _showExams.length,
      itemBuilder: (context, index) {
        String key = _showExams.keys.elementAt(index);
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
                  "${DateFormat('dd-MM-yyyy - kk:mm').format(_showExams[key])}",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            ),
            onTap: () => null,
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
        title: new Text('Exam reminder'),
        actions: [
          _buttons(),
        ],
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            _buildExamsList(),
          ],
        ),
      ),
      floatingActionButton: _date(),
    );
  }

  void _pushRegister() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return _buildRegister();
    }));
  }

  void _logout() {
    _loggedInUser = "";
    setState(() {
      _loggedInUser = "";
      _showExams.clear();
      print("Logged off " + _loggedInUser);
    });
  }

  void _pushAddExam() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return _buildAddExam();
    }));
  }

  Widget _date() {
    User sU;
    for (User u in users) {
      if (_loggedInUser == u.username) {
        sU = u;
      }
    }
    if (_loggedInUser == "" || sU._exams.isEmpty || _loggedInUser == "") {
      return Container();
    } else {
      return FloatingActionButton(
        onPressed: () {
          _filterByDate(context);
        },
        tooltip: 'Increment',
        child: Text("date"),
      );
    }
  }

  Widget _buildRegister() {
    Widget _textElement() {
      return Column(
        children: [
          new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _login();
            },
            onChanged: (val) {
              _setNewLoginUState(val);
            },
            decoration: new InputDecoration(
                hintText: 'Username', contentPadding: EdgeInsets.all(16)),
          ),
          new TextField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            autofocus: true,
            onSubmitted: (val) {
              _login();
            },
            onChanged: (val) {
              _setNewLoginPState(val);
            },
            decoration: new InputDecoration(
                hintText: 'Password', contentPadding: EdgeInsets.all(16)),
          ),
        ],
      );
    }

    return new Scaffold(
        appBar: new AppBar(title: new Text('Authentication')),
        body: new Container(
            padding: EdgeInsets.all(16),
            child: new Column(
              children: <Widget>[
                _textElement(),
                new SizedBox(
                  height: 40,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new ElevatedButton(
                      onPressed: () {
                        _login();
                        Navigator.pop(context);
                      },
                      child: new Text("Login"),
                    ),
                    new ElevatedButton(
                      onPressed: () {
                        _register();
                        Navigator.pop(context);
                      },
                      child: new Text("Sign in"),
                    ),
                  ],
                )
              ],
            )));
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
          ElevatedButton(
            onPressed: () {
              _selectDate(context);
            },
            child: Text("Date"),
          ),
          ElevatedButton(
            onPressed: () {
              _selectTime(context);
            },
            child: Text("Time"),
          ),
        ],
      );
    }

    return new Scaffold(
        appBar: new AppBar(title: new Text('Add new exam')),
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
