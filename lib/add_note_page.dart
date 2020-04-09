import 'package:flutter/material.dart';
import 'data/firestore_service.dart';
import 'data/model/note.dart';

class AddNote extends StatefulWidget {

  final Note note;
  final String title;
  AddNote({this.note,this.title});

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();
  String _title, _description;
  FocusNode _focusNode;

  @override
  void initState() { 
    super.initState();
    _focusNode = FocusNode();
    if(widget.title == 'Modify Page'){
      _titleController = TextEditingController(text: widget.note != null ? widget.note.title : '');
      _descriptionController = TextEditingController(text: widget.note != null ? widget.note.description : '');
    }
  }

  bool validateAndSave() {
    final form = _formKey .currentState;
    if(form.validate()){
      form.save();
      return true;
    }else{
      return false;
    }
  }

  void validateAndSubmit() async{
    if(validateAndSave()){
      if(widget.title == 'Modify Page'){
        
        try{
          Note note = Note(title: _title, description: _description,id: widget.note.id);
          await FirestoreService().updateNote(note);
        }catch(e){
          print('$e');
        }

      }else{
        try{

          await FirestoreService().addNote(
            Note(description: _description, title: _title),
          );

        }catch(e){
          print('$e');
        }        
      }
      Navigator.of(context).pop();
    }else{
      print('Form Invalid');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(widget.title),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(20.0,30.0,20.0,0.0),
              child: Column(
                children: _buildForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildForm(){
    return [
       TextFormField(
         controller: _titleController,
         textInputAction: TextInputAction.next,
         onEditingComplete: (){
           FocusScope.of(context).requestFocus(_focusNode);
         },
         decoration: InputDecoration(
           hintText: 'Title',
           border: OutlineInputBorder(),
         ),
         maxLines: 1,
         validator: (value) => value.isEmpty ? 'Title is empty!': null,
         onSaved: (title) => _title = title.toString().trim(),
       ),

       SizedBox(height: 10.0,),
       
       TextFormField(
         controller: _descriptionController,
         focusNode: _focusNode,
         decoration: InputDecoration(
           hintText: 'Description',
           border: OutlineInputBorder(),
           ),
         maxLines: 4,
         validator: (value) => value.isEmpty ? 'Description is empty!': null,
         onSaved: (value) => _description = value.toString().trim(),
       ),

      SizedBox(height: 10.0,),

      Align(
        alignment: Alignment.bottomLeft,
        child: RaisedButton.icon(
          onPressed: validateAndSubmit,
          shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
          side: BorderSide(color: widget.title == 'Modify Page'? Colors.yellowAccent : Colors.blueAccent)),
          icon: Icon(
            Icons.note_add,
            color: Colors.white,
          ),
          label: new Text(
             widget.title == 'Modify Page' ? 'Update' : 'Save',
             style: TextStyle(
               color: Colors.white,
             ),
          ),
          color: widget.title == 'Modify Page'? Colors.amber : Colors.blue,
         ),
       )
    ];
  }
}