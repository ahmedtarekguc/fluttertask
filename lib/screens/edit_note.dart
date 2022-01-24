import 'package:flutter/material.dart';
import 'package:fluttertask/helper_files/Notes.dart';
import 'package:fluttertask/services/DatabaseHandler.dart';

class EditNote extends StatefulWidget {
  const EditNote({
    Key? key,
    this.note,
  }) : super(key: key);
  final note;

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late Notes note = widget.note;
  late String noteDetails;
  late DatabaseHandler handler;
  late var users;
  late String selectedUser;

  void getUsers() async {
    users = await this.handler.retrieveUser;
    selectedUser = users[note.userID].userName;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noteDetails = note.noteText;
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {
      setState(() {});
    });
    int selUser = note.userID;
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Text('Edit Note'),
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
              initialValue: noteDetails,
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
    this.handler.deleteNote(note.id!);
    setState(() {});
    const snackBar = SnackBar(
      content: Text('Added note!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
    setState(() {});
  }
}
