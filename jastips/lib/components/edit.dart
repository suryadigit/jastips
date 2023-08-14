import 'package:flutter/material.dart';
import 'package:jastips/components/list.dart';


class EditNoteScreen extends StatefulWidget {
  final Note note;

  EditNoteScreen({required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.note.title;
    descriptionController.text = widget.note.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your avatar selection and image logic here
            SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String newTitle = titleController.text;
                String newDescription = descriptionController.text;
                Note editedNote = Note(
                  title: newTitle,
                  description: newDescription,
                  avatarImagePath: widget.note.avatarImagePath,
                );
                Navigator.pop(context, editedNote);
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
