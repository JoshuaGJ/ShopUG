import 'package:flutter/material.dart';

class NoteDetail extends StatefulWidget {
  final String addAppBartitle;

  NoteDetail(this.addAppBartitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(addAppBartitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  final _priorities = ["High", "Low"];
  final String addAppBarTitle;
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  NoteDetailState(this.addAppBarTitle);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notes Details",
      home: Scaffold(
        appBar: AppBar(
          title: Text(addAppBarTitle),
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
                value: "Low",
                items: _priorities.map((String value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (selectedValue) {
                  setState(() {
                    debugPrint("user has selected $selectedValue");
                  });
                },
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: titleController,
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
                  decoration: InputDecoration(
                    labelText: "Descritption",
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
                        onPressed: () {},

                        child: Text("SAVE"),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {},

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
}
