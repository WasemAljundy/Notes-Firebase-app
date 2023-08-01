import 'package:firebase_app/controllers/fb_firestore_controller.dart';
import 'package:firebase_app/helpers/helpers.dart';
import 'package:firebase_app/models/note.dart';
import 'package:firebase_app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({
    super.key,
    this.title = 'Create',
    this.note,
  });

  final String title;
  final Note? note;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> with Helpers {
  late TextEditingController _titleTextController;
  late TextEditingController _detailsTextController;

  @override
  void initState() {
    super.initState();
    _titleTextController = TextEditingController(text: widget.note?.title ?? '');
    _detailsTextController = TextEditingController(text: widget.note?.details ?? '');
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _detailsTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        children: [
          AppTextField(
            controller: _titleTextController,
            hint: 'Title',
            prefixIcon: Icons.title,
          ),
          const SizedBox(
            height: 10,
          ),
          AppTextField(
            controller: _detailsTextController,
            hint: 'Details',
            prefixIcon: Icons.details,
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () async => await performProcess(),
            style: ElevatedButton.styleFrom(
              maximumSize: const Size(double.infinity, double.infinity),
            ),
            child: const Text(
              'SAVE',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> performProcess() async {
    if (checkData()) {
      await process();
    }
  }

  bool checkData() {
    if (_titleTextController.text.isNotEmpty &&
        _detailsTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(
      context: context,
      message: 'Please Enter Required Data!',
      error: true,
    );
    return false;
  }

  Future<void> process() async {
    bool status = widget.note == null
        ? await FbFireStoreController().create(note: note)
        : await FbFireStoreController().update(note: note);
    if (status) {
      if (context.mounted && widget.note != null) {
        Navigator.pop(context);
      } else {
        clear();
      }
    }
    if (context.mounted) {
      showSnackBar(
        context: context,
        message: status ? 'Process Success' : 'Process Failed',
        error: !status,
      );
    }
  }

  Note get note {
    Note note = widget.note == null ? Note() : widget.note!;
    note.title = _titleTextController.text;
    note.details = _detailsTextController.text;
    return note;
  }

  void clear() {
    _titleTextController.text = '';
    _detailsTextController.text = '';
  }
}
