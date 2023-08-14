import 'package:flutter/material.dart';
import 'package:jastips/components/detail.dart';
import 'package:jastips/components/edit.dart';

class Note {
  final String title;
  final String description;
  final String avatarImagePath;

  Note({
    required this.title,
    required this.description,
    required this.avatarImagePath,
  });
}

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> notes = [];

  void addNote(Note note) {
    setState(() {
      notes.add(note);
    });
  }

  void onDelete(int index) {
    setState(() {
      notes.removeAt(index);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView.separated(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteDetailScreen(
                    note: notes[index],
                    onDelete: () {
                      onDelete(index);
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundImage: AssetImage(notes[index].avatarImagePath),
            ),
            title: Text(notes[index].title),
            subtitle: Text(notes[index].description),
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNoteScreen(note: Note(title: '', description: '', avatarImagePath: '')), // Ganti yourNoteObject dengan objek Note yang sesuai
      ),
    ).then((editedNote) {
      if (editedNote != null && editedNote is Note) {
        // Update the note after editing
        // Anda perlu mengimplementasikan cara untuk memperbarui catatan di dalam daftar notes
      }
    });
  },
  child: Icon(Icons.add),
),

    );
  }
}
 