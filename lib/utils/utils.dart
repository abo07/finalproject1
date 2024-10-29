import 'package:flutter/material.dart';

class utils {


  Future<void> showMyDialog(context, title,data1, content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
                Text(data1),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}
