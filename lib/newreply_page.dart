import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'authentication.dart';

class NewReplyWidget extends StatefulWidget {

  final String topicId;

  const NewReplyWidget(this.topicId);

  @override
  _NewReplyWidgetState createState() => new _NewReplyWidgetState();
}

class _NewReplyWidgetState extends State<NewReplyWidget> {
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
        title: new Text('Add Reply'),
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
          _contentWidget(),
          saveButtonWidget()
        ],
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
          hintText: 'Enter Reply Content',
          labelText: 'Reply Content',
        ),
        validator: (value) =>
            value.isEmpty ? 'Reply content cannot be empty' : null,
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
            child: new Text('Add Reply',
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
        database.collection('topics').document(widget.topicId).collection('replies').document().setData({
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
