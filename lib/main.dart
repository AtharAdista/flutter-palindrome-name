import 'package:flutter/material.dart';
import 'package:flutter_palindrome_name/view_models/palindrome_viewmodel.dart';
import 'package:flutter_palindrome_name/view_models/user_viewmodel.dart';
import 'package:flutter_palindrome_name/views/first_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PalindromeViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVVM Flutter App',
      home: const FirstScreen(),
    );
  }
}
