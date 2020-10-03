import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final Function onReload;

  const ErrorScreen({Key key, @required this.onReload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, size: MediaQuery.of(context).size.width / 4),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                "There was some error. Check your internet connection and try again",
                textAlign: TextAlign.center,),
            ),
            RaisedButton(
                child: Text(
                  "Reload",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),),
                onPressed: onReload ?? () {})
         ],
        )
    );
  }
}
