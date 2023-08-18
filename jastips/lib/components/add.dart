import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:jastips/components/list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';

class AddNoteScreen extends StatefulWidget {
    final Function(Note)addNote;

    AddNoteScreen({required this.addNote});

    @override _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
    TextEditingController titleController = TextEditingController();
    TextEditingController authorController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    File
        ? pickedImageFile;
    String selectedAvatarImagePath = '';
    bool titleValid = false;
    bool authorValid = false;
    bool descriptionValid = false;

    Future<void> _selectDate(BuildContext context)async {
        final DateTime? picked = await showDatePicker(context
        : context, initialDate
        : selectedDate, firstDate
        : DateTime(2000), lastDate
        : DateTime(2101),);
        if (picked != null && picked != selectedDate) {
            setState(() {
                selectedDate = picked;
            });
        }
    }

    Future<void> _pickImage(ImageSource source)async {
        final pickedFile = await ImagePicker().pickImage(source
        : source);

        if (pickedFile != null) {
            setState(() {
                pickedImageFile = File(pickedFile.path);
            });
        }
    }

    Future<void> _showImagePicker(BuildContext context) {
        return showModalBottomSheet(context
        : context, builder
        : (BuildContext context) {
            return SafeArea(child
            : Wrap(children
            : [
                ListTile(leading
                : Icon(Icons.photo_library), title
                : Text('Choose from Gallery'), onTap
                : () {
                    _pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                },),
                ListTile(leading
                : Icon(Icons.camera_alt), title
                : Text('Take a Photo'), onTap
                : () {
                    _pickImage(ImageSource.camera);
                    Navigator.pop(context);
                },)
            ],),);
        },);
    }

    void _showErrorDialog() {
        CoolAlert.show(context
        : context, type
        : CoolAlertType.error, title
        : 'Error', text
        : 'Pastikan data dan gambar terisi.', confirmBtnColor
        : const Color.fromARGB(255, 74, 17, 230), onConfirmBtnTap
            : () {
                Navigator.pop(context);
            },);
        }

