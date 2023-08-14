// import 'package:flutter/material.dart';
// import 'package:jastips/components/list.dart';

// void main() {
//   runApp(NoteApp());
// }

// class NoteApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Note App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: NoteListScreen(),
//     );
//   }
// }

 
import 'package:flutter/material.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteListScreen(),
    );
  }
}

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
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          ).then((result) {
            if (result != null && result is Note) {
              addNote(result);
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class NoteDetailScreen extends StatefulWidget {
  final Note note;
  final VoidCallback onDelete;

  NoteDetailScreen({
    required this.note, 
    required this.onDelete});

    

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  List<Note> notes =[];
   // Fungsi untuk menambahkan catatan baru ke dalam daftar notes
  void addNote(Note note) {
    setState(() {
      notes.add(note);
    });
  }

  // Fungsi untuk menghapus catatan dari daftar notes
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
        title: Text('Note Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage(widget.note.avatarImagePath),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                widget.note.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Text(widget.note.description),
            Text(
                'Tanggal: 23 April 2023',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Penulis: Anonymous', // Tampilkan penulis sesuai data yang ada
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                                widget.onDelete(); // Panggil fungsi onDelete
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
        builder: (context) => EditNoteScreen(note: widget.note),
      ),
    );
  },
  child: Text('Edit'),
  style: ElevatedButton.styleFrom(primary: const Color.fromARGB(255, 54, 67, 244)),
),

              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String selectedAvatarImagePath = 'assets/avatar1.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedAvatarImagePath,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedAvatarImagePath = newValue;
                  });
                }
              },
              items: [
                'assets/avatar1.png',
                'assets/avatar2.png',
                // Add more avatar image paths
              ].map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(value),
                    ),
                  );
                },
              ).toList(),
            ),
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
                String title = titleController.text;
                String description = descriptionController.text;
                String avatarImagePath = selectedAvatarImagePath;
                Navigator.pop(
                  context,
                  Note(
                    title: title,
                    description: description,
                    avatarImagePath: avatarImagePath,
                  ),
                );
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}


class EditNoteScreen extends StatefulWidget {
  final Note note;

  EditNoteScreen({required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  List<Note> notes = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late String selectedAvatarImagePath;
  
  @override
  void initState() {
    super.initState();
    titleController.text = widget.note.title;
    authorController.text = '  '; // Set penulis awal
    selectedAvatarImagePath = widget.note.avatarImagePath;
    notes.add(widget.note);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    // Implement image picker logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedAvatarImagePath,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedAvatarImagePath = newValue;
                  });
                }
              },
              items: [
                DropdownMenuItem<String>(
                  value: 'assets/avatar1.png',
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar1.png'),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'assets/avatar2.png',
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar2.png'),
                  ),
                ),
                // Add more DropdownMenuItem as needed
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: authorController,
              decoration: InputDecoration(labelText: 'Penulis'),
            ),
             TextField(
              controller: authorController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Pilih Tanggal'),
                ),
                SizedBox(width: 8),
                Text(
                  'Tanggal: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _pickImage(),
              child: Text('Pilih Gambar'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Update the note with edited data
                    final editedNote = Note(
                      title: titleController.text,
                      description: widget.note.description,
                      avatarImagePath: selectedAvatarImagePath,
                    );
                    // Find the index of the edited note in the notes list
                    final index = notes.indexOf(widget.note);
                    // Update the note at the specific index
                    notes[index] = editedNote;

                    Navigator.pop(context); // Kembali ke halaman NoteListScreen
                  },
                  child: Text('Simpan'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Kembali ke halaman NoteListScreen
                  },
                  child: Text('Batal'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
