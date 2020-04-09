import 'package:flutter/material.dart';
import 'add_note_page.dart';
import 'data/firestore_service.dart';
import 'data/model/note.dart';
import 'details_page.dart';

class HomePage extends StatelessWidget {

  void _deleteNote(BuildContext context,String id) async{
    if(await _showConfirmOnDialog(context)){
      try{
        await FirestoreService().deleteNote(id);
      }catch(e){
        print('$e');
      }
    }

  }

  Future<bool> _showConfirmOnDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        content: new Text('Are you sure you want to delete Note?'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Home Page'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => {},
          icon: Icon(Icons.enhanced_encryption),
          ),
      ),
      body: StreamBuilder(
        stream: FirestoreService().getNotes,
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot){
          if(snapshot.hasError || !snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }else{
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Note note = snapshot.data[index];
              return ListTile(
                leading: Icon(Icons.note),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children : [
                    IconButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddNote(note: note, title: 'Modify Page',),
                          )
                        ),
                      icon: Icon(
                        Icons.mode_edit,
                        color: Colors.blueAccent
                        ),
                    ),

                    IconButton(
                      onPressed: () => _deleteNote(context, note.id),
                      icon: Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                        ),
                    ),                    
                  ],
                ),
                title: Text(note.title),
                subtitle: Text(note.description),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NoteDetails(note: note,),
                    )
                  );
                },
              );
             },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNote(title: 'Add Note',),
            )
          );
        },
        child: Icon(Icons.note_add),
      ),
    );
  }
}