import 'dart:io';
import 'package:firebase_app/bloc/bloc/storage_bloc.dart';
import 'package:firebase_app/bloc/events/storage_events.dart';
import 'package:firebase_app/bloc/states/storage_states.dart';
import 'package:firebase_app/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> with Helpers {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedFile;
  double? _linearProgressValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: BlocListener<StorageBloc, StorageStates>(
        listenWhen: (previous, current) => current is ProcessState && current.process == Process.create,
        listener: (context, state) {
          state as ProcessState;
          showSnackBar(context: context, message: state.message, error: !state.status);
          _changeProgressValue(value: state.status ? 1 : 0);
        },
        child: Column(
          children: [
            LinearProgressIndicator(
              minHeight: 10,
              color: Colors.green,
              backgroundColor: Colors.blue.shade300,
              value: _linearProgressValue,
            ),
            Expanded(
              child: _pickedFile != null
                  ? Image.file(File(_pickedFile!.path))
                  : TextButton(
                onPressed: () async => await _pickImage(),
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: const Text('Pick Image to Upload'),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async => await performUpload(),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.cloud_upload),
              label: const Text(
                'UPLOAD',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    XFile? imageFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (imageFile != null) {
      setState(() {
        _pickedFile = imageFile;
      });
    }
  }

  Future<void> performUpload() async {
    if (checkData()) {
      await uploadImage();
    }
  }

  bool checkData() {
    if (_pickedFile != null) {
      return true;
    }
    showSnackBar(
      context: context,
      message: 'Select Image to upload!',
      error: true,
    );
    return false;
  }

  Future<void> uploadImage() async {
    _changeProgressValue(value: null);
    BlocProvider.of<StorageBloc>(context).add(CreateEvent(_pickedFile!.path));
  }

  void _changeProgressValue({double? value}) {
    setState(() {
      _linearProgressValue = value;
    });
  }
}
