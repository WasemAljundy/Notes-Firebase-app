import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_app/bloc/bloc/storage_bloc.dart';
import 'package:firebase_app/bloc/events/storage_events.dart';
import 'package:firebase_app/bloc/states/storage_states.dart';
import 'package:firebase_app/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({Key? key}) : super(key: key);

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> with Helpers {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StorageBloc>(context).add(ReadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/upload_image_screen'),
            icon: const Icon(Icons.cloud_upload),
          ),
        ],
      ),
      body: BlocConsumer<StorageBloc, StorageStates>(
        listenWhen: (previous, current) =>
            current is ProcessState && current.process == Process.delete,
        listener: (context, state) {
          state as ProcessState;
          showSnackBar(
              context: context, message: state.message, error: !state.status);
        },
        buildWhen: (previous, current) =>
            current is ReadState || current is LoadingState,
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ReadState && state.references.isNotEmpty) {
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: state.references.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FutureBuilder<String>(
                    future: state.references[index].getDownloadURL(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return Stack(
                          children: [
                            CachedNetworkImage(
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              cacheKey: state.references[index].fullPath,
                              imageUrl: snapshot.data!,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            Align(
                              alignment: AlignmentDirectional.bottomCenter,
                              child: Container(
                                height: 50,
                                color: Colors.black38,
                                alignment: AlignmentDirectional.centerEnd,
                                child: IconButton(
                                  onPressed: () => showDeleteDialog(
                                      filePath:
                                          state.references[index].fullPath),
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red.shade800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                          child: Icon(
                            Icons.image,
                            size: 50,
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning,
                    size: 85,
                    color: Colors.grey,
                  ),
                  Text(
                    'NO DATA!',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> deleteImage({required String filePath}) async {
    BlocProvider.of<StorageBloc>(context).add(DeleteEvent(filePath));
    Navigator.pop(context);
  }

  Future<void> showDeleteDialog({required String filePath}) async {
    Dialogs.materialDialog(
      msg: 'Are you sure to delete this image?\nYou can\'t undo this !',
      title: 'Delete',
      color: Colors.white,
      titleStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      msgStyle: const TextStyle(fontSize: 17),
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () => Navigator.pop(context),
          text: 'Cancel',
          iconData: Icons.cancel_outlined,
          textStyle: const TextStyle(color: Colors.grey),
          iconColor: Colors.grey,
        ),
        IconsButton(
          onPressed: () => deleteImage(filePath: filePath),
          text: 'Delete',
          iconData: Icons.delete,
          color: Colors.red,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }
}
