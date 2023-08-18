import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jastips/components/add.dart';
import 'package:jastips/components/detail.dart';
import 'package:jastips/main.dart';

class Note {
  late final String title;
  late final String description;
  late final String avatarImagePath;
  late final String author;
  DateTime date;

  Note({
    required this.title,
    required this.description,
    required this.avatarImagePath,
    required this.author,
    required this.date,
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
  }

  void onUpdate(int index, Note updatedNote) {
    setState(() {
      notes[index] = updatedNote;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 95, 235),
        title: Text(
          'Home',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        ),
        toolbarHeight: 60,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 30),
        child: ListView.separated(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                final updatedNote = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteDetailScreen(
                      note: notes[index],
                      onDelete: () {
                        onDelete(index);
                        Navigator.pop(context);
                      },
                      onUpdate: (int index, updatedNote) {
                        onUpdate(index, updatedNote);
                      },
                      notes: notes,
                    ),
                  ),
                );

                if (updatedNote != null) {
                  onUpdate(index, updatedNote);
                }
              },
              child: Container(
                child: ListTile(
                  leading: CircleAvatar(
                    child: notes[index].avatarImagePath == 'picker'
                        ? Icon(Icons.add_a_photo)
                        : null,
                    backgroundImage: notes[index].avatarImagePath != 'picker'
                        ? FileImage(File(notes[index].avatarImagePath))
                        : null,
                    radius: 25,
                  ),
                  title: Text(
                    notes[index].title,
                    maxLines: 1,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    notes[index].description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 1, 235, 196),
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen(addNote: addNote)),
          );
          if (newNote != null && newNote is Note) {
            addNote(newNote);
          }
        },
        icon: Icon(Icons.add, color: Colors.black),
        label: Text(
          'CREATE',
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
      ),
    );
  }
}
