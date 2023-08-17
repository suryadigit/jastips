import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jastips/components/list.dart';
import 'package:cool_alert/cool_alert.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  static List<Note> notes = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: NoteListScreen(),
    );
  }
}

class AddNoteScreen extends StatefulWidget {
  final Function(Note) addNote;

  AddNoteScreen({required this.addNote});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  File? selectedImageFile;
  bool titleValid = false;
  bool authorValid = false;
  bool descriptionValid = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImageFile = File(pickedFile.path);
      });
    }
  }

  void _navigateToAddPage() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddNoteScreen(addNote: widget.addNote),
      ),
    );
  }

  void _showErrorDialog() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      title: 'Error',
      text: 'Harap isi semua data untuk menyimpan.',
      confirmBtnColor: const Color.fromARGB(255, 74, 17, 230),
      onConfirmBtnTap: _navigateToAddPage,
    );
  }

  void _showLoadingDialog() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.loading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 95, 235),
        title: Text('Tambah Data', style: TextStyle(fontSize: 15),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 112, 112, 112)
                  ),
                  child: selectedImageFile != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(selectedImageFile!),
                          radius: 50,
                        )
                      : Icon(Icons.add_a_photo, size: 40, color: Theme.of(context).brightness == Brightness.dark ? Color.fromARGB(255, 0, 0, 0) :  Color.fromARGB(255, 255, 255, 255))
                    ),
              ),
            ),
            SizedBox(height: 25),
            TextField(
              controller: titleController,
              onChanged: (value){
                setState(() {
                  titleValid = value.trim().isNotEmpty && value.length >= 5;
                });
              },
              decoration: InputDecoration(
                hintText: 'Title',
                fillColor: Colors.black.withOpacity(0.2),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: titleValid ? Colors.transparent : Colors.red),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                errorText: titleValid ? null :(titleController.text.isEmpty ? null : 'Minimal 5 Karakter'),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: authorController,
              onChanged: (value){
                setState(() {
                authorValid = value.trim().isNotEmpty && value.length  >= 5 && value.length <25;
                });
              },
              decoration: InputDecoration(
                hintText: 'Penulis',
                fillColor: Colors.black.withOpacity(0.2),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: authorValid ? Colors.transparent : Colors.red),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                errorText: authorValid ? null :(authorController.text.isEmpty ? null : 'Minimal 5-25 Karakter'),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLines: 5,
              onChanged: (value) {
                setState(() {
                  descriptionValid = value.trim().isNotEmpty && value.length >= 30;
                });
              },
              decoration: InputDecoration(
                hintText: 'Deskripsi',
                fillColor: Colors.black.withOpacity(0.2),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(252, 218, 59, 59),
                  ),
                  borderRadius: BorderRadius.circular(7.0),
                ),
                errorText: descriptionValid? null :(descriptionController.text.isEmpty? null : 'Terlalu pendek minimal 30 karakter')
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: FractionallySizedBox(
                widthFactor: 1,
                child: ElevatedButton(
                  onPressed: (titleValid && authorValid && descriptionValid) ? () async {
                    String title = titleController.text;
                    String description = descriptionController.text;
                    String author = authorController.text;

                    if (selectedImageFile == null ||
                        title.isEmpty ||
                        description.isEmpty ||
                        author.isEmpty) {
                      _showErrorDialog();
                    } else {
                      _showLoadingDialog();

                      Note newNote = Note(
                        title: title,
                        description: description,
                        avatarImagePath: selectedImageFile?.path ?? 'picker',
                        author: author,
                        date: DateTime.now(),
                      );
                      await Future.delayed(Duration(seconds: 1));

                      widget.addNote(newNote);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  } : null,
                  child: Text('Tambah'),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 74, 17, 230),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
