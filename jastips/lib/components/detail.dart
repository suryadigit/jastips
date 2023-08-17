import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jastips/components/edit.dart';
import 'package:jastips/components/list.dart';
import 'package:cool_alert/cool_alert.dart';

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
                  'Penulis: ${widget.note.author.length <25 ? widget.note.author : widget.note.author.substring(0, 25) + "..."}',
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
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.confirm,
                      title: 'Hapus Catatan',
                      confirmBtnText: 'DELETE',
                      cancelBtnText: 'CANCEL',
                      confirmBtnColor: Color.fromARGB(255, 54, 67, 244),
                      onConfirmBtnTap: () {
                        onDelete();
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
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
