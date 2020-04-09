import 'package:flutter/material.dart';
import 'data/model/note.dart';

class NoteDetails extends StatefulWidget {

  final Note note;

  const NoteDetails({Key key, @required this.note}) : super(key: key);
  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Note Details'),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB (20.0,30.0,20.0,0.0),
          child: Column(
            children: <Widget>[
              Text(widget.note.title, style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0
              ),),
              SizedBox(height: 30.0,),
              Text(widget.note.description,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}