import 'package:flutter/material.dart';
import 'package:fluttertask/helper_files/Notes.dart';
import 'package:fluttertask/services/DatabaseHandler.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  late String noteDetails;
  late DatabaseHandler handler;
  late List<String> users;
  late String selectedInterest;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Text('Add Note'),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              setState(() {
                addNote();
              });
            },
          )
        ],
      )),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              onChanged: (value) {
                noteDetails = value;
              },
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                  border: UnderlineInputBorder(),
                  labelText: 'Note'),
            ),
          )
        ],
      ),
    );
  }

  void addNote() async {
    int newID = 0;
    var retrieveNote = await this.handler.retrieveNotes();
    try {
      for (int i = 0; i < retrieveNote.length; i++) {
        if (retrieveNote[i].id! >= newID) {
          newID = ((retrieveNote[i].id)! + 1);
        }
      }
    } catch (e) {
      print(e);
    }
    String now = new DateTime.now().toString();

    Notes newNote = Notes(newID, noteDetails, 1, now);
    await this.handler.insertNote(newNote);
    setState(() {});
    const snackBar = SnackBar(
      content: Text('Added note!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
    setState(() {});
  }
}
