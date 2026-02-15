import 'package:flutter/material.dart';
import '../models/student.dart';

class ResultScreen extends StatelessWidget {
  final Student student;
  final VoidCallback onClear;

  const ResultScreen({super.key, required this.student, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 10),
          const Text('Seat Found!', style: TextStyle(fontSize: 20, color: Colors.green)),
          const SizedBox(height: 20),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildRow('Name', student.name),
                  const Divider(),
                  _buildRow('Course', '${student.courseCode} - ${student.courseName}'),
                  const Divider(),
                  _buildRow('Department', student.department),
                  const Divider(),
                  _buildRow('Section', student.section),
                  const Divider(),
                  _buildRow('Room', student.room, highlight: true),
                  const Divider(),
                  _buildRow('Bench', student.bench, highlight: true),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: onClear,
            child: const Text('Search Another'),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label)),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
                color: highlight ? Colors.blue : null,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}