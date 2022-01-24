import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertask/helper_files/Users.dart';
import 'package:fluttertask/services/DatabaseHandler.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  late DatabaseHandler handler;
  late String userName;
  late String password;
  late String email;
  late String interest;
  late bool _passwordVisible;
  List<String> Interests = ['Football', 'Basketball', 'BeatBoxing', 'Coding'];
  late String selectedInterest;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
    selectedInterest = 'Football';
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              onChanged: (value) {
                userName = value;
              },
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                  border: UnderlineInputBorder(),
                  labelText: 'User Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              obscureText: !_passwordVisible,
              onChanged: (value) {
                password = value;
              },
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                  border: UnderlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(_passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              onChanged: (value) {
                email = value;
              },
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                  border: UnderlineInputBorder(),
                  labelText: 'Email'),
            ),
          ),
          DropdownButton<String>(
            value: 'Football',
            items: getDropDownItems(),
            onChanged: (value) {
              setState(() {
                selectedInterest = value!;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                onPressed: () {
                  checker();
                },
                child: Text('save')),
          )
        ],
      ),
    );
  }

  void checker() async {
    if (password.length < 8 || !(password.contains(new RegExp(r'[0-9]')))) {
      print(
          'password should have alphabet and numbers with minimum length of 8 chars');
      return;
    }
    bool found = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (found == false) {
      print('$email is not a correct form of email');
      return;
    }

    int newID = 0;
    var retrieveUser = await this.handler.retrieveUser();
    try {
      for (int i = 0; i < retrieveUser.length; i++) {
        if (retrieveUser[i].id! >= newID) {
          newID = ((retrieveUser[i].id)! + 1);
        }
      }
    } catch (e) {
      print(e);
    }
    Users newUser = Users(newID, userName, password, selectedInterest);
    await this.handler.insertUser(newUser);
    setState(() {});
    const snackBar = SnackBar(
      content: Text('Added user!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
    setState(() {});
  }

  List<DropdownMenuItem<String>> getDropDownItems() {
    List<DropdownMenuItem<String>> returnedInterest = [];
    for (int i = 0; i < Interests.length; i++) {
      String interestNow = Interests[i];

      var currentInterest = DropdownMenuItem(
        child: Text(interestNow),
        value: interestNow,
      );
      returnedInterest.add(currentInterest);
    }
    return returnedInterest;
  }
}
