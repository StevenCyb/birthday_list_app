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
      context: context,
      builder: (BuildContext context) {
        return EditEntryModal(editRecord: record);
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
    setState(() {
      _nameFieldController.text = widget.editRecord?.name ?? '';
      _bday = widget.editRecord?.date ?? DateTime.now();
      _isNameValid = _nameFieldController.text.length >= 3;
      _pickedImage = widget.editRecord?.image;
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
                                  context
                                      .read<StorageService>()
                                      .replace(
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
