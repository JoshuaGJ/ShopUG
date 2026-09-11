import 'package:flutter/material.dart';
import 'note_detail.dart';
import '/models/note.dart';
import '/utils/database_helper.dart';

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
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note>? noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    noteList ??= <Note>[];
    updateListView();

    return Scaffold(
      appBar: AppBar(title: Text("Notes App")),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navDetailScrn(Note("", "", 2, ""), "Add Note");
        },
        tooltip: "add note",
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, color: Colors.white),
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
              backgroundColor: getPriorityColor(noteList![position].priority),
              child: getPriorityIcon(noteList![position].priority),
            ),
            title: Text(noteList![position].title),
            subtitle: Text(noteList![position].date),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                _delete(noteList![position]);
              },
            ),
            onTap: () {
              navDetailScrn(noteList![position], "Edit Note");
              debugPrint("list tile Tapped");
            },
          ),
        );
      },
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;

      case 2:
        return Colors.yellow;

      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);

      case 2:
        return Icon(Icons.keyboard_arrow_right);

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(Note note) async {
    final noteToDelete = note;
    int result = await databaseHelper.deleteNote(note.id!);
    if (!context.mounted) return;
    if (result != 0) {
      _showSnackBar(
        context,
        'Note deleted successfully',
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            await databaseHelper.insertNote(noteToDelete);
          },
        ),
      );

      updateListView();
    }
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    SnackBarAction? action,
  }) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
      action: action,
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navDetailScrn(Note note, String title) async {
    bool results = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return NoteDetail(note, title);
        },
      ),
    );

    if (results == true) {
      updateListView();
    }
  }

  void updateListView() async {
    await databaseHelper.initializeDatabase();
    List<Note> freshNoteList = await databaseHelper.getNoteList();
    setState(() {
      noteList = freshNoteList;
      count = freshNoteList.length;
    });
  }
}
