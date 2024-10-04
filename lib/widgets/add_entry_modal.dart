import 'package:bday/widgets/edit_entry.dart';
import 'package:flutter/material.dart';

class AddEntryModal extends StatefulWidget {
  const AddEntryModal({super.key});

  @override
  AddEntryModalState createState() => AddEntryModalState();
}

class AddEntryModalState extends State<AddEntryModal> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: const Icon(Icons.add),
      onPressed: () {
        EditDialog.show(context);
      },
    );
  }
}
