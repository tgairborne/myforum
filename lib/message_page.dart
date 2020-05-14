import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myforum/message_detail_page.dart';
import 'package:myforum/newmessage_page.dart';

class MessageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final streamQuery =
        Firestore.instance.collection('topics').snapshots().asBroadcastStream();

    return Scaffold(
        body: new Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: streamQuery,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return new Text('Loading...');
                return new ListView(
                  shrinkWrap: true,
                  children: snapshot.data.documents.map((document) {
                    return new ListTile(
                      leading: Icon(Icons.message),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      title: new Text(document['topic']),
                      subtitle: new Text('By :' +
                          document['author'] +
                          ' on ' +
                          document['date'].toDate().toString()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MessageDetailWidget(document.documentID)),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewMessageWidget()),
            );
          },
        ));
  }
}
