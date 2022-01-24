import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertask/helper_files/Notes.dart';
import 'package:fluttertask/screens/add_note.dart';
import 'package:fluttertask/services/DatabaseHandler.dart';

import 'add_user_screen.dart';
import 'edit_note.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool searchText = false;

  List getAllNotes = [];
  List getAllUsers = [];
  List getAllInterests = [];
  List getNote = [];
  List updateNote = [];
  List insertNote = [];
  List clearNotes = [];
  List insertUser = [];
  List resetDummy = [];
  List _info = [];
  late DatabaseHandler handler;

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/Java Test.postman_collection.json');
    final data = await json.decode(response);
    setState(() {
      getAllNotes.add(data["item"][0]);
      getAllUsers.add(data["item"][1]);
      getAllInterests.add(data["item"][2]);
      getNote.add(data["item"][3]);
      updateNote.add(data["item"][4]);
      insertNote.add(data["item"][5]);
      clearNotes.add(data["item"][6]);
      insertUser.add(data["item"][7]);
      resetDummy.add(data["item"][8]);
      _info.add(data["info"]);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJson();
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Notes'),
          SizedBox(
            width: 20.0,
          ),
          Row(
            children: [
              GestureDetector(
                child: Icon(Icons.person_add),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddUserScreen(),
                      )).then((_) => setState(() {}));
                  ;
                },
              ),
              SizedBox(
                width: 10.0,
              ),

              GestureDetector(
                  onTap: () {},
                  child: IconButton(
                    icon: Icon(Icons.clear_all),
                    onPressed: () {
                      setState(() {
                        deleteAll();
                      });
                    },
                  ))
            ],
          )
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.filter_list,
                      color: Colors.blue,
                    )),
                SizedBox(
                  width: 10.0,
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        searchText = true;
                      });
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.blue,
                    ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Flexible(
              child: FutureBuilder(
                future: this.handler.retrieveNotes(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Notes>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Icon(Icons.delete_forever),
                          ),
                          key: ValueKey<int>(snapshot.data![index].id!),
                          onDismissed: (DismissDirection direction) async {
                            await this
                                .handler
                                .deleteNote(snapshot.data![index].id!);
                            setState(() {
                              snapshot.data!.remove(snapshot.data![index]);
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditNote(
                                      note: snapshot.data![index],
                                    ),
                                  )).then((_) => setState(() {}));
                            },
                            child: Card(
                                child: ListTile(
                              contentPadding: EdgeInsets.all(8.0),
                              title: Text(snapshot.data![index].noteText),
                              subtitle:
                                  Text(snapshot.data![index].userID.toString()),
                            )),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNoteScreen(),
              )).then((_) => setState(() {}));
        },
      ),
    );
  }

  void deleteAll() async {
    var retrieveUser = await this.handler.retrieveUser();
    for (int i = 0; i < retrieveUser.length; i++) {
      this.handler.deleteUsers(retrieveUser[i].id!);
    }
    var retrieveNotes = await this.handler.retrieveNotes();
    for (int i = 0; i < retrieveNotes.length; i++) {
      this.handler.deleteNote(retrieveNotes[i].id!);
    }
    setState(() {});
  }
}
