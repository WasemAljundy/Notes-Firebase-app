import 'package:firebase_app/bloc/bloc/storage_bloc.dart';
import 'package:firebase_app/bloc/states/storage_states.dart';
import 'package:firebase_app/firebase_options.dart';
import 'package:firebase_app/screens/auth/login_screen.dart';
import 'package:firebase_app/screens/auth/password/forget_password_screen.dart';
import 'package:firebase_app/screens/auth/register_screen.dart';
import 'package:firebase_app/screens/images/images_screen.dart';
import 'package:firebase_app/screens/images/upload_image_screen.dart';
import 'package:firebase_app/screens/launch_screen.dart';
import 'package:firebase_app/screens/notes_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StorageBloc>(
          create: (context) => StorageBloc(LoadingState()),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/launch_screen',
        routes: {
          '/launch_screen': (context) => const LaunchScreen(),
          '/login_screen': (context) => const LoginScreen(),
          '/register_screen': (context) => const RegisterScreen(),
          '/forget_password_screen': (context) => const ForgetPasswordScreen(),
          '/notes_screen': (context) => const NotesScreen(),
          '/images_screen': (context) => const ImagesScreen(),
          '/upload_image_screen': (context) => const UploadImageScreen(),
        },
      ),
    );
  }
}
