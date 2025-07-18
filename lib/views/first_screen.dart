import 'package:flutter/material.dart';
import 'package:flutter_palindrome_name/view_models/palindrome_viewmodel.dart';
import 'package:provider/provider.dart';

import 'second_screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late TextEditingController nameController;
  late TextEditingController sentenceController;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<PalindromeViewModel>();
    nameController = TextEditingController(text: viewModel.name);
    sentenceController = TextEditingController(text: viewModel.sentence);

    nameController.addListener(() {
      viewModel.updateName(nameController.text);
    });
    sentenceController.addListener(() {
      viewModel.updateSentence(sentenceController.text);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    sentenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PalindromeViewModel>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset('assets/images/background.png', fit: BoxFit.cover),

          // Foreground content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white24,
                      backgroundImage: AssetImage("assets/images/ic_photo.png"),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: nameController,
                            hintText: "Name",
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: sentenceController,
                            hintText: "Palindrome",
                          ),
                          const SizedBox(height: 30),
                          _buildButton(
                            text: 'CHECK',
                            onPressed: () {
                              final result = viewModel.isPalindrome();
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(
                                    result ? 'Palindrome' : 'Not Palindrome',
                                  ),
                                  content: Text(
                                    result
                                        ? 'isPalindrome'
                                        : 'not palindrome',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildButton(
                            text: 'NEXT',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SecondScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2B637B),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
