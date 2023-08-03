import 'package:firebase_app/bloc/events/storage_events.dart';
import 'package:firebase_app/bloc/states/storage_states.dart';
import 'package:firebase_app/controllers/fb_storage_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StorageBloc extends Bloc<StorageEvents, StorageStates> {
  final List<Reference> _references = <Reference>[];
  final FbStorageController _fbStorageController = FbStorageController();

  StorageBloc(super.initialState) {
    on<CreateEvent>(_onCreateEvent);
    on<ReadEvent>(_onReadEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  void _onCreateEvent(CreateEvent event, Emitter emitter) async {
    await _fbStorageController.uploadImage(path: event.filePath).listen((event) {
      if (event.state == TaskState.error) {
        emitter(ProcessState(false, 'Image Upload Failed', Process.create));
      } else if (event.state == TaskState.success) {
        emitter(
            ProcessState(true, 'Image Upload Successfully', Process.create));
        _references.add(event.ref);
        emitter(ReadState(_references));
      }
    }).asFuture();
  }

  void _onReadEvent(ReadEvent event, Emitter emitter) async {
    List<Reference> references = await _fbStorageController.read();
    _references.addAll(references);
    emitter(ReadState(_references));
  }

  void _onDeleteEvent(DeleteEvent event, Emitter emitter) async {
    bool deleted = await _fbStorageController.delete(path: event.filePath);
    if (deleted) {
      int index = _references
          .indexWhere((element) => element.fullPath == event.filePath);
      if (index != -1) {
        _references.removeAt(index);
        emitter(ReadState(_references));
      }
    }
    emitter(ProcessState(
      deleted,
      deleted ? 'Delete Successfully' : 'Delete Failed!',
      Process.delete,
    ));
  }
}
