import 'package:flutter/material.dart';
import 'package:jastips/components/edit.dart';
import 'package:jastips/components/list.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;

  NoteDetailScreen({required this.note, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar and title UI here
            SizedBox(height: 16),
            Text(
              note.description,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Tanggal: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Penulis: [Nama Penulis]', // Ganti dengan nama penulis sesuai kebutuhan
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Hapus Catatan'),
                      content: Text('Apakah Anda yakin ingin menghapus catatan ini?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Menutup dialog
                          },
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            onDelete(); // Panggil fungsi onDelete
                            Navigator.of(context).pop(); // Menutup dialog
                            Navigator.pop(context); // Kembali ke halaman sebelumnya (NoteListScreen)
                          },
                          child: Text('Hapus'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Hapus'),
              style: ElevatedButton.styleFrom(primary: Colors.red),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditNoteScreen(note: note),
                  ),
                ).then((editedNote) {
                  if (editedNote != null && editedNote is Note) {
                    // Update the note after editing
                    // You need to implement a way to update the note in your notes list
                  }
                });
              },
              child: Text('Edit'),
              style: ElevatedButton.styleFrom(primary: const Color.fromARGB(255, 54, 67, 244)),
            ),
          ],
        ),
      ),
    );
  }
}

 
 