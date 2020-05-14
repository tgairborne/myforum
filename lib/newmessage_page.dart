import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'authentication.dart';

class NewMessageWidget extends StatefulWidget {


  @override
  _NewMessageWidgetState createState() => new _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _formKey = new GlobalKey<FormState>();

  String _title;
  String _content;
  String _errorMessage = "";

  bool _isIos = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Create New Topic'),
      ),
      body: Column(
        children: <Widget>[formWidget()],
      ),
    );
  }

  Widget formWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _contentWidget(),
          saveButtonWidget()
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
      child: TextFormField(
        maxLines: 2,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'Enter Topic Title',
          labelText: 'Topic Title',
        ),
        validator: (value) =>
            value.isEmpty ? 'Topic title cannot be empty' : null,
        initialValue: _title,
        onSaved: (value) => _title = value.trim(),
      ),
    );
  }

  Widget _contentWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'Enter Topic Content',
          labelText: 'Topic Content',
        ),
        validator: (value) =>
            value.isEmpty ? 'Topic content cannot be empty' : null,
        initialValue: _content,
        onSaved: (value) => _content = value.trim(),
      ),
    );
  }

  Widget saveButtonWidget() {
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
      final database = Firestore.instance;

      try {
        database.collection('topics').document().setData({
          'topic': _title,
          'content': _content,
          'author': '',
          'authID': '',
          'date': Timestamp.now()
        }).catchError((e) {
          print(e);
        });
      } catch (e) {
        print(e);
      }
      Navigator.pop(context);
    }
  }
}
