import 'package:flutter/material.dart';
import '/models/note.dart';
import 'package:intl/intl.dart';
import 'package:manager/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String addAppBartitle;
  final Note note;

  const NoteDetail(this.note, this.addAppBartitle, {super.key});

  @override
  State<StatefulWidget> createState() => NoteDetailState();
}

class NoteDetailState extends State<NoteDetail> {
  final _priorities = ["High", "Low"];
  DatabaseHelper Helper = DatabaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        moveToLastScreen();
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.addAppBartitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              DropdownButton(
                value: getPriorityAsString(widget.note.priority),
                items: _priorities.map((String value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (selectedValue) {
                  setState(() {
                    debugPrint("user has selected $selectedValue");
                    updatePriorityAsInt(selectedValue!);
                  });
                },
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: titleController,
                  onChanged: (value) => updateTitle(),
                  decoration: InputDecoration(
                    labelText: "Title",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: detailsController,
                  onChanged: (value) => updateDescription(),
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _save();
                        },

                        child: Text("SAVE"),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _delete();
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.black,
                        ),
                        child: Text("Delete"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        widget.note.priority = 1;
        break;
      case 'Low':
        widget.note.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        return priority; // 'High'

      case 2:
        priority = _priorities[1]; // 'Low'
        return priority;

      default:
        return _priorities[1]; // Return 'High' as default
    }
  }

  void updateTitle() {
    widget.note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    widget.note.description = detailsController.text;
  }

  void _save() async {
    widget.note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (widget.note.id != null) {
      result = await Helper.updateNote(widget.note);
    } else {
      result = await Helper.insertNote(widget.note);
    }

    if (result != 0) {
      _showSnackBar(context, 'Note saved successfully');
    } else {
      _showSnackBar(context, 'Failed to save note');
    }

    moveToLastScreen();
  }

  void _delete() async {
    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (widget.note.id == null) {
      moveToLastScreen();
      _showSnackBar(context, 'Note deleted successfully');
      return;
    }

    final noteToDelete = widget.note;

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await Helper.deleteNote(widget.note.id!);

    // Context check across async boundary
    if (!mounted) return;

    if (result != 0) {
      moveToLastScreen();

      _showSnackBar(
        context,
        'Note deleted successfully',
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            await Helper.insertNote(noteToDelete);
          },
        ),
      );
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }

    moveToLastScreen();
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
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
}