        @override Widget build(BuildContext context) {
            return Scaffold(appBar
            : AppBar(backgroundColor
            : Color.fromARGB(255, 1, 95, 235), title
            : Text('Add Data', style
            : TextStyle(fontSize
            : 15, fontWeight
            : FontWeight.w400),),), body
            : Padding(padding
            : const EdgeInsets.all(16.0), child
                : Column(crossAxisAlignment
                : CrossAxisAlignment.start, children
                : [
                        SizedBox(height
                    : 16),
                    Expanded(child
                    : SingleChildScrollView(child
                    : Column(crossAxisAlignment
                    : CrossAxisAlignment.start, children
                    : [
                            TextField(controller
                        : titleController, onChanged
                        : (value) {
                            setState(() {
                                titleValid = value
                                    .trim()
                                    .isNotEmpty && value.length >= 5;
                            });
                        }, decoration
                        : InputDecoration(
                            hintText
                            : 'Title',
                            fillColor
                            : Colors.black.withOpacity(0.2),
                            filled
                            : true,
                            border
                            : OutlineInputBorder(borderSide
                            : BorderSide(
                                color
                                    : titleValid
                                    ? Colors.transparent
                                    : Colors.red
                            ), borderRadius
                                : BorderRadius.circular(5.0),),
                            errorText
                                : titleValid
                                ? null
                                : (
                                    titleController.text.isEmpty
                                        ? null
                                        : 'Minimal 5 Karakter'
                                ),
                        ),),
                        SizedBox(height
                        : 15),
                        TextField(controller
                        : authorController, onChanged
                        : (value) {
                            setState(() {
                                authorValid = value
                                    .trim()
                                    .isNotEmpty && value.length >= 5;
                            });
                        }, decoration
                        : InputDecoration(
                            hintText
                            : 'Penulis',
                            fillColor
                            : Colors.black.withOpacity(0.2),
                            filled
                            : true,
                            border
                            : OutlineInputBorder(borderSide
                            : BorderSide(
                                color
                                    : authorValid
                                    ? Colors.transparent
                                    : Colors.red
                            ), borderRadius
                                : BorderRadius.circular(5.0),),
                            errorText
                                : authorValid
                                ? null
                                : (
                                    authorController.text.isEmpty
                                        ? null
                                        : 'Minimal 5 Karakter'
                                ),
                        ),),
                        SizedBox(height
                        : 12),
                        TextField(controller
                        : descriptionController, maxLines
                        : 5, onChanged
                        : (value) {
                            setState(() {
                                descriptionValid = value
                                    .trim()
                                    .isNotEmpty && value.length >= 30;
                            });
                        }, decoration
                        : InputDecoration(
                            hintText
                                : 'Description',
                            fillColor
                                : Colors.black.withOpacity(0.2),
                            filled
                                : true,
                            border
                                : OutlineInputBorder(borderSide
                                : BorderSide(color
                                : Color.fromARGB(252, 218, 59, 59),), borderRadius
                                : BorderRadius.circular(7.0),),
                            errorText
                                : descriptionValid
                                ? null
                                : (
                                    descriptionController.text.isEmpty
                                        ? null
                                        : 'Deskripsi terlalu pendek minimal 30 karakter'
                                ),
                        ),),
                        SizedBox(height
                        : 12),
                        GestureDetector(onTap
                        : () => _selectDate(context), child
                        : Container(decoration
                        : BoxDecoration(color
                        : Colors.black.withOpacity(0.2), borderRadius
                        : BorderRadius.circular(3.0),), padding
                        : EdgeInsets.symmetric(horizontal
                        : 15.0, vertical
                        : 15.0,), child
                        : Row(mainAxisAlignment
                        : MainAxisAlignment.spaceBetween, children
                        : [
                            Text('Tanggal: ${DateFormat(' dd MMMM yyyy ').format(selectedDate)}', style
                            : TextStyle(fontSize
                            : 14),),
                            SizedBox(width
                            : 10.0),
                            Icon(Icons.calendar_today)
                        ],),),),
                        SizedBox(height
                        : 12),
                        GestureDetector(onTap
                        : () => _showImagePicker(context), child
                        : Center(child
                        : Container(width
                        : MediaQuery.of(context).size.width * 0.9, height
                        : 230, color
                        : Colors.black.withOpacity(0.2), child
                        : Stack(children
                        : [Center(
                                child
                                    : pickedImageFile != null
                                    ? Image.file(File(pickedImageFile !.path))
                                    : selectedAvatarImagePath.isNotEmpty
                                        ? Image.file(File(selectedAvatarImagePath))
                                        : Icon(Icons.add_a_photo),
                            )],),),),),
                        SizedBox(height
                        : 30),
                        Center(child
                        : FractionallySizedBox(widthFactor
                        : 1, child
                        : ElevatedButton(
                            onPressed
                                : (titleValid && authorValid && descriptionValid && pickedImageFile != null)
                                ? ()async {
                                    String title = titleController.text;
                                    String description = descriptionController.text;
                                    String author = authorController.text;
                                    if (title.isEmpty || description.isEmpty || author.isEmpty) {
                                        _showErrorDialog();
                                    } else {
                                        Note newNote = Note(
                                            title
                                                : title,
                                            description
                                                : description,
                                            avatarImagePath
                                                : pickedImageFile
                                                ?.path ?? '',
                                            author: author,
                                            date: selectedDate,
                                        );

                                        widget.addNote(newNote);
                                        Navigator.pop(context);
                                    }
                                }
                                : null,
                            child: Text('ADD DATA'),
                            style: ElevatedButton.styleFrom(primary
                            : const Color.fromARGB(255, 74, 17, 230), padding
                                : EdgeInsets.symmetric(vertical
                                : 16),),
                        )))
                        ],),),)
                    ],),),);
                }
            }
