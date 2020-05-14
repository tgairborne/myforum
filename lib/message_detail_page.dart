import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myforum/newreply_page.dart';
import 'authentication.dart';

class MessageDetailWidget extends StatefulWidget {
  final String topicId;

  const MessageDetailWidget(this.topicId);

  @override
  _MessageDetailWidgetState createState() => new _MessageDetailWidgetState();
}

class _MessageDetailWidgetState extends State<MessageDetailWidget> {
  final _formKey = new GlobalKey<FormState>();

  String _title;
  String _content;
  String _errorMessage = "";

  bool _isIos = false;
  bool _isLoading = false;

  var userDocument;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Topic Detail'),
        ),
        body: new Column(
          children: <Widget>[_cardTopicWdiget(), _cardResponseWdiget()],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewReplyWidget(widget.topicId)),
            );
          },
        ));
  }

  Widget _cardTopicWdiget() {
    return Card(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white70,
      child: new Container(
        padding: EdgeInsets.all(20.0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new StreamBuilder(
                    stream: Firestore.instance
                        .collection('topics')
                        .document(widget.topicId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return new Text("Loading");
                      } else {
                        return new Expanded(
                            child: new Text(
                          snapshot.data['topic'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ));
                      }
                    }),
              ],
            ),
            SizedBox(height: 10),
            new Row(
              children: <Widget>[
                new StreamBuilder(
                    stream: Firestore.instance
                        .collection('topics')
                        .document(widget.topicId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return new Text("Loading");
                      } else {
                        return new Expanded(
                            child: new Text(
                          snapshot.data['content'],
                          style: TextStyle(fontSize: 15.0),
                        ));
                      }
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _cardResponseWdiget() {
    final streamQuery = Firestore.instance
        .collection('topics')
        .document(widget.topicId)
        .collection('replies')
        .orderBy('date', descending: false)
        .snapshots()
        .asBroadcastStream();
    return StreamBuilder<QuerySnapshot>(
      stream: streamQuery,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          shrinkWrap: true,
          children: snapshot.data.documents.map((document) {
            return new Card(
              margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.white70,
              child: new Container(
                padding: EdgeInsets.all(20.0),
                child: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new Text(
                          document.data['content'],
                          style: TextStyle(fontSize: 15.0),
                        )),
                      ],
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
