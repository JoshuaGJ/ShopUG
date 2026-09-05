import 'package:flutter/material.dart';
import 'screens/note_list.dart';
//import 'screens/note_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NotesApp",
      home: NoteList(),
      theme: ThemeData(primarySwatch: Colors.deepPurple),
    );
  }
}
