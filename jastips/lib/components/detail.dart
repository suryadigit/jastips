import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:jastips/components/edit.dart';
import 'package:jastips/components/list.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;
  final VoidCallback onDelete;
  final void Function(int, Note) onUpdate;
  List<Note> notes = [];

  NoteDetailScreen({
    required this.note,
    required this.notes,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  void onDelete() {
    widget.onDelete();
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _editNote() async {
    final updatedNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNoteScreen(
          note: widget.note,
          onUpdate: (updatedNote) {
            widget.onUpdate(widget.notes.indexOf(widget.note), updatedNote);
            Navigator.pop(context, updatedNote);
          },
        ),
      ),
    );
    if (updatedNote != null) {
      widget.onUpdate(widget.notes.indexOf(widget.note), updatedNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 95, 235),
        title: Text(
          'Detail',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Container(
                width: double.infinity,
                height: 300,
                color: Colors.black.withOpacity(0.2),
                child: Image(
                  image: FileImage(File(widget.note.avatarImagePath)),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                widget.note.title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 8),
            Text(widget.note.description),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Tanggal: ${DateFormat('dd MMMM yyyy').format(widget.note.date)}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Penulis: ${widget.note.author.length < 25 ? widget.note.author : widget.note.author.substring(0, 25) + "..."}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Dialogs.materialDialog(
                      msg: 'Anda yakin? Tindakan ini akan menghapus secara permanen.',
                      title: 'Delete',
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey[100]!
                          : Colors.grey[800]!,
                      context: context,
                      actions: [
                        IconsOutlineButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          text: 'Cancel',
                          iconData: Icons.cancel_outlined,
                          textStyle: TextStyle(
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.grey
                                : Colors.white,
                          ),
                          iconColor: Theme.of(context).brightness == Brightness.light
                              ? Colors.grey
                              : Colors.white,
                        ),
                        IconsButton(
                          onPressed: () {
                            onDelete();
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Item telah dihapus'),
                                backgroundColor: Colors.grey,
                                duration: Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'OK',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  },
                                ),
                              ),
                            );
                          },
                          text: 'Delete',
                          iconData: Icons.delete,
                          color: Colors.red,
                          textStyle: TextStyle(color: Colors.white),
                          iconColor: Colors.white,
                        ),
                      ],
                    );
                  },
                  child: Text(
                    'DELETE',
                    style: TextStyle(color: Color.fromARGB(255, 54, 67, 244), fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _editNote,
                  child: Text('EDIT'),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 74, 17, 230),
                    fixedSize: Size(90, 0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
