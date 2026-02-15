import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CretCom Exam Seating'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Icon(Icons.school, size: 80, color: Colors.blue),
                        const SizedBox(height: 20),
                        const Text(
                          'Enter Student ID',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30),
                        
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    labelText: 'Student ID',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    prefixIcon: const Icon(Icons.person),
                                  ),
                                  onSubmitted: (value) {
                                    if (value.isNotEmpty) state.searchStudent(value);
                                  },
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: state.isLoading ? null : () {
                                      if (_controller.text.isNotEmpty) {
                                        state.searchStudent(_controller.text);
                                      }
                                    },
                                    child: state.isLoading
                                        ? const CircularProgressIndicator(color: Colors.white)
                                        : const Text('Check Seat'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        if (state.error != null)
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.all(16),
                            color: Colors.red.shade50,
                            child: Row(
                              children: [
                                Icon(Icons.error, color: Colors.red.shade700),
                                const SizedBox(width: 10),
                                Expanded(child: Text(state.error!)),
                              ],
                            ),
                          ),
                        
                        if (state.student != null)
                          ResultScreen(
                            student: state.student!,
                            onClear: () {
                              _controller.clear();
                              state.clear();
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}