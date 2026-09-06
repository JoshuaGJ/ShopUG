import 'package:flutter/material.dart';
import 'note_detail.dart';

void main() {
  runApp(NoteList());
}

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes App")),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navDetailScrn("Add Note");
        },
        tooltip: "add note",
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Icon(Icons.arrow_right),
            ),
            title: Text(""),
            subtitle: Text(""),
            trailing: Icon(Icons.delete),
            onTap: () {
              navDetailScrn("Edit Note");
              debugPrint("list tile Tapped");
            },
          ),
        );
      },
    );
  }

  void navDetailScrn(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetail(title)),
    );
  }
}
