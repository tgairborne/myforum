import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final titles = [
      'Mike Downson',
      'Jamie Carragher',
      'Theo Wallet',
      'Henry Henderson',
      'William Parker',
      'Mahsun Saya',
      'Jeremy Watson',
      'Amy Malinson',
      'Joe Fiddler'
    ];

    return Container(
        child: new ListView.builder(
      itemCount: titles.length,
      itemBuilder: (context, index) {
        return Card(
          //                           <-- Card widget
          child: ListTile(
            leading: Icon(Icons.message),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text(titles[index]),
            onTap: () {
              print('Sun');
            },
          ),
        );
      },
    ));
  }
}
