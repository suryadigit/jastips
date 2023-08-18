import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:jastips/components/list.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;
  final Function(Note) onUpdate;

  EditNoteScreen({required this.note, required this.onUpdate});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late String selectedAvatarImagePath;
  File? pickedImageFile;
  bool titleValid = true;
  bool authorValid = true;
  bool descriptionValid = true;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.note.title;
    authorController.text = widget.note.author;
    descriptionController.text = widget.note.description;
    selectedAvatarImagePath = widget.note.avatarImagePath;
    selectedDate = widget.note.date;
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

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        pickedImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _showImagePicker(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 95, 235),
        title: Text(
          'Edit',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      onChanged: (value) {
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
                        errorText: titleValid ? null : (titleController.text.isEmpty ? null : 'Minimal 5 Karakter'),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: authorController,
                      onChanged: (value) {
                        setState(() {
                          authorValid = value.trim().isNotEmpty && value.length >= 5;
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
                        errorText: authorValid ? null : (authorController.text.isEmpty ? null : 'Minimal 5 Karakter'),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      maxLines: 5,
                      onChanged: (value) {
                        setState(() {
                          descriptionValid = value.trim().isEmpty || value.length >= 30;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Description',
                        fillColor: Colors.black.withOpacity(0.2),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(252, 218, 59, 59),
                          ),
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        errorText: descriptionValid ? null : 'Deskripsi terlalu pendek minimal 30 karakter',
                      ),
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 15.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tanggal: ${DateFormat('dd MMMM yyyy').format(selectedDate)}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(width: 10.0),
                            Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () => _showImagePicker(context),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 230,
                          color: Colors.black.withOpacity(0.2),
                          child: Stack(
                            children: [
                              Center(
                                child: pickedImageFile != null
                                    ? Image.file(File(pickedImageFile!.path))
                                    : selectedAvatarImagePath.isNotEmpty
                                        ? Image.file(File(selectedAvatarImagePath))
                                        : Icon(Icons.add_a_photo),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    primary: Color.fromARGB(255, 74, 17, 230),
                  ),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: (titleValid && authorValid && descriptionValid)
                      ? () {
                          final editedNote = Note(
                            title: titleController.text,
                            author: authorController.text,
                            description: descriptionController.text,
                            date: selectedDate,
                            avatarImagePath: pickedImageFile != null
                                ? pickedImageFile!.path
                                : selectedAvatarImagePath,
                          );
                          widget.onUpdate(editedNote);
                          Navigator.pop(context, editedNote);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 74, 17, 230),
                    fixedSize: Size(90, 0),
                  ),
                  child: Text('SAVE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
