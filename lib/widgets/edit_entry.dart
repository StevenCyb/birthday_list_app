import 'package:bday/models/bday_record.dart';
import 'package:bday/services/storage_service.dart';
import 'package:bday/theme/assets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'date_picker.dart';

class EditDialog {
  static void show(BuildContext context, {BDayRecord? record}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: EditEntryModal(editRecord: record),
        );
      },
    );
  }
}

class EditEntryModal extends StatefulWidget {
  final BDayRecord? editRecord;
  const EditEntryModal({super.key, this.editRecord});

  @override
  EditEntryModalState createState() => EditEntryModalState();
}

class EditEntryModalState extends State<EditEntryModal> {
  DateTime _bday = DateTime.now();
  final TextEditingController _nameFieldController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  bool _isNameValid = false;

  void _resetImage() {
    var name = widget.editRecord?.name ?? '';
    if (_nameFieldController.text.isNotEmpty) {
      name = _nameFieldController.text;
    }

    var image = widget.editRecord?.image;
    if (_pickedImage != null) {
      image = _pickedImage;
    }

    var date = widget.editRecord?.date ?? DateTime.now();
    if (_bday != DateTime.now()) {
      date = _bday;
    }

    setState(() {
      _nameFieldController.text = name;
      _bday = date;
      _isNameValid = name.length >= 3;
      _pickedImage = image;
    });
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Entry"),
          content: Text("Delete entry of \"${widget.editRecord!.name}\"?"),
          actions: [
            TextButton(
              child: const Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("YES"),
              onPressed: () {
                context.read<StorageService>().remove(widget.editRecord!.name);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _resetImage();

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 50,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setModalState(() {
                              _isNameValid = value.length >= 3;
                            });
                          },
                          controller: _nameFieldController,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Name',
                            hintStyle: const TextStyle(
                              fontSize: 20,
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () async {
                          final XFile? image = await _picker.pickImage(
                              maxHeight: 100,
                              maxWidth: 100,
                              source: ImageSource.gallery);
                          if (image != null) {
                            setModalState(() {
                              _pickedImage = File(image.path);
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: _pickedImage == null
                              ? AssetsTheme.defaultProfile(context)
                              : FileImage(_pickedImage!),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                            child: DatePicker(
                          onDateChanged: (value) {
                            _bday = value;
                          },
                          initialDate: _bday,
                        )),
                        if (widget.editRecord != null)
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _showDeleteDialog(context);
                            },
                            child: const Icon(Icons.delete),
                          ),
                        OutlinedButton(
                          onPressed: _isNameValid
                              ? () {
                                  if (widget.editRecord != null) {
                                    context
                                        .read<StorageService>()
                                        .remove(widget.editRecord!.name)
                                        .catchError(
                                      (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(e.message),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  }
                                  context
                                      .read<StorageService>()
                                      .add(
                                        BDayRecord(
                                          name: _nameFieldController.text,
                                          date: _bday,
                                          image: _pickedImage,
                                        ),
                                      )
                                      .catchError(
                                    (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(e.message),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                  Navigator.of(context).pop();
                                }
                              : null,
                          child: const Icon(Icons.check),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
