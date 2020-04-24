import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'authentication.dart';

class ProfileWidget extends StatefulWidget {

  ProfileWidget({this.auth});

  final BaseAuth auth;

  @override
  _ProfileWidgetState createState() => new _ProfileWidgetState();
}

enum AuthStatus {
  NOT_DETERMINED,
  LOGGED_OUT,
  LOGGED_IN,
}

class _ProfileWidgetState extends State<ProfileWidget> {
  
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  final _formKey = new GlobalKey<FormState>();
  String _authID = '';
  String _name;
  String _email;
  String _password;
  String _errorMessage = "";

  bool _isIos = false;
  bool _isLoading = false;

  var userDocument;

  @override

  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _authID = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.LOGGED_OUT : AuthStatus.LOGGED_IN;
      });
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          new StreamBuilder(
              stream: Firestore.instance
                  .collection('UserData')
                  .document(_authID)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Text("Loading");
                }
                userDocument = snapshot.data;
                return formWidget(userDocument);
              }),
        ],
      ),
    );
  }

  Widget formWidget(var userDocument) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _nameWidget(userDocument["FullName"]),
          _emailWidget(userDocument["Email"]),
          updateButtonWidget()
        ],
      ),
    );
  }

  Widget _nameWidget(var fullName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 100.0, 10.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Enter Full Name',
            icon: new Icon(
              Icons.text_fields,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email cannot be empty' : null,
        initialValue: fullName,
        onSaved: (value) => _name = value.trim(),
      ),
    );
  }

  Widget _emailWidget(var eMail) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
      child: TextFormField(
        enabled: false,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Enter Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email cannot be empty' : null,
        initialValue: eMail,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget updateButtonWidget() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: new MaterialButton(
            elevation: 5.0,
            minWidth: 200.0,
            height: 42.0,
            color: Colors.blue,
            child: new Text('Save',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () {
              _save();
            }));
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _save() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    if (_validateAndSave()) {

      print(_name);
      print(_authID);

    }
  }
}
