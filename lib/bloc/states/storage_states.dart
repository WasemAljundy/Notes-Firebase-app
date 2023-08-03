
import 'package:firebase_storage/firebase_storage.dart';

enum Process {
  create, delete,
}

abstract class StorageStates {}

class LoadingState extends StorageStates {}

class ReadState extends StorageStates {
  List<Reference> references;

  ReadState(this.references);
}

class ProcessState extends StorageStates {
  bool status;
  String message;
  Process process;
  ProcessState(this.status, this.message, this.process);
}